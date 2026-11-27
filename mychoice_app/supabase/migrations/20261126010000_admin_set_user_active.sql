-- Migration: aktivasi / nonaktivasi akun lewat RPC (tanpa edge function).
--
-- Sebelumnya status akun diubah dari aplikasi melalui edge function
-- `manage-user-status`. Panggilan itu bisa gagal tanpa pesan yang jelas
-- ("Failed to update account status: null"), misalnya ketika function belum
-- di-deploy ulang setelah nama tabel berubah. Logika yang sama sekarang
-- dijalankan langsung di database agar satu jalur saja yang dipakai.
--
-- Fungsi ini:
--   1. hanya bisa dipanggil admin aktif (is_admin_user),
--   2. menolak mengubah status akun sendiri dan akun admin lain,
--   3. mengubah public.users.status_akun,
--   4. memblokir / mengizinkan login lewat auth.users.banned_until sehingga
--      akun nonaktif tidak bisa login lagi (dan bisa aktif kembali).

begin;

create or replace function public.admin_set_user_active(
  p_target_user_id uuid,
  p_active boolean
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  target public.users;
  sign_in_blocked boolean := false;
begin
  if not public.is_admin_user() then
    raise exception using errcode = '42501', message = 'ADMIN_REQUIRED';
  end if;
  if p_target_user_id is null or p_active is null then
    raise exception using errcode = '22023', message = 'INVALID_STATUS_REQUEST';
  end if;
  if p_target_user_id = (select auth.uid()) then
    raise exception using errcode = '42501', message = 'CANNOT_CHANGE_OWN_STATUS';
  end if;

  select *
    into target
    from public.users
    where id_pengguna = p_target_user_id
    for update;
  if not found then
    raise exception using errcode = 'P0002', message = 'USER_NOT_FOUND';
  end if;
  if target.role = 'admin' then
    raise exception using errcode = '42501', message = 'CANNOT_CHANGE_ADMIN_STATUS';
  end if;

  update public.users
    set status_akun = case when p_active then 'aktif' else 'nonaktif' end
    where id_pengguna = p_target_user_id
    returning * into target;

  -- Blokir login akun nonaktif (dan lepaskan blokir saat diaktifkan lagi).
  -- Jika role migration tidak punya hak tulis ke schema auth, status akun
  -- tetap tersimpan dan hasil fungsi melaporkan sign_in_updated = false.
  if to_regclass('auth.users') is not null then
    begin
      update auth.users
        set banned_until = case
          when p_active then null
          else now() + interval '100 years'
        end
        where id = p_target_user_id;
      sign_in_blocked := true;
    exception
      when insufficient_privilege then
        sign_in_blocked := false;
    end;
  end if;

  return to_jsonb(target)
    || jsonb_build_object('sign_in_updated', sign_in_blocked);
end
$$;

revoke all on function public.admin_set_user_active(uuid, boolean) from public;
grant execute on function public.admin_set_user_active(uuid, boolean)
  to authenticated;

commit;
