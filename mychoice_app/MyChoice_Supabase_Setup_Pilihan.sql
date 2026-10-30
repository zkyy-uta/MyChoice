-- ===========================================================
-- MYCHOICE - Skema PostgreSQL untuk Supabase (Oktober 2026)
-- Jalankan SEKALI pada project Supabase BARU melalui SQL Editor.
-- 14 tabel berdasarkan ERD MyChoice.
-- Penyesuaian eksplisit:
--   pengguna.id_pengguna = auth.users.id
--   pengguna.status_akun untuk administrasi (bukan pemblokiran auth)
--   kriteria_keputusan mendukung kriteria custom pada keputusan
--   timestamp memakai timestamptz, decimal memakai numeric
--   keamanan: RLS + GRANT minimal
-- ===========================================================

begin;

-- 1. Referensi akun aplikasi ke Supabase Auth.
create table public.pengguna (
  id_pengguna uuid primary key references auth.users(id) on delete cascade,
  nama varchar(150) not null default 'Pengguna',
  email varchar(255) unique,
  jenis_langganan varchar(20) not null default 'free'
    check (jenis_langganan in ('free', 'premium')),
  role text not null default 'user'
    check (role in ('user', 'admin')),
  status_akun varchar(20) not null default 'aktif'
    check (status_akun in ('aktif', 'nonaktif')),
  tanggal_dibuat timestamptz not null default now()
);

-- 2. Kategori, subkategori, dan katalog publik.
create table public.kategori (
  id_kategori bigint generated always as identity primary key,
  nama_kategori varchar(120) not null unique,
  deskripsi text
);

create table public.sub_kategori (
  id_sub_kategori bigint generated always as identity primary key,
  id_kategori bigint not null references public.kategori(id_kategori) on delete restrict,
  nama_sub_kategori varchar(120) not null,
  unique (id_kategori, nama_sub_kategori)
);

create table public.pilihan_katalog (
  id_pilihan_katalog uuid primary key default gen_random_uuid(),
  id_sub_kategori bigint not null references public.sub_kategori(id_sub_kategori) on delete restrict,
  nama_pilihan varchar(200) not null,
  harga numeric(16,2) check (harga >= 0),
  spesifikasi text,
  rating numeric(4,2) check (rating between 0 and 5)
);

-- 3. Keputusan yang dibuat pengguna.
create table public.keputusan (
  id_keputusan uuid primary key default gen_random_uuid(),
  id_pengguna uuid not null references public.pengguna(id_pengguna) on delete cascade,
  id_sub_kategori bigint not null references public.sub_kategori(id_sub_kategori) on delete restrict,
  judul varchar(200) not null,
  status varchar(30) not null default 'draft'
    check (status in ('draft', 'diproses', 'selesai', 'dibatalkan')),
  tanggal_dibuat timestamptz not null default now()
);

create table public.pilihan_keputusan (
  id_pilihan_keputusan uuid primary key default gen_random_uuid(),
  id_keputusan uuid not null references public.keputusan(id_keputusan) on delete cascade,
  id_pilihan_katalog uuid references public.pilihan_katalog(id_pilihan_katalog) on delete restrict,
  nama_pilihan varchar(200) not null,
  asal_pilihan varchar(20) not null
    check (asal_pilihan in ('katalog', 'manual')),
  harga numeric(16,2) check (harga >= 0),
  spesifikasi text,
  rating numeric(4,2) check (rating between 0 and 5),
  dipilih boolean not null default false,
  constraint ck_pilihan_sumber check (
    asal_pilihan = 'manual' or id_pilihan_katalog is not null
  )
);
-- Max 1 pilihan yang ditandai sebagai pilihan akhir per keputusan.
create unique index ux_pilihan_dipilih on public.pilihan_keputusan(id_keputusan)
  where dipilih = true;

-- 4. Kriteria default, dan kriteria yang dipakai dalam keputusan.
create table public.kriteria (
  id_kriteria bigint generated always as identity primary key,
  id_sub_kategori bigint not null references public.sub_kategori(id_sub_kategori) on delete restrict,
  nama_kriteria varchar(150) not null,
  jenis_kriteria varchar(10) not null check (jenis_kriteria in ('benefit', 'cost')),
  satuan varchar(50),
  unique (id_sub_kategori, nama_kriteria)
);

