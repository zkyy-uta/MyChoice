alter table public.pengguna
  add column if not exists avatar_path text;

alter table public.pengguna
  add column if not exists plan text;

do $$
begin
  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'pengguna'
      and column_name = 'jenis_langganan'
  ) then
    update public.pengguna
    set plan = case
      when lower(coalesce(jenis_langganan::text, '')) = 'premium'
        then 'premium'
      else 'basic'
    end
    where plan is null;
  else
    update public.pengguna
    set plan = 'basic'
    where plan is null;
  end if;
end;
$$;

alter table public.pengguna
  alter column plan set default 'basic',
  alter column plan set not null;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'pengguna_plan_check'
      and conrelid = 'public.pengguna'::regclass
  ) then
    alter table public.pengguna
      add constraint pengguna_plan_check
      check (plan in ('basic', 'premium'));
  end if;
end;
$$;

create index if not exists idx_pengguna_plan on public.pengguna (plan);

create or replace function public.is_premium_user()
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
      and plan = 'premium'
  );
$$;

revoke all on function public.is_premium_user() from public;
grant execute on function public.is_premium_user() to authenticated;

drop function if exists public.get_user_profile();
create function public.get_user_profile()
returns table (
  id_pengguna uuid,
  nama text,
  email text,
  role text,
  plan text,
  tanggal_dibuat timestamptz,
  avatar_path text
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    id_pengguna,
    nama,
    email,
    role,
    plan,
    tanggal_dibuat,
    avatar_path
  from public.pengguna
  where id_pengguna = (select auth.uid());
$$;

revoke all on function public.get_user_profile() from public;
grant execute on function public.get_user_profile() to authenticated;
