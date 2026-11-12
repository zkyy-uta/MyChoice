-- Migration: Tambah kolom plan dan upgrade manajemen akun pengguna
-- Menambahkan kolom plan (basic/premium) ke tabel pengguna untuk hak akses tier

-- 1. Tambah kolom plan ke tabel pengguna jika belum ada
alter table public.pengguna
  add column if not exists plan text not null default 'basic'
  check (plan in ('basic', 'premium'));

-- 2. Index untuk mempercepat query per role dan plan
create index if not exists idx_pengguna_role on public.pengguna (role);
create index if not exists idx_pengguna_plan on public.pengguna (plan);
create index if not exists idx_pengguna_email on public.pengguna (email);

-- 3. Fungsi helper untuk cek apakah user adalah admin
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
  );
$$;

revoke all on function public.is_admin_user() from public;
grant execute on function public.is_admin_user() to authenticated;

-- 4. Fungsi helper untuk cek apakah user memiliki plan premium
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

-- 5. Fungsi helper untuk mengambil profil lengkap pengguna
create or replace function public.get_user_profile()
returns table (
  id_pengguna uuid,
  nama text,
  email text,
  role text,
  plan text,
  tanggal_dibuat timestamptz
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
    tanggal_dibuat
  from public.pengguna
  where id_pengguna = (select auth.uid());
$$;

revoke all on function public.get_user_profile() from public;
grant execute on function public.get_user_profile() to authenticated;

-- 6. Kebijakan RLS untuk update plan (hanya admin yang bisa)
do $$
begin
  if not exists (
    select 1 from pg_policy where polname = 'pengguna_update_plan_admin' and polrelid = 'public.pengguna'::regclass
  ) then
    create policy pengguna_update_plan_admin
      on public.pengguna
      for update
      to authenticated
      using (public.is_admin_user())
      with check (public.is_admin_user());
  end if;
end $$;

-- 7. Kebijakan RLS untuk read own profile
do $$
begin
  if not exists (
    select 1 from pg_policy where polname = 'pengguna_read_own_profile' and polrelid = 'public.pengguna'::regclass
  ) then
    create policy pengguna_read_own_profile
      on public.pengguna
      for select
      to authenticated
      using (id_pengguna = (select auth.uid()) or public.is_admin_user());
  end if;
end $$;
