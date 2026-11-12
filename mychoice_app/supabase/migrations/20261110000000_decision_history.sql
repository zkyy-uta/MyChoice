-- Migration: Decision History + ulasan & bintang rating dari user
-- Membuat tabel untuk menyimpan riwayat keputusan dan ulasan (review + rating) yang diinput user sendiri.

-- 1. Tabel riwayat keputusan
create table if not exists public.decision_histories (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  category text not null,
  subcategory text,
  title text not null,
  score double precision not null check (score >= 0 and score <= 1),
  final_option text,
  decision_date timestamptz not null default now(),
  priorities jsonb default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- 2. Tabel ulasan & bintang rating (user bisa input bintang sendiri)
create table if not exists public.decision_history_reviews (
  id uuid primary key default gen_random_uuid(),
  decision_history_id uuid not null references public.decision_histories (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  rating smallint not null check (rating >= 1 and rating <= 5),
  review text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (decision_history_id, user_id)
);

-- Index untuk mempercepat pengambilan riwayat per user
create index if not exists idx_decision_histories_user_id
  on public.decision_histories (user_id);
create index if not exists idx_decision_histories_created_at
  on public.decision_histories (created_at desc);
create index if not exists idx_decision_history_reviews_history_id
  on public.decision_history_reviews (decision_history_id);
create index if not exists idx_decision_history_reviews_user_id
  on public.decision_history_reviews (user_id);

-- 3. Aktifkan Row Level Security
alter table public.decision_histories enable row level security;
alter table public.decision_history_reviews enable row level security;

-- 4. Berikan izin ke role authenticated
grant usage on schema public to authenticated;
grant select, insert, update, delete on public.decision_histories to authenticated;
grant select, insert, update, delete on public.decision_history_reviews to authenticated;

-- 5. Kebijakan RLS decision_histories: user hanya kelola baris miliknya sendiri
do $$
begin
  if not exists (
    select 1 from pg_policy where polname = 'decision_histories_own_all' and polrelid = 'public.decision_histories'::regclass
  ) then
    create policy decision_histories_own_all
      on public.decision_histories
      for all
      to authenticated
      using (user_id = (select auth.uid()))
      with check (user_id = (select auth.uid()));
  end if;
end $$;

-- 6. Kebijakan RLS decision_history_reviews: user hanya kelola ulasan miliknya sendiri
do $$
begin
  if not exists (
    select 1 from pg_policy where polname = 'decision_history_reviews_own_all' and polrelid = 'public.decision_history_reviews'::regclass
  ) then
    create policy decision_history_reviews_own_all
      on public.decision_history_reviews
      for all
      to authenticated
      using (user_id = (select auth.uid()))
      with check (user_id = (select auth.uid()));
  end if;
end $$;

-- 7. Fungsi helper untuk mengambil riwayat beserta ulasan & rating milik user
create or replace function public.get_user_decision_history_with_review()
returns table (
  id uuid,
  user_id uuid,
  category text,
  subcategory text,
  title text,
  score double precision,
  final_option text,
  decision_date timestamptz,
  priorities jsonb,
  created_at timestamptz,
  updated_at timestamptz,
  rating smallint,
  review text
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    dh.id,
    dh.user_id,
    dh.category,
    dh.subcategory,
    dh.title,
    dh.score,
    dh.final_option,
    dh.decision_date,
    dh.priorities,
    dh.created_at,
    dh.updated_at,
    coalesce(dhr.rating, 0) as rating,
    dhr.review
  from public.decision_histories as dh
  left join public.decision_history_reviews as dhr
    on dhr.decision_history_id = dh.id
   and dhr.user_id = dh.user_id
  where dh.user_id = (select auth.uid())
  order by dh.created_at desc;
$$;

revoke all on function public.get_user_decision_history_with_review() from public;
grant execute on function public.get_user_decision_history_with_review() to authenticated;
