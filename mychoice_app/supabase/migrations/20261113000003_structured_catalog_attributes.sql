-- Structured catalog attributes, source provenance, and per-subcategory criteria.
-- Apply after MyChoice_Supabase_Setup_Pilihan.sql and the catalog seed migrations.
-- Existing projects can apply this file in the Supabase SQL Editor.

alter table public.pilihan_katalog
  add column if not exists atribut jsonb not null default '{}'::jsonb,
  add column if not exists mata_uang varchar(3),
  add column if not exists sumber_url text,
  add column if not exists lisensi_data text;

alter table public.kriteria
  add column if not exists atribut_key varchar(100);

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'ck_pilihan_katalog_atribut_object'
      and conrelid = 'public.pilihan_katalog'::regclass
  ) then
    alter table public.pilihan_katalog
      add constraint ck_pilihan_katalog_atribut_object
      check (jsonb_typeof(atribut) = 'object');
  end if;

  if not exists (
    select 1
    from pg_constraint
    where conname = 'ck_pilihan_katalog_mata_uang'
      and conrelid = 'public.pilihan_katalog'::regclass
  ) then
    alter table public.pilihan_katalog
      add constraint ck_pilihan_katalog_mata_uang
      check (mata_uang is null or mata_uang ~ '^[A-Z]{3}$');
  end if;
end;
$$;

comment on column public.pilihan_katalog.atribut is
  'Flexible, category-specific attributes as a JSON object; values retain source units/text.';
comment on column public.pilihan_katalog.mata_uang is
  'ISO 4217 currency code for harga; NULL when the source currency is unknown.';
comment on column public.pilihan_katalog.sumber_url is
  'URL of the source used to verify this catalog record; NULL means not yet verified.';
comment on column public.pilihan_katalog.lisensi_data is
  'Data license identifier or terms confirmed for the source; NULL means unknown.';
comment on column public.kriteria.atribut_key is
  'Key in pilihan_katalog.atribut, or the special key harga, when applicable.';

create or replace function public.parse_catalog_specs(specifications text)
returns jsonb
language sql
immutable
parallel safe
set search_path = ''
as $$
  select coalesce(
    jsonb_object_agg(parsed.key, to_jsonb(parsed.value)),
    '{}'::jsonb
  )
  from (
    select
      lower(regexp_replace(trim(split_part(parts.part, ':', 1)), '[^a-zA-Z0-9]+', '_', 'g')) as key,
      nullif(trim(substr(parts.part, strpos(parts.part, ':') + 1)), '') as value
    from regexp_split_to_table(coalesce(specifications, ''), ';') as parts(part)
    where strpos(parts.part, ':') > 0
  ) as parsed
  where parsed.key <> ''
    and parsed.value is not null;
$$;

update public.pilihan_katalog
set atribut = public.parse_catalog_specs(spesifikasi)
where atribut = '{}'::jsonb
  and nullif(trim(spesifikasi), '') is not null;

update public.pilihan_katalog
set mata_uang = case
  when spesifikasi ~* '(Rp|IDR)' then 'IDR'
  when spesifikasi ~* '([$]|USD)' then 'USD'
  when spesifikasi ~* '(€|EUR)' then 'EUR'
  when spesifikasi ~* '(£|GBP)' then 'GBP'
  else null
end
where mata_uang is null
  and harga is not null
  and spesifikasi is not null;

