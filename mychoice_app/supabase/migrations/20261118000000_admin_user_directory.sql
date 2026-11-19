-- Migration: direktori akun untuk dashboard & manajemen user admin.
--
-- Masalah: tabel public.pengguna dilindungi policy "pengguna_read_own"
-- (hanya baris milik akun yang login). Akibatnya dashboard admin dan
-- Management User hanya menampilkan akun admin itu sendiri, bukan seluruh
-- akun pengguna yang sudah terdaftar.
--
-- Perbaikan:
-- 1. Policy SELECT khusus admin pada public.pengguna.
-- 2. RPC admin_list_users() yang berjalan sebagai security definer sehingga
--    daftar akun tetap benar walau policy SELECT pengguna berubah.

drop policy if exists pengguna_admin_read on public.pengguna;
create policy pengguna_admin_read on public.pengguna
  for select to authenticated
  using (public.is_admin_user());

create or replace function public.admin_list_users()
returns table (
  id_pengguna uuid,
  nama text,
  email text,
  role text,
  plan text,
  status_akun text,
  tanggal_dibuat timestamptz
)
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if not public.is_admin_user() then
    raise exception using errcode = '42501', message = 'ADMIN_REQUIRED';
  end if;

  return query
    select
      p.id_pengguna,
      p.nama,
      p.email,
      p.role,
      p.plan,
      p.status_akun,
      p.tanggal_dibuat
    from public.pengguna as p
    order by p.tanggal_dibuat desc;
end
$$;

revoke all on function public.admin_list_users() from public;
grant execute on function public.admin_list_users() to authenticated;
