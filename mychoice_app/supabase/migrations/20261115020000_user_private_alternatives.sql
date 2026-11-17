-- Private, per-account options for the Create New Decision catalog.
create table if not exists public.pilihan_katalog_pengguna (
  id_pilihan_pengguna uuid primary key default gen_random_uuid(),
  id_pengguna uuid not null references auth.users(id) on delete cascade,
  id_sub_kategori bigint not null
    references public.sub_kategori(id_sub_kategori) on delete restrict,
  nama_pilihan text not null
    check (length(trim(nama_pilihan)) between 1 and 200),
  atribut jsonb not null default '{}'::jsonb
    check (jsonb_typeof(atribut) = 'object'),
  tanggal_dibuat timestamptz not null default now()
);

create index if not exists ix_pilihan_katalog_pengguna_owner_subcategory
  on public.pilihan_katalog_pengguna (id_pengguna, id_sub_kategori);

create unique index if not exists ux_pilihan_katalog_pengguna_name
  on public.pilihan_katalog_pengguna
    (id_pengguna, id_sub_kategori, lower(trim(nama_pilihan)));

alter table public.pilihan_katalog_pengguna enable row level security;
revoke all on public.pilihan_katalog_pengguna from anon, authenticated;
grant usage on schema public to authenticated;
grant select, insert on public.pilihan_katalog_pengguna to authenticated;

drop policy if exists pilihan_katalog_pengguna_read_own
  on public.pilihan_katalog_pengguna;
create policy pilihan_katalog_pengguna_read_own
  on public.pilihan_katalog_pengguna
  for select to authenticated
  using (id_pengguna = (select auth.uid()));

drop policy if exists pilihan_katalog_pengguna_insert_own
  on public.pilihan_katalog_pengguna;
create policy pilihan_katalog_pengguna_insert_own
  on public.pilihan_katalog_pengguna
  for insert to authenticated
  with check (id_pengguna = (select auth.uid()));
