-- Migration: perbaiki error "structure of query does not match function result type"
-- pada RPC public.admin_list_users().
--
-- Penyebab:
--   Fungsi plpgsql dengan RETURNS TABLE membandingkan OID tipe hasil query
--   dengan OID tipe kolom yang dideklarasikan. Kolom tabel:
--     pengguna.nama         varchar(150)
--     pengguna.email        varchar(255)
--     pengguna.status_akun  varchar(20)
--   sedangkan fungsi mendeklarasikan kolom return sebagai `text`. OID
--   varchar(1043) != OID text(25), sehingga PostgreSQL menolak hasilnya walau
--   varchar -> text sebenarnya kompatibel. Itulah sebabnya fungsi bertipe
--   `language sql` seperti get_user_profile() tetap jalan, sedangkan
--   admin_list_users() (plpgsql) gagal saat dipanggil.
--
-- Perbaikan: cast setiap kolom secara eksplisit ke tipe yang dideklarasikan
-- pada RETURNS TABLE.

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
      p.id_pengguna::uuid,
      p.nama::text,
      p.email::text,
      p.role::text,
      p.plan::text,
      p.status_akun::text,
      p.tanggal_dibuat::timestamptz
    from public.pengguna as p
    order by p.tanggal_dibuat desc;
end
$$;

revoke all on function public.admin_list_users() from public;
grant execute on function public.admin_list_users() to authenticated;
