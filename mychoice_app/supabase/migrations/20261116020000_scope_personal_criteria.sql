alter table public.kriteria_personal_pengguna
  add column if not exists id_sub_kategori bigint
    references public.sub_kategori(id_sub_kategori) on delete restrict;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'kriteria_personal_pengguna_subcategory_required'
      and conrelid = 'public.kriteria_personal_pengguna'::regclass
  ) then
    alter table public.kriteria_personal_pengguna
      add constraint kriteria_personal_pengguna_subcategory_required
      check (id_sub_kategori is not null) not valid;
  end if;
end
$$;

drop index if exists public.ux_kriteria_personal_pengguna_name;

create unique index if not exists ux_kriteria_personal_pengguna_scope_name
  on public.kriteria_personal_pengguna
    (id_pengguna, id_sub_kategori, lower(trim(nama_kriteria)))
  where id_sub_kategori is not null;
