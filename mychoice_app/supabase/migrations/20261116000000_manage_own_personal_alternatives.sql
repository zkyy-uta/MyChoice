grant update, delete on public.pilihan_katalog_pengguna to authenticated;

drop policy if exists pilihan_katalog_pengguna_update_own
  on public.pilihan_katalog_pengguna;
create policy pilihan_katalog_pengguna_update_own
  on public.pilihan_katalog_pengguna
  for update to authenticated
  using (id_pengguna = (select auth.uid()))
  with check (id_pengguna = (select auth.uid()));

drop policy if exists pilihan_katalog_pengguna_delete_own
  on public.pilihan_katalog_pengguna;
create policy pilihan_katalog_pengguna_delete_own
  on public.pilihan_katalog_pengguna
  for delete to authenticated
  using (id_pengguna = (select auth.uid()));
