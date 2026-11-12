-- ===========================================================
-- MYCHOICE - Seed Data Kategori & Sub Kategori
-- Jalankan SETELAH MyChoice_Supabase_Setup_Pilihan.sql
-- Isi tabel kategori dan sub_kategori agar tabel keputusan
-- bisa menyimpan id_sub_kategori yang valid.
-- ===========================================================

-- Kategori
insert into public.kategori (nama_kategori, deskripsi) values
  ('Technology', 'Electronics and computing devices'),
  ('Education',  'Learning and courses'),
  ('Fashion',    'Clothing and accessories')
on conflict (nama_kategori) do nothing;

-- Sub Kategori - Technology
insert into public.sub_kategori (id_kategori, nama_sub_kategori)
select k.id_kategori, s.nama
from public.kategori k
cross join (values
  ('Laptop'),
  ('Smartphone'),
  ('Tablet'),
  ('Monitor'),
  ('Gaming PC'),
  ('Processor'),
  ('Graphics Card')
) as s(nama)
where k.nama_kategori = 'Technology'
on conflict (id_kategori, nama_sub_kategori) do nothing;

-- Sub Kategori - Education
insert into public.sub_kategori (id_kategori, nama_sub_kategori)
select k.id_kategori, s.nama
from public.kategori k
cross join (values
  ('Course'),
  ('Certification'),
  ('Bootcamp'),
  ('University'),
  ('Training Program')
) as s(nama)
where k.nama_kategori = 'Education'
on conflict (id_kategori, nama_sub_kategori) do nothing;

-- Sub Kategori - Fashion
insert into public.sub_kategori (id_kategori, nama_sub_kategori)
select k.id_kategori, s.nama
from public.kategori k
cross join (values
  ('Dress'),
  ('Shoes'),
  ('Accessories'),
  ('Bags'),
  ('Jewelry'),
  ('Outerwear')
) as s(nama)
where k.nama_kategori = 'Fashion'
on conflict (id_kategori, nama_sub_kategori) do nothing;

-- Verifikasi hasil seed
select k.nama_kategori, s.id_sub_kategori, s.nama_sub_kategori
from public.sub_kategori s
join public.kategori k on k.id_kategori = s.id_kategori
order by k.nama_kategori, s.id_sub_kategori;