with default_criteria(nama_kategori, nama_sub_kategori, nama_kriteria, atribut_key, jenis_kriteria, satuan) as (
  values
    ('Technology', 'Laptop', 'Harga', 'harga', 'cost', NULL),
    ('Technology', 'Laptop', 'RAM', 'ram', 'benefit', 'GB'),
    ('Technology', 'Laptop', 'Penyimpanan', 'storage', 'benefit', 'GB'),
    ('Technology', 'Laptop', 'Daya tahan baterai', 'battery', 'benefit', 'jam'),
    ('Technology', 'Laptop', 'Berat', 'weight', 'cost', 'kg'),
    ('Technology', 'Smartphone', 'Harga', 'harga', 'cost', NULL),
    ('Technology', 'Smartphone', 'RAM', 'ram', 'benefit', 'GB'),
    ('Technology', 'Smartphone', 'Penyimpanan', 'storage', 'benefit', 'GB'),
    ('Technology', 'Smartphone', 'Kapasitas baterai', 'battery', 'benefit', 'mAh'),
    ('Technology', 'Smartphone', 'Layar', 'display', 'benefit', NULL),
    ('Technology', 'Tablet', 'Harga', 'harga', 'cost', NULL),
    ('Technology', 'Tablet', 'RAM', 'ram', 'benefit', 'GB'),
    ('Technology', 'Tablet', 'Penyimpanan', 'storage', 'benefit', 'GB'),
    ('Technology', 'Tablet', 'Layar', 'display', 'benefit', 'inci'),
    ('Technology', 'Tablet', 'Berat', 'weight', 'cost', 'kg'),
    ('Technology', 'Monitor', 'Harga', 'harga', 'cost', NULL),
    ('Technology', 'Monitor', 'Resolusi', 'resolution', 'benefit', NULL),
    ('Technology', 'Monitor', 'Refresh rate', 'refresh_rate', 'benefit', 'Hz'),
    ('Technology', 'Monitor', 'Jenis panel', 'panel', 'benefit', NULL),
    ('Technology', 'Monitor', 'Ukuran layar', 'size', 'benefit', 'inci'),
    ('Technology', 'Monitor', 'Waktu respons', 'response_time', 'cost', 'ms'),
    ('Technology', 'Gaming PC', 'Harga', 'harga', 'cost', NULL),
    ('Technology', 'Gaming PC', 'Prosesor', 'processor', 'benefit', NULL),
    ('Technology', 'Gaming PC', 'RAM', 'ram', 'benefit', 'GB'),
    ('Technology', 'Gaming PC', 'GPU', 'gpu', 'benefit', NULL),
    ('Technology', 'Gaming PC', 'Penyimpanan', 'storage', 'benefit', 'GB'),
    ('Technology', 'Processor', 'Harga', 'harga', 'cost', NULL),
    ('Technology', 'Processor', 'Jumlah core', 'cores', 'benefit', 'core'),
    ('Technology', 'Processor', 'Clock speed', 'base_clock', 'benefit', 'GHz'),
    ('Technology', 'Processor', 'TDP', 'tdp', 'cost', 'W'),
    ('Technology', 'Processor', 'Socket', 'socket', 'benefit', NULL),
    ('Technology', 'Graphics Card', 'Harga', 'harga', 'cost', NULL),
    ('Technology', 'Graphics Card', 'VRAM', 'vram', 'benefit', 'GB'),
    ('Technology', 'Graphics Card', 'Kinerja', 'performance', 'benefit', NULL),
    ('Technology', 'Graphics Card', 'Clock speed', 'boost_clock', 'benefit', 'MHz'),
    ('Technology', 'Graphics Card', 'Konsumsi daya', 'tdp', 'cost', 'W'),
    ('Education', 'Course', 'Harga', 'harga', 'cost', NULL),
    ('Education', 'Course', 'Durasi', 'duration', 'cost', 'jam'),
    ('Education', 'Course', 'Level', 'level', 'benefit', NULL),
    ('Education', 'Course', 'Bahasa', 'language', 'benefit', NULL),
    ('Education', 'Course', 'Sertifikat', 'certificate', 'benefit', NULL),
    ('Education', 'Certification', 'Biaya ujian', 'exam_fee', 'cost', NULL),
    ('Education', 'Certification', 'Level', 'level', 'benefit', NULL),
    ('Education', 'Certification', 'Masa berlaku', 'validity', 'benefit', 'tahun'),
    ('Education', 'Certification', 'Durasi belajar', 'duration', 'cost', 'bulan'),
    ('Education', 'Bootcamp', 'Harga', 'harga', 'cost', NULL),
    ('Education', 'Bootcamp', 'Durasi', 'duration', 'cost', 'minggu'),
    ('Education', 'Bootcamp', 'Jalur belajar', 'tracks', 'benefit', NULL),
    ('Education', 'Bootcamp', 'Format', 'format', 'benefit', NULL),
    ('Education', 'Bootcamp', 'ISA tersedia', 'isa', 'benefit', NULL),
    ('Education', 'University', 'Biaya kuliah', 'tuition', 'cost', NULL),
    ('Education', 'University', 'Lokasi', 'location', 'benefit', NULL),
    ('Education', 'University', 'Jenis institusi', 'type', 'benefit', NULL),
    ('Education', 'University', 'Program unggulan', 'notable_programs', 'benefit', NULL),
    ('Education', 'University', 'Peringkat', 'ranking', 'benefit', NULL),
    ('Education', 'Training Program', 'Harga', 'harga', 'cost', NULL),
    ('Education', 'Training Program', 'Durasi', 'duration', 'cost', NULL),
    ('Education', 'Training Program', 'Format', 'format', 'benefit', NULL),
    ('Education', 'Training Program', 'Sertifikat', 'certificate', 'benefit', NULL),
    ('Education', 'Training Program', 'Bahasa', 'language', 'benefit', NULL),
    ('Fashion', 'Dress', 'Harga', 'harga', 'cost', NULL),
    ('Fashion', 'Dress', 'Bahan', 'material', 'benefit', NULL),
    ('Fashion', 'Dress', 'Ukuran', 'size', 'benefit', NULL),
    ('Fashion', 'Dress', 'Potongan', 'fit', 'benefit', NULL),
    ('Fashion', 'Dress', 'Petunjuk perawatan', 'care_instructions', 'cost', NULL),
    ('Fashion', 'Shoes', 'Harga', 'harga', 'cost', NULL),
    ('Fashion', 'Shoes', 'Ukuran', 'size', 'benefit', NULL),
    ('Fashion', 'Shoes', 'Bahan', 'material', 'benefit', NULL),
    ('Fashion', 'Shoes', 'Jenis sepatu', 'type', 'benefit', NULL),
    ('Fashion', 'Shoes', 'Berat', 'weight', 'cost', 'g'),
    ('Fashion', 'Accessories', 'Harga', 'harga', 'cost', NULL),
    ('Fashion', 'Accessories', 'Bahan', 'material', 'benefit', NULL),
    ('Fashion', 'Accessories', 'Warna', 'color', 'benefit', NULL),
    ('Fashion', 'Accessories', 'Gaya', 'style', 'benefit', NULL),
    ('Fashion', 'Accessories', 'Asal produk', 'origin', 'benefit', NULL),
    ('Fashion', 'Bags', 'Harga', 'harga', 'cost', NULL),
    ('Fashion', 'Bags', 'Bahan', 'material', 'benefit', NULL),
    ('Fashion', 'Bags', 'Kapasitas', 'capacity', 'benefit', 'L'),
    ('Fashion', 'Bags', 'Berat', 'weight', 'cost', 'g'),
    ('Fashion', 'Bags', 'Fitur', 'features', 'benefit', NULL),
    ('Fashion', 'Jewelry', 'Harga', 'harga', 'cost', NULL),
    ('Fashion', 'Jewelry', 'Bahan', 'material', 'benefit', NULL),
    ('Fashion', 'Jewelry', 'Jenis', 'type', 'benefit', NULL),
    ('Fashion', 'Jewelry', 'Fitur', 'features', 'benefit', NULL),
    ('Fashion', 'Jewelry', 'Asal produk', 'origin', 'benefit', NULL),
    ('Fashion', 'Outerwear', 'Harga', 'harga', 'cost', NULL),
    ('Fashion', 'Outerwear', 'Bahan', 'material', 'benefit', NULL),
    ('Fashion', 'Outerwear', 'Bahan pengisi', 'fill', 'benefit', NULL),
    ('Fashion', 'Outerwear', 'Ketahanan air', 'water_resistance', 'benefit', NULL),
    ('Fashion', 'Outerwear', 'Berat', 'weight', 'cost', 'g')
)
insert into public.kriteria (
  id_sub_kategori,
  nama_kriteria,
  atribut_key,
  jenis_kriteria,
  satuan
)
select
  sk.id_sub_kategori,
  c.nama_kriteria,
  c.atribut_key,
  c.jenis_kriteria,
  c.satuan
