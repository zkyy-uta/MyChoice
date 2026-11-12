-- ===========================================================
-- MYCHOICE - Tabel Decision History (Riwayat Keputusan)
-- Jalankan di Supabase SQL Editor (tab baru atau tambahkan ke setup utama).
-- Dua tabel:
--   1. decision_histories  - riwayat setiap keputusan yang disimpan user
--   2. decision_history_reviews - ulasan & bintang rating dari user
-- Konvensi sama dengan MyChoice_Supabase_Setup_Pilihan.sql
-- ===========================================================

begin;

-- ============================================================
-- 1. Tabel riwayat keputusan
-- ============================================================
create table if not exists public.decision_histories (
  id          uuid          primary key default gen_random_uuid(),
  user_id     uuid          not null references auth.users(id) on delete cascade,
  category    text          not null,
  subcategory text,
  title       text          not null,
  score       float8        not null check (score >= 0 and score <= 1),
  final_option text,
  decision_date timestamptz not null default now(),
  priorities  jsonb         not null default '{}'::jsonb,
  created_at  timestamptz   not null default now(),
  updated_at  timestamptz   not null default now()
);

-- ============================================================
-- 2. Tabel ulasan & bintang rating (input manual dari user)
-- ============================================================
create table if not exists public.decision_history_reviews (
  id                    uuid        primary key default gen_random_uuid(),
  decision_history_id   uuid        not null
    references public.decision_histories(id) on delete cascade,
  user_id               uuid        not null references auth.users(id) on delete cascade,
  rating                smallint    not null check (rating >= 1 and rating <= 5),
  review                text,
  created_at            timestamptz not null default now(),
  updated_at            timestamptz not null default now(),
  -- Satu ulasan per keputusan per user
  unique (decision_history_id, user_id)
);

-- ============================================================
-- 3. Index untuk performa query
-- ============================================================
create index if not exists idx_decision_histories_user_id
  on public.decision_histories (user_id);

create index if not exists idx_decision_histories_created_at
  on public.decision_histories (created_at desc);

create index if not exists idx_decision_history_reviews_history_id
  on public.decision_history_reviews (decision_history_id);

create index if not exists idx_decision_history_reviews_user_id
  on public.decision_history_reviews (user_id);

-- ============================================================
-- 4. Enable Row Level Security
-- ============================================================
alter table public.decision_histories        enable row level security;
alter table public.decision_history_reviews  enable row level security;

-- ============================================================
-- 5. Grant akses ke role authenticated
-- ============================================================
grant select, insert, update, delete
  on public.decision_histories
  to authenticated;

grant select, insert, update, delete
  on public.decision_history_reviews
  to authenticated;

-- service_role untuk backend / admin
grant select, insert, update, delete
  on public.decision_histories,
     public.decision_history_reviews
  to service_role;

-- ============================================================
-- 6. RLS Policies - decision_histories
--    User hanya bisa kelola baris miliknya sendiri
-- ============================================================
create policy dh_select_own on public.decision_histories
  for select to authenticated
  using (user_id = (select auth.uid()));

create policy dh_insert_own on public.decision_histories
  for insert to authenticated
  with check (user_id = (select auth.uid()));

create policy dh_update_own on public.decision_histories
  for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

create policy dh_delete_own on public.decision_histories
  for delete to authenticated
  using (user_id = (select auth.uid()));

-- ============================================================
-- 7. RLS Policies - decision_history_reviews
--    User hanya bisa kelola ulasan miliknya sendiri
-- ============================================================
create policy dhr_select_own on public.decision_history_reviews
  for select to authenticated
  using (user_id = (select auth.uid()));

create policy dhr_insert_own on public.decision_history_reviews
  for insert to authenticated
  with check (user_id = (select auth.uid()));

create policy dhr_update_own on public.decision_history_reviews
  for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

create policy dhr_delete_own on public.decision_history_reviews
  for delete to authenticated
  using (user_id = (select auth.uid()));

commit;

-- ===========================================================
-- CATATAN:
-- - Kolom score bertipe float8 dengan constraint 0..1 (hasil SAW).
-- - Kolom priorities bertipe jsonb, contoh: {"Price": 30, "RAM": 40}
-- - Tabel decision_history_reviews dipisah agar bisa diisi kapan saja
--   setelah keputusan dibuat (tidak harus langsung saat save decision).
-- - Tidak perlu RPC function; Flutter query langsung dengan left join
--   ke decision_history_reviews melalui Supabase .select('*, reviews(...)').
-- ===========================================================