create table public.kriteria_keputusan (
  id_kriteria_keputusan uuid primary key default gen_random_uuid(),
  id_keputusan uuid not null references public.keputusan(id_keputusan) on delete cascade,
  id_kriteria bigint references public.kriteria(id_kriteria) on delete restrict,
  -- Tambahan di luar ERD agar user boleh mengisi kriteria baru:
  nama_kriteria_custom varchar(150),
  jenis_kriteria_custom varchar(10)
    check (jenis_kriteria_custom in ('benefit', 'cost')),
  satuan_custom varchar(50),
  bobot numeric(5,2) not null default 0 check (bobot between 0 and 100),
  constraint ck_sumber_kriteria check (
    (id_kriteria is not null and nama_kriteria_custom is null
      and jenis_kriteria_custom is null and satuan_custom is null)
    or
    (id_kriteria is null and nullif(trim(nama_kriteria_custom), '') is not null
      and jenis_kriteria_custom is not null)
  )
);
create unique index ux_default_kriteria_per_keputusan
  on public.kriteria_keputusan(id_keputusan, id_kriteria)
  where id_kriteria is not null;

-- 5. Nilai SAW dan hasil akhir per pilihan.
create table public.nilai_pilihan (
  id_nilai uuid primary key default gen_random_uuid(),
  id_pilihan_keputusan uuid not null references public.pilihan_keputusan(id_pilihan_keputusan) on delete cascade,
  id_kriteria_keputusan uuid not null references public.kriteria_keputusan(id_kriteria_keputusan) on delete cascade,
  nilai_awal numeric(18,6) not null,
  nilai_normalisasi numeric(18,6),
  nilai_terbobot numeric(18,6),
  unique (id_pilihan_keputusan, id_kriteria_keputusan)
);

create table public.hasil_perbandingan (
  id_hasil uuid primary key default gen_random_uuid(),
  id_pilihan_keputusan uuid not null unique
    references public.pilihan_keputusan(id_pilihan_keputusan) on delete cascade,
  skor_akhir numeric(18,6) not null,
  peringkat integer not null check (peringkat > 0),
  penjelasan text
);

-- 6. What-If Simulation.
create table public.simulasi (
  id_simulasi uuid primary key default gen_random_uuid(),
  id_keputusan uuid not null references public.keputusan(id_keputusan) on delete cascade,
  tanggal_simulasi timestamptz not null default now()
);

create table public.bobot_simulasi (
  id_bobot_simulasi uuid primary key default gen_random_uuid(),
  id_simulasi uuid not null references public.simulasi(id_simulasi) on delete cascade,
  id_kriteria_keputusan uuid not null references public.kriteria_keputusan(id_kriteria_keputusan) on delete cascade,
  bobot numeric(5,2) not null check (bobot between 0 and 100),
  unique (id_simulasi, id_kriteria_keputusan)
);

-- 7. Insight AI dan ulasan.
create table public.insight_ai (
  id_insight uuid primary key default gen_random_uuid(),
  id_keputusan uuid not null references public.keputusan(id_keputusan) on delete cascade,
  jenis varchar(50) not null,
  isi text not null,
  tanggal_dibuat timestamptz not null default now()
);

create table public.ulasan (
  id_ulasan uuid primary key default gen_random_uuid(),
  id_keputusan uuid not null references public.keputusan(id_keputusan) on delete cascade,
  kepuasan integer check (kepuasan between 1 and 5),
  hasil_aktual text,
  isi_ulasan text,
  tanggal_ulasan timestamptz not null default now()
);

-- Indeks foreign keys yang sering dipakai ketika query.
create index ix_sub_kategori_kategori on public.sub_kategori(id_kategori);
create index ix_pilihan_katalog_sub on public.pilihan_katalog(id_sub_kategori);
create index ix_keputusan_pengguna on public.keputusan(id_pengguna);
create index ix_keputusan_sub on public.keputusan(id_sub_kategori);
create index ix_pilihan_keputusan_id_keputusan on public.pilihan_keputusan(id_keputusan);
create index ix_kriteria_sub on public.kriteria(id_sub_kategori);
create index ix_kriteria_keputusan_dec on public.kriteria_keputusan(id_keputusan);
create index ix_nilai_pilihan on public.nilai_pilihan(id_pilihan_keputusan);
create index ix_nilai_kriteria on public.nilai_pilihan(id_kriteria_keputusan);
create index ix_simulasi_keputusan on public.simulasi(id_keputusan);
create index ix_bobot_simulasi_simulasi on public.bobot_simulasi(id_simulasi);
create index ix_insight_keputusan on public.insight_ai(id_keputusan);
create index ix_ulasan_keputusan on public.ulasan(id_keputusan);

