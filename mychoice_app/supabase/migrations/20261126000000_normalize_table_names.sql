-- Migration: normalisasi nama tabel + pisahkan tabel duplikat lama.
--
-- Tujuan:
--   1. Nama tabel konsisten berbahasa Inggris (tidak campur Indonesia/Inggris).
--   2. Tidak ada lagi pasangan tabel yang tumpang tindih:
--        profiles / pengguna, criteria / kriteria, reviews / ulasan / decision_history_reviews
--   3. Tidak ada data yang dihapus:
--        - tabel aktif hanya DIGANTI NAMA (rename), sehingga primary key,
--          foreign key, index, sequence, RLS policy, dan GRANT ikut otomatis;
--        - tabel duplikat/sisa skema lama DIPINDAH ke schema `legacy`, jadi
--          datanya masih bisa dibaca (select * from legacy.<nama>) tetapi tidak
--          lagi tampil sebagai tabel aplikasi di public/Table Editor.
--
-- Nama kolom TIDAK diubah agar kode aplikasi (PostgREST) tetap kompatibel;
-- hanya nama tabel yang berubah, dan pemanggilan di aplikasi sudah disesuaikan.
--
-- Catatan: jalankan setelah semua migration sebelumnya (lihat urutan timestamp).

begin;

-- ============================================================
-- 1. Schema penampung untuk tabel duplikat / sisa skema lama
-- ============================================================
create schema if not exists legacy;

do $$
declare
  table_name text;
begin
  foreach table_name in array array[
    'profiles',   -- digantikan oleh public.pengguna (kini public.users)
    'criteria',   -- sisa skema lama, digantikan oleh public.kriteria (kini public.criteria)
    'candidates', -- sisa skema lama, tidak dipakai aplikasi
    'reviews',    -- sisa skema lama, digantikan decision_history_reviews
    'ulasan'      -- duplikat decision_history_reviews (tabel ulasan ERD lama)
  ]
  loop
    if to_regclass(format('public.%I', table_name)) is not null
       and to_regclass(format('legacy.%I', table_name)) is null then
      execute format('alter table public.%I set schema legacy', table_name);
    end if;
  end loop;
end
$$;

-- ============================================================
-- 2. Rename tabel aktif menjadi nama Inggris
--    (guard: hanya jika tabel lama ada dan nama baru belum dipakai)
-- ============================================================
do $$
declare
  mapping record;
begin
  for mapping in
    select *
    from (values
      ('pengguna',                  'users'),
      ('kategori',                  'categories'),
      ('sub_kategori',              'subcategories'),
      ('pilihan_katalog',           'catalog_options'),
      ('pilihan_katalog_pengguna',  'user_catalog_options'),
      ('keputusan',                 'decisions'),
      ('kriteria',                  'criteria'),
      ('kriteria_personal_pengguna', 'user_personal_criteria'),
      ('pilihan_keputusan',         'decision_options'),
      ('kriteria_keputusan',        'decision_criteria'),
      ('nilai_pilihan',             'decision_option_scores'),
      ('hasil_perbandingan',        'comparison_results'),
      ('simulasi',                  'simulations'),
      ('bobot_simulasi',            'simulation_weights'),
      ('insight_ai',                'decision_insights')
    ) as m(old_name, new_name)
  loop
    if to_regclass(format('public.%I', mapping.old_name)) is not null
       and to_regclass(format('public.%I', mapping.new_name)) is null then
      execute format(
        'alter table public.%I rename to %I',
        mapping.old_name,
        mapping.new_name
      );
    end if;
  end loop;
end
$$;

-- ============================================================
-- 3. Fungsi yang menyebut nama tabel lama (body fungsi berupa teks,
--    sehingga harus dibuat ulang setelah rename)
-- ============================================================

-- 3a. Trigger profil otomatis saat akun auth baru dibuat.
create or replace function public.handle_new_mychoice_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.users (id_pengguna, nama, email)
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

-- 3b. Sinkronisasi email auth.users -> public.users.
create or replace function public.sync_pengguna_email()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.email is distinct from old.email then
    update public.users
    set email = new.email
    where id_pengguna = new.id;
  end if;
  return new;
end;
$$;

revoke all on function public.sync_pengguna_email() from public;

-- 3c. Helper role/plan.
create or replace function public.is_admin_user()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.users
    where id_pengguna = (select auth.uid())
      and role = 'admin'
      and status_akun = 'aktif'
  );
$$;

revoke all on function public.is_admin_user() from public;
grant execute on function public.is_admin_user() to authenticated;

create or replace function public.is_premium_user()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.users
    where id_pengguna = (select auth.uid())
      and plan = 'premium'
  );
$$;

revoke all on function public.is_premium_user() from public;
grant execute on function public.is_premium_user() to authenticated;

-- 3d. Profil milik akun yang login.
create or replace function public.get_user_profile()
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
  from public.users
  where id_pengguna = (select auth.uid());
$$;

revoke all on function public.get_user_profile() from public;
grant execute on function public.get_user_profile() to authenticated;

-- 3e. Direktori akun untuk dashboard & manajemen user admin.
--     Tidak memfilter status: akun nonaktif tetap harus tampil di daftar.
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
      u.id_pengguna::uuid,
      u.nama::text,
      u.email::text,
      u.role::text,
      u.plan::text,
      u.status_akun::text,
      u.tanggal_dibuat::timestamptz
    from public.users as u
    order by u.tanggal_dibuat desc;
end
$$;

revoke all on function public.admin_list_users() from public;
grant execute on function public.admin_list_users() to authenticated;

-- 3f. Update role & plan oleh admin.
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
  target public.users;
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
    from public.users
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
    from public.users
    where role = 'admin' and status_akun = 'aktif'
  ) <= 1 then
    raise exception using errcode = '23514', message = 'LAST_ACTIVE_ADMIN';
  end if;

  update public.users
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

-- 3g. Simpan riwayat keputusan + batas harian plan basic.
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
    from public.users
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

-- 3h. Preflight apakah akun boleh membuat keputusan hari ini.
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
    from public.users
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

-- 3i. Katalog per subkategori untuk layar pemilihan.
create or replace function public.get_pilihan_katalog_by_sub(
  nama_sub_kategori text
)
returns table (
  id_pilihan_katalog uuid,
  nama_pilihan varchar,
  harga numeric,
  spesifikasi text,
  rating numeric,
  atribut jsonb,
  mata_uang varchar,
  sumber_url text,
  lisensi_data text,
  nama_sub_kategori varchar,
  nama_kategori varchar
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    co.id_pilihan_katalog,
    co.nama_pilihan,
    co.harga,
    co.spesifikasi,
    co.rating,
    co.atribut,
    co.mata_uang,
    co.sumber_url,
    co.lisensi_data,
    sc.nama_sub_kategori,
    c.nama_kategori
  from public.catalog_options co
  join public.subcategories sc on sc.id_sub_kategori = co.id_sub_kategori
  join public.categories c on c.id_kategori = sc.id_kategori
  where sc.nama_sub_kategori = get_pilihan_katalog_by_sub.nama_sub_kategori
  order by co.nama_pilihan;
$$;

revoke all on function public.get_pilihan_katalog_by_sub(text) from public;
grant execute on function public.get_pilihan_katalog_by_sub(text)
  to anon, authenticated;

commit;
