create or replace function public.can_create_user_decision_today()
returns boolean
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  current_user_id uuid := (select auth.uid());
  current_role text;
  current_plan text;
  account_status text;
  today_jakarta date := (now() at time zone 'Asia/Jakarta')::date;
  day_start timestamptz;
  day_end timestamptz;
  existing_count integer;
begin
  if current_user_id is null then
    raise exception using errcode = '28000', message = 'AUTHENTICATION_REQUIRED';
  end if;

  select role, plan, status_akun
    into current_role, current_plan, account_status
    from public.pengguna
    where id_pengguna = current_user_id;
  if not found or account_status <> 'aktif' then
    raise exception using errcode = '42501', message = 'ACCOUNT_NOT_ACTIVE';
  end if;

  if coalesce(current_role, 'user') = 'admin'
    or coalesce(current_plan, 'basic') = 'premium' then
    return true;
  end if;

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

  return existing_count < 1;
end
$$;

revoke all on function public.can_create_user_decision_today() from public;
grant execute on function public.can_create_user_decision_today()
  to authenticated;
