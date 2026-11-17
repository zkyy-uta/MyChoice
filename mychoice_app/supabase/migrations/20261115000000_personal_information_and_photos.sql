alter table public.pengguna
  add column if not exists avatar_path text;

grant update (nama, avatar_path) on public.pengguna to authenticated;

do $$
begin
  if not exists (
    select 1
    from pg_policy
    where polname = 'pengguna_update_own_profile'
      and polrelid = 'public.pengguna'::regclass
  ) then
    create policy pengguna_update_own_profile
      on public.pengguna
      for update
      to authenticated
      using (id_pengguna = (select auth.uid()))
      with check (id_pengguna = (select auth.uid()));
  end if;
end;
$$;

create or replace function public.sync_pengguna_email()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.email is distinct from old.email then
    update public.pengguna
    set email = new.email
    where id_pengguna = new.id;
  end if;
  return new;
end;
$$;

revoke all on function public.sync_pengguna_email() from public;

drop trigger if exists on_mychoice_auth_email_updated on auth.users;
create trigger on_mychoice_auth_email_updated
  after update of email on auth.users
  for each row execute function public.sync_pengguna_email();

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

insert into storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
values (
  'profile-photos',
  'profile-photos',
  false,
  5242880,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update
set public = excluded.public,
    file_size_limit = excluded.file_size_limit,
    allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists profile_photos_select_own on storage.objects;
create policy profile_photos_select_own
  on storage.objects
  for select
  to authenticated
  using (
    bucket_id = 'profile-photos'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  );

drop policy if exists profile_photos_insert_own on storage.objects;
create policy profile_photos_insert_own
  on storage.objects
  for insert
  to authenticated
  with check (
    bucket_id = 'profile-photos'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  );

drop policy if exists profile_photos_update_own on storage.objects;
create policy profile_photos_update_own
  on storage.objects
  for update
  to authenticated
  using (
    bucket_id = 'profile-photos'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  )
  with check (
    bucket_id = 'profile-photos'
    and (storage.foldername(name))[1] = (select auth.uid()::text)
  );
