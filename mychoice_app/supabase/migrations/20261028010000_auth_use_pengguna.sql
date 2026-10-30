alter table public.pengguna
  add column if not exists role text not null default 'user';

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'pengguna_role_check'
      and conrelid = 'public.pengguna'::regclass
  ) then
    alter table public.pengguna
      add constraint pengguna_role_check
      check (role in ('user', 'admin'));
  end if;
end;
$$;

insert into public.pengguna (id_pengguna, nama, email)
select
  auth_user.id,
  coalesce(
    nullif(auth_user.raw_user_meta_data ->> 'full_name', ''),
    nullif(auth_user.raw_user_meta_data ->> 'nama', ''),
    nullif(split_part(coalesce(auth_user.email, ''), '@', 1), ''),
    'Pengguna'
  ),
  auth_user.email
from auth.users as auth_user
on conflict (id_pengguna) do nothing;

do $$
begin
  if to_regclass('public.profiles') is not null then
    execute $migration$
      update public.pengguna as pengguna
      set role = profiles.role,
          nama = case
            when nullif(profiles.full_name, '') is not null
              and pengguna.nama in (
                'Pengguna',
                split_part(coalesce(pengguna.email, ''), '@', 1)
              )
            then profiles.full_name
            else pengguna.nama
          end
      from public.profiles as profiles
      where profiles.id = pengguna.id_pengguna
        and profiles.role in ('user', 'admin')
    $migration$;
  end if;
end;
$$;

create or replace function public.handle_new_mychoice_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.pengguna (id_pengguna, nama, email)
  values (
    new.id,
    coalesce(
      nullif(new.raw_user_meta_data ->> 'full_name', ''),
      nullif(new.raw_user_meta_data ->> 'nama', ''),
      nullif(split_part(coalesce(new.email, ''), '@', 1), ''),
      'Pengguna'
    ),
    new.email
  )
  on conflict (id_pengguna) do nothing;
  return new;
end;
$$;

revoke all on function public.handle_new_mychoice_user() from public;

drop trigger if exists on_auth_user_created on auth.users;
drop trigger if exists on_mychoice_auth_user_created on auth.users;
create trigger on_mychoice_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_mychoice_user();

alter table public.pengguna enable row level security;
revoke all on public.pengguna from anon, authenticated;
grant usage on schema public to authenticated;
grant select on public.pengguna to authenticated;
grant update (nama) on public.pengguna to authenticated;

do $$
begin
  if not exists (
    select 1
    from pg_policy
    where polname = 'pengguna_read_own'
      and polrelid = 'public.pengguna'::regclass
  ) then
    create policy pengguna_read_own on public.pengguna
      for select to authenticated
      using (id_pengguna = (select auth.uid()));
  end if;
end;
$$;
