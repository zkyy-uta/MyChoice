create table if not exists public.kriteria_personal_pengguna (
  id_kriteria_pengguna uuid primary key default gen_random_uuid(),
  id_pengguna uuid not null references auth.users(id) on delete cascade,
  nama_kriteria text not null
    check (length(trim(nama_kriteria)) between 1 and 100),
  tanggal_dibuat timestamptz not null default now()
);

create unique index if not exists ux_kriteria_personal_pengguna_name
  on public.kriteria_personal_pengguna
    (id_pengguna, lower(trim(nama_kriteria)));

alter table public.kriteria_personal_pengguna enable row level security;
revoke all on public.kriteria_personal_pengguna from anon, authenticated;
grant usage on schema public to authenticated;
grant select, insert on public.kriteria_personal_pengguna to authenticated;

drop policy if exists kriteria_personal_pengguna_read_own
  on public.kriteria_personal_pengguna;
create policy kriteria_personal_pengguna_read_own
  on public.kriteria_personal_pengguna
  for select to authenticated
  using (id_pengguna = (select auth.uid()));

drop policy if exists kriteria_personal_pengguna_insert_own
  on public.kriteria_personal_pengguna;
create policy kriteria_personal_pengguna_insert_own
  on public.kriteria_personal_pengguna
  for insert to authenticated
  with check (id_pengguna = (select auth.uid()));