-- 8. Auto-create profil saat signup lewat Supabase Auth.
create function public.handle_new_mychoice_user()
returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  insert into public.pengguna (id_pengguna, nama, email)
  values (
    new.id,
    coalesce(nullif(new.raw_user_meta_data ->> 'full_name', ''),
             nullif(new.raw_user_meta_data ->> 'nama', ''),
             nullif(split_part(coalesce(new.email, ''), '@', 1), ''),
             'Pengguna'),
    new.email
  )
  on conflict (id_pengguna) do nothing;
  return new;
end;
$$;

create trigger on_mychoice_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_mychoice_user();

-- 9. Enable RLS untuk seluruh tabel.
alter table public.pengguna enable row level security;
alter table public.kategori enable row level security;
alter table public.sub_kategori enable row level security;
alter table public.pilihan_katalog enable row level security;
alter table public.keputusan enable row level security;
alter table public.pilihan_keputusan enable row level security;
alter table public.kriteria enable row level security;
alter table public.kriteria_keputusan enable row level security;
alter table public.nilai_pilihan enable row level security;
alter table public.hasil_perbandingan enable row level security;
alter table public.simulasi enable row level security;
alter table public.bobot_simulasi enable row level security;
alter table public.insight_ai enable row level security;
alter table public.ulasan enable row level security;

-- 10. GRANTS: jangan bergantung pada privilege otomatis proyek baru.
revoke all on table
  public.pengguna, public.kategori, public.sub_kategori,
  public.pilihan_katalog, public.keputusan, public.pilihan_keputusan,
  public.kriteria, public.kriteria_keputusan, public.nilai_pilihan,
  public.hasil_perbandingan, public.simulasi, public.bobot_simulasi,
  public.insight_ai, public.ulasan
from anon, authenticated;

grant usage on schema public to anon, authenticated, service_role;
grant select on table public.kategori, public.sub_kategori,
  public.pilihan_katalog, public.kriteria to anon, authenticated;

grant select on table public.pengguna to authenticated;
grant update (nama) on table public.pengguna to authenticated;

grant select, insert, update, delete on table
  public.keputusan, public.pilihan_keputusan, public.kriteria_keputusan,
  public.simulasi, public.bobot_simulasi, public.ulasan
  to authenticated;

grant select on table public.nilai_pilihan, public.hasil_perbandingan,
  public.insight_ai to authenticated;

-- Hanya backend tepercaya yang memiliki secret/service_role key.
grant select, insert, update, delete on table
  public.pengguna, public.kategori, public.sub_kategori,
  public.pilihan_katalog, public.keputusan, public.pilihan_keputusan,
  public.kriteria, public.kriteria_keputusan, public.nilai_pilihan,
  public.hasil_perbandingan, public.simulasi, public.bobot_simulasi,
  public.insight_ai, public.ulasan
  to service_role;

grant usage, select on sequence public.kategori_id_kategori_seq,
  public.sub_kategori_id_sub_kategori_seq, public.kriteria_id_kriteria_seq
  to service_role;

-- 11. RLS: profil hanya bisa dibaca sendiri; user edit NAMA saja.
create policy pengguna_read_own on public.pengguna
  for select to authenticated using (id_pengguna = (select auth.uid()));
create policy pengguna_update_own_name on public.pengguna
  for update to authenticated
  using (id_pengguna = (select auth.uid()))
  with check (id_pengguna = (select auth.uid()));

-- Katalog & kriteria default boleh dilihat Guest dan User.
create policy kategori_read_public on public.kategori
  for select to anon, authenticated using (true);
create policy sub_kategori_read_public on public.sub_kategori
  for select to anon, authenticated using (true);
create policy pilihan_katalog_read_public on public.pilihan_katalog
  for select to anon, authenticated using (true);
create policy kriteria_read_public on public.kriteria
  for select to anon, authenticated using (true);

-- Semua keputusan hanya dapat diakses pemiliknya.
create policy keputusan_read_own on public.keputusan
  for select to authenticated using (id_pengguna = (select auth.uid()));
create policy keputusan_create_own on public.keputusan
  for insert to authenticated with check (id_pengguna = (select auth.uid()));
create policy keputusan_update_own on public.keputusan
  for update to authenticated
  using (id_pengguna = (select auth.uid()))
  with check (id_pengguna = (select auth.uid()));
create policy keputusan_delete_own on public.keputusan
  for delete to authenticated using (id_pengguna = (select auth.uid()));

-- Pilihan hanya boleh dikelola pemilik keputusan.
create policy pilihan_read_own on public.pilihan_keputusan
  for select to authenticated using (
    exists(select 1 from public.keputusan d
      where d.id_keputusan = pilihan_keputusan.id_keputusan
      and d.id_pengguna = (select auth.uid()))
  );
