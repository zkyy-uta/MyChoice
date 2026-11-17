alter table public.pengguna
  add column if not exists status_akun text not null default 'aktif';

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'pengguna_status_akun_check'
      and conrelid = 'public.pengguna'::regclass
  ) then
    alter table public.pengguna
      add constraint pengguna_status_akun_check
      check (status_akun in ('aktif', 'nonaktif'));
  end if;
end
$$;

create or replace function public.is_admin_user()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.pengguna
    where id_pengguna = (select auth.uid())
      and role = 'admin'
      and status_akun = 'aktif'
  );
$$;

revoke all on function public.is_admin_user() from public;
grant execute on function public.is_admin_user() to authenticated;

grant insert, update, delete on public.sub_kategori,
  public.pilihan_katalog, public.kriteria to authenticated;
grant usage, select on sequence public.sub_kategori_id_sub_kategori_seq,
  public.kriteria_id_kriteria_seq to authenticated;

do $$
declare
  table_name text;
begin
  foreach table_name in array array['sub_kategori', 'pilihan_katalog', 'kriteria']
  loop
    execute format(
      'drop policy if exists %I on public.%I',
      table_name || '_manage_admin',
      table_name
    );
    execute format(
      'create policy %I on public.%I for all to authenticated using (public.is_admin_user()) with check (public.is_admin_user())',
      table_name || '_manage_admin',
      table_name
    );
  end loop;
end
$$;

drop policy if exists decision_histories_admin_read
  on public.decision_histories;
create policy decision_histories_admin_read
  on public.decision_histories
  for select to authenticated
  using (public.is_admin_user());

drop policy if exists decision_history_reviews_admin_read
  on public.decision_history_reviews;
create policy decision_history_reviews_admin_read
  on public.decision_history_reviews
  for select to authenticated
  using (public.is_admin_user());

create or replace function public.admin_update_user_access(
  p_target_user_id uuid,
  p_role text,
  p_plan text
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  target public.pengguna;
begin
  if not public.is_admin_user() then
    raise exception using errcode = '42501', message = 'ADMIN_REQUIRED';
  end if;
  if p_role is null or p_plan is null
    or p_role not in ('user', 'admin')
    or p_plan not in ('basic', 'premium') then
    raise exception using errcode = '22023', message = 'INVALID_ACCESS_SETTINGS';
  end if;

  select *
    into target
    from public.pengguna
    where id_pengguna = p_target_user_id
    for update;
  if not found then
    raise exception using errcode = 'P0002', message = 'USER_NOT_FOUND';
  end if;
  if target.id_pengguna = (select auth.uid()) and p_role <> 'admin' then
    raise exception using errcode = '42501', message = 'CANNOT_DEMOTE_SELF';
  end if;
  if target.role = 'admin' and p_role = 'user' and (
    select count(*)
    from public.pengguna
    where role = 'admin' and status_akun = 'aktif'
  ) <= 1 then
    raise exception using errcode = '23514', message = 'LAST_ACTIVE_ADMIN';
  end if;

  update public.pengguna
    set role = p_role, plan = p_plan
    where id_pengguna = p_target_user_id
    returning * into target;
  return to_jsonb(target);
end
$$;

revoke all on function public.admin_update_user_access(uuid, text, text)
  from public;
grant execute on function public.admin_update_user_access(uuid, text, text)
  to authenticated;

create table if not exists public.decision_daily_usage (
  user_id uuid not null references auth.users(id) on delete cascade,
  local_date date not null,
  decision_count integer not null check (decision_count >= 0),
  primary key (user_id, local_date)
);

alter table public.decision_daily_usage enable row level security;
revoke all on public.decision_daily_usage from anon, authenticated;

create or replace function public.create_user_decision_history(
  p_category text,
  p_subcategory text,
  p_title text,
  p_score double precision,
  p_final_option text,
  p_decision_date timestamptz,
  p_priorities jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  current_user_id uuid := (select auth.uid());
  current_role text;
  current_plan text;
  account_status text;
  today_jakarta date := (clock_timestamp() at time zone 'Asia/Jakarta')::date;
  day_start timestamptz;
  day_end timestamptz;
  existing_count integer;
  created public.decision_histories;
begin
  if current_user_id is null then
    raise exception using errcode = '28000', message = 'AUTHENTICATION_REQUIRED';
  end if;
  if nullif(trim(p_title), '') is null
    or p_score is null
    or p_score < 0
    or p_score > 1 then
    raise exception using errcode = '22023', message = 'INVALID_DECISION';
  end if;

  select role, plan, status_akun
    into current_role, current_plan, account_status
    from public.pengguna
    where id_pengguna = current_user_id
    for update;
  if not found or account_status <> 'aktif' then
    raise exception using errcode = '42501', message = 'ACCOUNT_NOT_ACTIVE';
  end if;

  if coalesce(current_role, 'user') <> 'admin'
    and coalesce(current_plan, 'basic') <> 'premium' then
    day_start := today_jakarta::timestamp at time zone 'Asia/Jakarta';
    day_end := (today_jakarta + 1)::timestamp at time zone 'Asia/Jakarta';

    select decision_count
      into existing_count
      from public.decision_daily_usage
      where user_id = current_user_id and local_date = today_jakarta;
    if not found then
      select count(*)::integer
        into existing_count
        from public.decision_histories
        where user_id = current_user_id
          and created_at >= day_start
          and created_at < day_end;
    end if;

    if existing_count >= 1 then
      raise exception using errcode = 'P0001',
        message = 'BASIC_DAILY_DECISION_LIMIT';
    end if;

    insert into public.decision_daily_usage (user_id, local_date, decision_count)
      values (current_user_id, today_jakarta, 1)
      on conflict (user_id, local_date)
      do update set decision_count = decision_daily_usage.decision_count + 1;
  end if;

  insert into public.decision_histories (
    user_id,
    category,
    subcategory,
    title,
    score,
    final_option,
    decision_date,
    priorities
  )
  values (
    current_user_id,
    p_category,
    p_subcategory,
    trim(p_title),
    p_score,
    p_final_option,
    coalesce(p_decision_date, now()),
    coalesce(p_priorities, '{}'::jsonb)
  )
  returning * into created;

  return to_jsonb(created);
end
$$;

revoke all on function public.create_user_decision_history(
  text, text, text, double precision, text, timestamptz, jsonb
) from public;
grant execute on function public.create_user_decision_history(
  text, text, text, double precision, text, timestamptz, jsonb
) to authenticated;
revoke insert on public.decision_histories from authenticated;