from default_criteria c
join public.kategori k on k.nama_kategori = c.nama_kategori
join public.sub_kategori sk
  on sk.id_kategori = k.id_kategori
 and sk.nama_sub_kategori = c.nama_sub_kategori
on conflict (id_sub_kategori, nama_kriteria) do update
set atribut_key = coalesce(public.kriteria.atribut_key, excluded.atribut_key);

drop function if exists public.get_pilihan_katalog_by_sub(text);

create function public.get_pilihan_katalog_by_sub(nama_sub_kategori text)
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
    pk.id_pilihan_katalog,
    pk.nama_pilihan,
    pk.harga,
    pk.spesifikasi,
    pk.rating,
    pk.atribut,
    pk.mata_uang,
    pk.sumber_url,
    pk.lisensi_data,
    sk.nama_sub_kategori,
    k.nama_kategori
  from public.pilihan_katalog pk
  join public.sub_kategori sk on sk.id_sub_kategori = pk.id_sub_kategori
  join public.kategori k on k.id_kategori = sk.id_kategori
  where sk.nama_sub_kategori = get_pilihan_katalog_by_sub.nama_sub_kategori
  order by pk.nama_pilihan;
$$;

revoke all on function public.get_pilihan_katalog_by_sub(text) from public;
grant execute on function public.get_pilihan_katalog_by_sub(text) to anon, authenticated;

-- Check the data/license provenance before setting either field; unknown values stay NULL.