create policy pilihan_create_own on public.pilihan_keputusan
  for insert to authenticated with check (
    exists(select 1 from public.keputusan d
      where d.id_keputusan = pilihan_keputusan.id_keputusan
      and d.id_pengguna = (select auth.uid()))
  );
create policy pilihan_update_own on public.pilihan_keputusan
  for update to authenticated
  using (exists(select 1 from public.keputusan d
      where d.id_keputusan = pilihan_keputusan.id_keputusan
      and d.id_pengguna = (select auth.uid())))
  with check (exists(select 1 from public.keputusan d
      where d.id_keputusan = pilihan_keputusan.id_keputusan
      and d.id_pengguna = (select auth.uid())));
create policy pilihan_delete_own on public.pilihan_keputusan
  for delete to authenticated using (
    exists(select 1 from public.keputusan d
      where d.id_keputusan = pilihan_keputusan.id_keputusan
      and d.id_pengguna = (select auth.uid()))
  );

-- Bobot + kriteria custom pada keputusan.
create policy kdec_read_own on public.kriteria_keputusan
  for select to authenticated using (
    exists(select 1 from public.keputusan d
      where d.id_keputusan = kriteria_keputusan.id_keputusan
      and d.id_pengguna = (select auth.uid()))
  );
create policy kdec_create_own on public.kriteria_keputusan
  for insert to authenticated with check (
    exists(select 1 from public.keputusan d
      where d.id_keputusan = kriteria_keputusan.id_keputusan
      and d.id_pengguna = (select auth.uid()))
  );
create policy kdec_update_own on public.kriteria_keputusan
  for update to authenticated
  using (exists(select 1 from public.keputusan d
    where d.id_keputusan = kriteria_keputusan.id_keputusan
      and d.id_pengguna = (select auth.uid())))
  with check (exists(select 1 from public.keputusan d
    where d.id_keputusan = kriteria_keputusan.id_keputusan
      and d.id_pengguna = (select auth.uid())));
create policy kdec_delete_own on public.kriteria_keputusan
  for delete to authenticated using (
    exists(select 1 from public.keputusan d
      where d.id_keputusan = kriteria_keputusan.id_keputusan
      and d.id_pengguna = (select auth.uid()))
  );

-- Angka hasil perhitungan dan narasi AI: read-only di aplikasi.
-- Perhitungan ditulis server memakai secret key yang tidak dikirim ke Flutter.
create policy nilai_read_own on public.nilai_pilihan
  for select to authenticated using (
    exists (
      select 1 from public.pilihan_keputusan a
      join public.keputusan d on d.id_keputusan = a.id_keputusan
      join public.kriteria_keputusan k on k.id_kriteria_keputusan = nilai_pilihan.id_kriteria_keputusan
        and k.id_keputusan = d.id_keputusan
      where a.id_pilihan_keputusan = nilai_pilihan.id_pilihan_keputusan
        and d.id_pengguna = (select auth.uid())
    )
  );
create policy hasil_read_own on public.hasil_perbandingan
  for select to authenticated using (
    exists (
      select 1 from public.pilihan_keputusan a
      join public.keputusan d on d.id_keputusan = a.id_keputusan
      where a.id_pilihan_keputusan = hasil_perbandingan.id_pilihan_keputusan
        and d.id_pengguna = (select auth.uid())
    )
  );
create policy insight_read_own on public.insight_ai
  for select to authenticated using (
    exists(select 1 from public.keputusan d
      where d.id_keputusan = insight_ai.id_keputusan
      and d.id_pengguna = (select auth.uid()))
  );

-- Simulasi ditulis user hanya untuk keputusan miliknya.
create policy simulasi_read_own on public.simulasi
  for select to authenticated using (
    exists(select 1 from public.keputusan d
      where d.id_keputusan = simulasi.id_keputusan
      and d.id_pengguna = (select auth.uid()))
  );
create policy simulasi_create_own on public.simulasi
  for insert to authenticated with check (
    exists(select 1 from public.keputusan d
      where d.id_keputusan = simulasi.id_keputusan
      and d.id_pengguna = (select auth.uid()))
  );
create policy simulasi_update_own on public.simulasi
  for update to authenticated
  using (exists(select 1 from public.keputusan d
    where d.id_keputusan = simulasi.id_keputusan
    and d.id_pengguna = (select auth.uid())))
  with check (exists(select 1 from public.keputusan d
    where d.id_keputusan = simulasi.id_keputusan
    and d.id_pengguna = (select auth.uid())));
create policy simulasi_delete_own on public.simulasi
  for delete to authenticated using (
    exists(select 1 from public.keputusan d
      where d.id_keputusan = simulasi.id_keputusan
      and d.id_pengguna = (select auth.uid()))
  );

-- Bobot simulasi hanya untuk kriteria yang berasal dari keputusan yang sama.
create policy bsim_read_own on public.bobot_simulasi
  for select to authenticated using (
    exists (
      select 1 from public.simulasi s
      join public.kriteria_keputusan k on k.id_keputusan = s.id_keputusan
      join public.keputusan d on d.id_keputusan = s.id_keputusan
      where s.id_simulasi = bobot_simulasi.id_simulasi
        and k.id_kriteria_keputusan = bobot_simulasi.id_kriteria_keputusan
        and d.id_pengguna = (select auth.uid())
    )
  );
create policy bsim_create_own on public.bobot_simulasi
  for insert to authenticated with check (
    exists (
      select 1 from public.simulasi s
      join public.kriteria_keputusan k on k.id_keputusan = s.id_keputusan
      join public.keputusan d on d.id_keputusan = s.id_keputusan
      where s.id_simulasi = bobot_simulasi.id_simulasi
        and k.id_kriteria_keputusan = bobot_simulasi.id_kriteria_keputusan
        and d.id_pengguna = (select auth.uid())
    )
  );
create policy bsim_update_own on public.bobot_simulasi
  for update to authenticated
  using (
    exists (select 1 from public.simulasi s
      join public.kriteria_keputusan k on k.id_keputusan = s.id_keputusan
      join public.keputusan d on d.id_keputusan = s.id_keputusan
      where s.id_simulasi = bobot_simulasi.id_simulasi
        and k.id_kriteria_keputusan = bobot_simulasi.id_kriteria_keputusan
        and d.id_pengguna = (select auth.uid()))
  )
  with check (
    exists (select 1 from public.simulasi s
      join public.kriteria_keputusan k on k.id_keputusan = s.id_keputusan
      join public.keputusan d on d.id_keputusan = s.id_keputusan
      where s.id_simulasi = bobot_simulasi.id_simulasi
        and k.id_kriteria_keputusan = bobot_simulasi.id_kriteria_keputusan
        and d.id_pengguna = (select auth.uid()))
  );
create policy bsim_delete_own on public.bobot_simulasi
  for delete to authenticated using (
    exists (
      select 1 from public.simulasi s
      join public.kriteria_keputusan k on k.id_keputusan = s.id_keputusan
      join public.keputusan d on d.id_keputusan = s.id_keputusan
      where s.id_simulasi = bobot_simulasi.id_simulasi
        and k.id_kriteria_keputusan = bobot_simulasi.id_kriteria_keputusan
        and d.id_pengguna = (select auth.uid())
    )
  );

-- Ulasan hasil keputusan milik sendiri.
create policy ulasan_read_own on public.ulasan
  for select to authenticated using (
    exists(select 1 from public.keputusan d
      where d.id_keputusan = ulasan.id_keputusan
      and d.id_pengguna = (select auth.uid()))
  );
create policy ulasan_create_own on public.ulasan
  for insert to authenticated with check (
    exists(select 1 from public.keputusan d
      where d.id_keputusan = ulasan.id_keputusan
      and d.id_pengguna = (select auth.uid()))
  );
create policy ulasan_update_own on public.ulasan
  for update to authenticated
  using (exists(select 1 from public.keputusan d
    where d.id_keputusan = ulasan.id_keputusan
    and d.id_pengguna = (select auth.uid())))
  with check (exists(select 1 from public.keputusan d
    where d.id_keputusan = ulasan.id_keputusan
    and d.id_pengguna = (select auth.uid())));
create policy ulasan_delete_own on public.ulasan
  for delete to authenticated using (
    exists(select 1 from public.keputusan d
      where d.id_keputusan = ulasan.id_keputusan
      and d.id_pengguna = (select auth.uid()))
  );

commit;

-- PENTING - TAHAP LANJUTAN:
-- * Validasi jumlah bobot == 100 dan limit pilihan paket Free/Premium
--   HARUS dicek di backend API (bukan hanya di Flutter).
-- * Validasi semua nilai_pilihan berasal dari keputusan yang sama,
--   juga bahwa katalog/kriteria default cocok dengan subkategori keputusan.
-- * Backend menghitung SAW; jangan izinkan Flutter menulis skor final.
-- * Penonaktifan akun perlu Supabase Auth Admin (ban user) di backend.
-- * Sinkronkan perubahan email auth.users -> pengguna.email jika dibutuhkan.
-- * Id tabel hasil mengasumsikan satu hasil terbaru per pilihan.
--   Jika ingin versi riwayat tiap simulasi/perhitungan, perlu revisi tabel.
