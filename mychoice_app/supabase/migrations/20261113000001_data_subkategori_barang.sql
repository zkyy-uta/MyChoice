-- ===========================================================
-- MYCHOICE - Seed Data Kategori, Sub Kategori, dan Barang
-- Hanya DATA (INSERT), TANPA membuat tabel baru.
-- Jalankan di Supabase SQL Editor pada project yang sudah memiliki
-- tabel public.kategori, public.sub_kategori, public.pilihan_katalog.
-- Aman dijalankan berulang kali (idempotent).
-- ===========================================================

-- 1. Kategori
INSERT INTO public.kategori (nama_kategori, deskripsi)
SELECT 'Technology', 'Electronics and computing devices'
WHERE NOT EXISTS (
  SELECT 1 FROM public.kategori WHERE nama_kategori = 'Technology'
);
INSERT INTO public.kategori (nama_kategori, deskripsi)
SELECT 'Education', 'Learning and courses'
WHERE NOT EXISTS (
  SELECT 1 FROM public.kategori WHERE nama_kategori = 'Education'
);
INSERT INTO public.kategori (nama_kategori, deskripsi)
SELECT 'Fashion', 'Clothing and accessories'
WHERE NOT EXISTS (
  SELECT 1 FROM public.kategori WHERE nama_kategori = 'Fashion'
);

-- 2. Sub Kategori
INSERT INTO public.sub_kategori (id_kategori, nama_sub_kategori)
SELECT k.id_kategori, 'Laptop'
FROM public.kategori k
WHERE k.nama_kategori = 'Technology'
  AND NOT EXISTS (
    SELECT 1 FROM public.sub_kategori sk
    WHERE sk.id_kategori = k.id_kategori
      AND sk.nama_sub_kategori = 'Laptop'
  );
INSERT INTO public.sub_kategori (id_kategori, nama_sub_kategori)
SELECT k.id_kategori, 'Smartphone'
FROM public.kategori k
WHERE k.nama_kategori = 'Technology'
  AND NOT EXISTS (
    SELECT 1 FROM public.sub_kategori sk
    WHERE sk.id_kategori = k.id_kategori
      AND sk.nama_sub_kategori = 'Smartphone'
  );
INSERT INTO public.sub_kategori (id_kategori, nama_sub_kategori)
SELECT k.id_kategori, 'Tablet'
FROM public.kategori k
WHERE k.nama_kategori = 'Technology'
  AND NOT EXISTS (
    SELECT 1 FROM public.sub_kategori sk
    WHERE sk.id_kategori = k.id_kategori
      AND sk.nama_sub_kategori = 'Tablet'
  );
INSERT INTO public.sub_kategori (id_kategori, nama_sub_kategori)
SELECT k.id_kategori, 'Monitor'
FROM public.kategori k
WHERE k.nama_kategori = 'Technology'
  AND NOT EXISTS (
    SELECT 1 FROM public.sub_kategori sk
    WHERE sk.id_kategori = k.id_kategori
      AND sk.nama_sub_kategori = 'Monitor'
  );
INSERT INTO public.sub_kategori (id_kategori, nama_sub_kategori)
SELECT k.id_kategori, 'Gaming PC'
FROM public.kategori k
WHERE k.nama_kategori = 'Technology'
  AND NOT EXISTS (
    SELECT 1 FROM public.sub_kategori sk
    WHERE sk.id_kategori = k.id_kategori
      AND sk.nama_sub_kategori = 'Gaming PC'
  );
INSERT INTO public.sub_kategori (id_kategori, nama_sub_kategori)
SELECT k.id_kategori, 'Processor'
FROM public.kategori k
WHERE k.nama_kategori = 'Technology'
  AND NOT EXISTS (
    SELECT 1 FROM public.sub_kategori sk
    WHERE sk.id_kategori = k.id_kategori
      AND sk.nama_sub_kategori = 'Processor'
  );
INSERT INTO public.sub_kategori (id_kategori, nama_sub_kategori)
SELECT k.id_kategori, 'Graphics Card'
FROM public.kategori k
WHERE k.nama_kategori = 'Technology'
  AND NOT EXISTS (
    SELECT 1 FROM public.sub_kategori sk
    WHERE sk.id_kategori = k.id_kategori
      AND sk.nama_sub_kategori = 'Graphics Card'
  );
INSERT INTO public.sub_kategori (id_kategori, nama_sub_kategori)
SELECT k.id_kategori, 'Course'
FROM public.kategori k
WHERE k.nama_kategori = 'Education'
  AND NOT EXISTS (
    SELECT 1 FROM public.sub_kategori sk
    WHERE sk.id_kategori = k.id_kategori
      AND sk.nama_sub_kategori = 'Course'
  );
INSERT INTO public.sub_kategori (id_kategori, nama_sub_kategori)
SELECT k.id_kategori, 'Certification'
FROM public.kategori k
WHERE k.nama_kategori = 'Education'
  AND NOT EXISTS (
    SELECT 1 FROM public.sub_kategori sk
    WHERE sk.id_kategori = k.id_kategori
      AND sk.nama_sub_kategori = 'Certification'
  );
INSERT INTO public.sub_kategori (id_kategori, nama_sub_kategori)
SELECT k.id_kategori, 'Bootcamp'
FROM public.kategori k
WHERE k.nama_kategori = 'Education'
  AND NOT EXISTS (
    SELECT 1 FROM public.sub_kategori sk
    WHERE sk.id_kategori = k.id_kategori
      AND sk.nama_sub_kategori = 'Bootcamp'
  );
INSERT INTO public.sub_kategori (id_kategori, nama_sub_kategori)
SELECT k.id_kategori, 'University'
FROM public.kategori k
WHERE k.nama_kategori = 'Education'
  AND NOT EXISTS (
    SELECT 1 FROM public.sub_kategori sk
    WHERE sk.id_kategori = k.id_kategori
      AND sk.nama_sub_kategori = 'University'
  );
INSERT INTO public.sub_kategori (id_kategori, nama_sub_kategori)
SELECT k.id_kategori, 'Training Program'
FROM public.kategori k
WHERE k.nama_kategori = 'Education'
  AND NOT EXISTS (
    SELECT 1 FROM public.sub_kategori sk
    WHERE sk.id_kategori = k.id_kategori
      AND sk.nama_sub_kategori = 'Training Program'
  );
INSERT INTO public.sub_kategori (id_kategori, nama_sub_kategori)
SELECT k.id_kategori, 'Dress'
FROM public.kategori k
WHERE k.nama_kategori = 'Fashion'
  AND NOT EXISTS (
    SELECT 1 FROM public.sub_kategori sk
    WHERE sk.id_kategori = k.id_kategori
      AND sk.nama_sub_kategori = 'Dress'
  );
INSERT INTO public.sub_kategori (id_kategori, nama_sub_kategori)
SELECT k.id_kategori, 'Shoes'
FROM public.kategori k
WHERE k.nama_kategori = 'Fashion'
  AND NOT EXISTS (
    SELECT 1 FROM public.sub_kategori sk
    WHERE sk.id_kategori = k.id_kategori
      AND sk.nama_sub_kategori = 'Shoes'
  );
INSERT INTO public.sub_kategori (id_kategori, nama_sub_kategori)
SELECT k.id_kategori, 'Accessories'
FROM public.kategori k
WHERE k.nama_kategori = 'Fashion'
  AND NOT EXISTS (
    SELECT 1 FROM public.sub_kategori sk
    WHERE sk.id_kategori = k.id_kategori
      AND sk.nama_sub_kategori = 'Accessories'
  );
INSERT INTO public.sub_kategori (id_kategori, nama_sub_kategori)
SELECT k.id_kategori, 'Bags'
FROM public.kategori k
WHERE k.nama_kategori = 'Fashion'
  AND NOT EXISTS (
    SELECT 1 FROM public.sub_kategori sk
    WHERE sk.id_kategori = k.id_kategori
      AND sk.nama_sub_kategori = 'Bags'
  );
INSERT INTO public.sub_kategori (id_kategori, nama_sub_kategori)
SELECT k.id_kategori, 'Jewelry'
FROM public.kategori k
WHERE k.nama_kategori = 'Fashion'
  AND NOT EXISTS (
    SELECT 1 FROM public.sub_kategori sk
    WHERE sk.id_kategori = k.id_kategori
      AND sk.nama_sub_kategori = 'Jewelry'
  );
INSERT INTO public.sub_kategori (id_kategori, nama_sub_kategori)
SELECT k.id_kategori, 'Outerwear'
FROM public.kategori k
WHERE k.nama_kategori = 'Fashion'
  AND NOT EXISTS (
    SELECT 1 FROM public.sub_kategori sk
    WHERE sk.id_kategori = k.id_kategori
      AND sk.nama_sub_kategori = 'Outerwear'
  );

-- 3. Barang / Pilihan Katalog
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Dell XPS 13', 1299, 'Processor: Intel Core i7-13700H; RAM: 16GB LPDDR5; Storage: 512GB NVMe SSD; Display: 13.4" OLED (1920x1200); Battery: 52Wh (9-11 hours); Weight: 1.2 kg; Price: $1,299; GPU: Intel Iris Xe', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Laptop'
  AND sk.nama_sub_kategori = 'Laptop'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Dell XPS 13'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'HP Pavilion 15', 649, 'Processor: AMD Ryzen 7 5700U; RAM: 16GB DDR4; Storage: 256GB SSD; Display: 15.6" IPS (1920x1080); Battery: 52.5Wh (7-8 hours); Weight: 1.75 kg; Price: $649; GPU: AMD Radeon Graphics', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Laptop'
  AND sk.nama_sub_kategori = 'Laptop'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'HP Pavilion 15'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Lenovo ThinkPad X1 Carbon', 1599, 'Processor: Intel Core i7-13700HX; RAM: 32GB LPDDR5; Storage: 1TB NVMe SSD; Display: 14" OLED (2880x1800); Battery: 63Wh (12+ hours); Weight: 1.19 kg; Price: $1,599; GPU: Intel Iris Xe', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Laptop'
  AND sk.nama_sub_kategori = 'Laptop'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Lenovo ThinkPad X1 Carbon'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'ASUS VivoBook 15', 499, 'Processor: AMD Ryzen 5 5500U; RAM: 8GB DDR4; Storage: 512GB SSD; Display: 15.6" IPS (1920x1080); Battery: 42Wh (8 hours); Weight: 1.8 kg; Price: $499; GPU: AMD Radeon Graphics', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Laptop'
  AND sk.nama_sub_kategori = 'Laptop'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'ASUS VivoBook 15'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Apple MacBook Pro 14"', 1999, 'Processor: Apple M3 Pro; RAM: 18GB Unified Memory; Storage: 512GB SSD; Display: 14.2" Liquid Retina XDR; Battery: 17 hours; Weight: 1.6 kg; Price: $1,999; GPU: 18-core GPU', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Laptop'
  AND sk.nama_sub_kategori = 'Laptop'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Apple MacBook Pro 14"'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Acer Aspire 5', 549, 'Processor: Intel Core i5-12450H; RAM: 8GB DDR4; Storage: 512GB SSD; Display: 15.6" IPS (1920x1080); Battery: 50Wh (8-9 hours); Weight: 1.9 kg; Price: $549; GPU: Intel UHD Graphics', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Laptop'
  AND sk.nama_sub_kategori = 'Laptop'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Acer Aspire 5'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'MSI Stealth 16 (Gaming)', 2199, 'Processor: Intel Core i9-13900HX; RAM: 32GB DDR5; Storage: 1TB NVMe SSD; Display: 16" IPS (2560x1600, 240Hz); Battery: 80Wh (6 hours gaming); Weight: 2.2 kg; Price: $2,199; GPU: NVIDIA RTX 4070', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Laptop'
  AND sk.nama_sub_kategori = 'Laptop'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'MSI Stealth 16 (Gaming)'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'ASUS VivoBook 16X', 699, 'Processor: AMD Ryzen 7 7730U; RAM: 16GB DDR4; Storage: 512GB NVMe SSD; Display: 16" IPS (1920x1200, 60Hz); Battery: 70Wh (9-10 hours); Weight: 1.88 kg; Price: $699; GPU: AMD Radeon Graphics', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Laptop'
  AND sk.nama_sub_kategori = 'Laptop'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'ASUS VivoBook 16X'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Lenovo IdeaPad Slim 5', 599, 'Processor: AMD Ryzen 5 7530U; RAM: 8GB LPDDR4x; Storage: 512GB NVMe SSD; Display: 14" IPS (1920x1080, 60Hz); Battery: 57Wh (8-9 hours); Weight: 1.46 kg; Price: $599; GPU: AMD Radeon Graphics', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Laptop'
  AND sk.nama_sub_kategori = 'Laptop'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Lenovo IdeaPad Slim 5'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Acer Swift 5', 999, 'Processor: Intel Core i7-1260P; RAM: 16GB LPDDR5; Storage: 512GB NVMe SSD; Display: 14" IPS (2560x1600, 90Hz); Battery: 56Wh (up to 13 hours); Weight: 1.35 kg; Price: $999; GPU: Intel Iris Xe', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Laptop'
  AND sk.nama_sub_kategori = 'Laptop'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Acer Swift 5'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'HP Envy x360', 899, 'Processor: AMD Ryzen 7 7730U; RAM: 16GB LPDDR4x; Storage: 512GB SSD; Display: 13.3" OLED Touch (1920x1200); Battery: 66Wh (10+ hours); Weight: 1.35 kg; Price: $899; GPU: AMD Radeon Graphics', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Laptop'
  AND sk.nama_sub_kategori = 'Laptop'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'HP Envy x360'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'MSI Prestige 16', 1499, 'Processor: Intel Core i7-13700H; RAM: 32GB DDR5; Storage: 1TB NVMe SSD; Display: 16" QHD+ IPS (2560x1600, 165Hz); Battery: 99.9Wh (up to 12 hours); Weight: 1.7 kg; Price: $1,499; GPU: NVIDIA RTX 4060', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Laptop'
  AND sk.nama_sub_kategori = 'Laptop'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'MSI Prestige 16'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Huawei MateBook D16', 749, 'Processor: Intel Core i5-12450H; RAM: 16GB DDR4; Storage: 512GB NVMe SSD; Display: 16" IPS (1920x1200, 60Hz); Battery: 60Wh (up to 10 hours); Weight: 1.7 kg; Price: $749; GPU: Intel UHD Graphics', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Laptop'
  AND sk.nama_sub_kategori = 'Laptop'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Huawei MateBook D16'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'iPhone 15 Pro', 999, 'Processor: Apple A17 Pro; RAM: 8GB; Storage: 256GB; Display: 6.1" Super Retina XDR OLED; Battery: 3,274 mAh (up to 29 hours); Weight: 187g; Price: $999; Camera: 48MP Main, 12MP Ultra Wide, 12MP Telephoto', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Smartphone'
  AND sk.nama_sub_kategori = 'Smartphone'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'iPhone 15 Pro'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Samsung Galaxy S24 Ultra', 1299, 'Processor: Snapdragon 8 Gen 3; RAM: 12GB; Storage: 256GB; Display: 6.8" Dynamic AMOLED (120Hz); Battery: 5,000 mAh (up to 30 hours); Weight: 218g; Price: $1,299; Camera: 200MP Main, 50MP Ultra Wide, 10MP Telephoto 3x, 10MP Telephoto 5x', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Smartphone'
  AND sk.nama_sub_kategori = 'Smartphone'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Samsung Galaxy S24 Ultra'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Google Pixel 8', 799, 'Processor: Google Tensor G3; RAM: 8GB; Storage: 128GB; Display: 6.2" OLED (120Hz); Battery: 4,700 mAh (up to 24 hours); Weight: 187g; Price: $799; Camera: 50MP Main, 12MP Ultra Wide, 8MP Telephoto', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Smartphone'
  AND sk.nama_sub_kategori = 'Smartphone'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Google Pixel 8'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'OnePlus 12', 799, 'Processor: Snapdragon 8 Gen 3 Leading Version; RAM: 12GB; Storage: 256GB; Display: 6.7" Fluid AMOLED (120Hz); Battery: 5,400 mAh (up to 50 hours); Weight: 220g; Price: $799; Camera: 50MP Main (f/1.6), 48MP Ultra Wide, 8MP Telephoto 3x', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Smartphone'
  AND sk.nama_sub_kategori = 'Smartphone'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'OnePlus 12'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Xiaomi 14', 699, 'Processor: Snapdragon 8 Gen 3; RAM: 12GB; Storage: 512GB; Display: 6.36" AMOLED (120Hz); Battery: 4,610 mAh (up to 24 hours); Weight: 181g; Price: $699; Camera: 50MP Main (Leica), 50MP Ultra Wide, 50MP Telephoto 3.2x', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Smartphone'
  AND sk.nama_sub_kategori = 'Smartphone'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Xiaomi 14'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Poco X6 Pro', 399, 'Processor: Snapdragon 7 Gen 3; RAM: 12GB; Storage: 256GB; Display: 6.67" AMOLED (120Hz); Battery: 5,110 mAh (up to 40 hours); Weight: 218g; Price: $399; Camera: 50MP Main (OIS), 8MP Ultra Wide, 2MP Macro', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Smartphone'
  AND sk.nama_sub_kategori = 'Smartphone'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Poco X6 Pro'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Samsung Galaxy S23', 799, 'Processor: Snapdragon 8 Gen 2; RAM: 8GB; Storage: 128GB; Display: 6.1" Dynamic AMOLED 2X (120Hz); Battery: 4,000 mAh (up to 22 hours); Weight: 168g; Price: $799; Camera: 50MP Main, 12MP Ultra Wide, 10MP Telephoto 3x', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Smartphone'
  AND sk.nama_sub_kategori = 'Smartphone'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Samsung Galaxy S23'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Xiaomi 14 Pro', 899, 'Processor: Snapdragon 8 Gen 3; RAM: 16GB; Storage: 512GB; Display: 6.73" LTPO AMOLED (120Hz); Battery: 4,880 mAh (90W wired, 50W wireless); Weight: 223g; Price: $899; Camera: 50MP Leica Main, 50MP Ultra Wide, 50MP Periscope 5x', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Smartphone'
  AND sk.nama_sub_kategori = 'Smartphone'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Xiaomi 14 Pro'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'OPPO Find X7', 749, 'Processor: Dimensity 9300; RAM: 12GB; Storage: 256GB; Display: 6.74" LTPO3 AMOLED (120Hz); Battery: 5,000 mAh (100W wired); Weight: 209g; Price: $749; Camera: 50MP Main (Hasselblad), 64MP Periscope, 50MP Ultra Wide', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Smartphone'
  AND sk.nama_sub_kategori = 'Smartphone'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'OPPO Find X7'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Vivo X100 Pro', 849, 'Processor: Dimensity 9300; RAM: 16GB; Storage: 512GB; Display: 6.78" LTPO AMOLED (120Hz); Battery: 5,400 mAh (100W wired, 50W wireless); Weight: 225g; Price: $849; Camera: 50MP ZEISS Main, 50MP Periscope 5x, 50MP Ultra Wide', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Smartphone'
  AND sk.nama_sub_kategori = 'Smartphone'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Vivo X100 Pro'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Realme GT 5 Pro', 599, 'Processor: Snapdragon 8 Gen 3; RAM: 16GB; Storage: 512GB; Display: 6.78" LTPO AMOLED (144Hz); Battery: 5,400 mAh (100W wired); Weight: 221g; Price: $599; Camera: 50MP Sony Main, 50MP Periscope 3x, 8MP Ultra Wide', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Smartphone'
  AND sk.nama_sub_kategori = 'Smartphone'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Realme GT 5 Pro'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Samsung Galaxy A55', 449, 'Processor: Exynos 1480; RAM: 8GB; Storage: 256GB; Display: 6.6" Super AMOLED (120Hz); Battery: 5,000 mAh (25W wired); Weight: 213g; Price: $449; Camera: 50MP OIS Main, 12MP Ultra Wide, 5MP Macro', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Smartphone'
  AND sk.nama_sub_kategori = 'Smartphone'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Samsung Galaxy A55'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'iPhone 15', 799, 'Processor: Apple A16 Bionic; RAM: 6GB; Storage: 128GB; Display: 6.1" Super Retina XDR OLED; Battery: 3,349 mAh (up to 20 hours video); Weight: 171g; Price: $799; Camera: 48MP Main, 12MP Ultra Wide', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Smartphone'
  AND sk.nama_sub_kategori = 'Smartphone'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'iPhone 15'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'iPad Pro 12.9"', 1099, 'Processor: Apple M2; RAM: 8GB Unified Memory; Storage: 256GB; Display: 12.9" Liquid Retina XDR; Battery: 10,308 mAh (10 hours); Weight: 682g; Price: $1,099; Connectivity: WiFi 6E + 5G optional', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Tablet'
  AND sk.nama_sub_kategori = 'Tablet'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'iPad Pro 12.9"'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Samsung Galaxy Tab S9 Ultra', 1199, 'Processor: Snapdragon 8 Gen 2; RAM: 12GB; Storage: 256GB; Display: 14.6" Dynamic AMOLED (120Hz); Battery: 11,200 mAh (up to 18 hours); Weight: 732g; Price: $1,199; Connectivity: WiFi 6E + 5G optional', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Tablet'
  AND sk.nama_sub_kategori = 'Tablet'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Samsung Galaxy Tab S9 Ultra'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Lenovo Tab P11 Pro Gen 2', 499, 'Processor: MediaTek Kompanio 1300T; RAM: 8GB; Storage: 128GB; Display: 11.5" OLED (90Hz); Battery: 10,100 mAh (up to 16 hours); Weight: 485g; Price: $499; Connectivity: WiFi 6 + 5G optional', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Tablet'
  AND sk.nama_sub_kategori = 'Tablet'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Lenovo Tab P11 Pro Gen 2'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Microsoft Surface Pro 9', 1299, 'Processor: Intel Core i7-1255U; RAM: 16GB; Storage: 512GB SSD; Display: 13" PixelSense Touch (2880x1920); Battery: 50Wh (up to 19 hours); Weight: 879g; Price: $1,299; Connectivity: WiFi 6 + optional 5G', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Tablet'
  AND sk.nama_sub_kategori = 'Tablet'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Microsoft Surface Pro 9'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Apple iPad Air 11"', 599, 'Processor: Apple M1; RAM: 8GB Unified Memory; Storage: 128GB; Display: 11" Liquid Retina; Battery: 7,134 mAh (10 hours); Weight: 481g; Price: $599; Connectivity: WiFi 6E + 5G optional', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Tablet'
  AND sk.nama_sub_kategori = 'Tablet'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Apple iPad Air 11"'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Samsung Galaxy Tab S8 FE', 299, 'Processor: MediaTek Helio G78; RAM: 4GB; Storage: 64GB; Display: 12.4" TFT LCD (90Hz); Battery: 10,000 mAh (up to 14 hours); Weight: 507g; Price: $299; Connectivity: WiFi 5 + optional LTE', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Tablet'
  AND sk.nama_sub_kategori = 'Tablet'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Samsung Galaxy Tab S8 FE'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'iPad Pro M4', 999, 'Processor: Apple M4; RAM: 16GB Unified Memory; Storage: 256GB; Display: 11" Ultra Retina XDR OLED; Battery: 7,272 mAh (10 hours); Weight: 444g; Price: $999; Connectivity: WiFi 6E + 5G', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Tablet'
  AND sk.nama_sub_kategori = 'Tablet'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'iPad Pro M4'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Samsung Galaxy Tab S9', 799, 'Processor: Snapdragon 8 Gen 2; RAM: 8GB; Storage: 128GB; Display: 11" Dynamic AMOLED 2X (120Hz); Battery: 8,400 mAh (up to 15 hours); Weight: 498g; Price: $799; Connectivity: WiFi 6E + 5G optional', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Tablet'
  AND sk.nama_sub_kategori = 'Tablet'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Samsung Galaxy Tab S9'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Xiaomi Pad 6 Pro', 549, 'Processor: Snapdragon 8+ Gen 1; RAM: 12GB; Storage: 256GB; Display: 11" IPS LCD (2880x1800, 144Hz); Battery: 8,600 mAh (67W wired); Weight: 490g; Price: $549; Connectivity: WiFi 6E', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Tablet'
  AND sk.nama_sub_kategori = 'Tablet'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Xiaomi Pad 6 Pro'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'OPPO Pad 2', 499, 'Processor: Dimensity 9000; RAM: 12GB; Storage: 256GB; Display: 11.61" LCD (2800x2000, 144Hz); Battery: 9,510 mAh (67W wired); Weight: 552g; Price: $499; Connectivity: WiFi 6', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Tablet'
  AND sk.nama_sub_kategori = 'Tablet'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'OPPO Pad 2'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Lenovo Tab P12 Pro', 599, 'Processor: Snapdragon 870; RAM: 8GB; Storage: 256GB; Display: 12.6" AMOLED (2560x1600, 120Hz); Battery: 10,200 mAh (45W wired); Weight: 565g; Price: $599; Connectivity: WiFi 6 + optional 5G', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Tablet'
  AND sk.nama_sub_kategori = 'Tablet'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Lenovo Tab P12 Pro'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Huawei MatePad Pro', 649, 'Processor: Kirin 9000S; RAM: 12GB; Storage: 256GB; Display: 11" IPS (2560x1600, 120Hz); Battery: 7,250 mAh (66W wired); Weight: 449g; Price: $649; Connectivity: WiFi 6', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Tablet'
  AND sk.nama_sub_kategori = 'Tablet'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Huawei MatePad Pro'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'LG UltraWide 38"', 2999, 'Resolution: 3840x1600; Panel: IPS Curved (3800R); Refresh Rate: 60Hz; Response Time: 5ms; HDR: Yes (HDR10); Price: $2,999; Color Gamut: 98.5% DCI-P3; Ports: 2x Thunderbolt 3, USB-C, DisplayPort', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Monitor'
  AND sk.nama_sub_kategori = 'Monitor'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'LG UltraWide 38"'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Dell UltraSharp U2720Q', 799, 'Resolution: 3840x2160 (4K); Panel: IPS; Refresh Rate: 60Hz; Response Time: 5ms; HDR: Yes; Price: $799; Color Gamut: 99.5% Adobe RGB; Ports: 2x DisplayPort, 2x HDMI, USB-C', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Monitor'
  AND sk.nama_sub_kategori = 'Monitor'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Dell UltraSharp U2720Q'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'BenQ PD2500Q', 499, 'Resolution: 2560x1440; Panel: IPS; Refresh Rate: 60Hz; Response Time: 5ms; HDR: No; Price: $499; Color Gamut: 99% Adobe RGB; Ports: DisplayPort, 2x HDMI, USB 3.0 Hub', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Monitor'
  AND sk.nama_sub_kategori = 'Monitor'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'BenQ PD2500Q'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'ASUS ProArt PA279CV', 599, 'Resolution: 2560x1440; Panel: IPS; Refresh Rate: 60Hz; Response Time: 5ms; HDR: Yes; Price: $599; Color Gamut: 100% sRGB; Ports: DisplayPort, HDMI, USB 3.1 Hub, USB-C', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Monitor'
  AND sk.nama_sub_kategori = 'Monitor'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'ASUS ProArt PA279CV'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'LG 27GP850 (Gaming)', 399, 'Resolution: 2560x1440; Panel: IPS; Refresh Rate: 165Hz; Response Time: 1ms; HDR: Yes; Price: $399; Color Gamut: 98.5% DCI-P3; Ports: 2x DisplayPort, HDMI, USB 3.0 Hub', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Monitor'
  AND sk.nama_sub_kategori = 'Monitor'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'LG 27GP850 (Gaming)'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Samsung M7 Smart Monitor', 699, 'Resolution: 3840x2160 (4K); Panel: VA Curved; Refresh Rate: 60Hz; Response Time: 8ms; HDR: Yes; Price: $699; Features: Smart Hub, Streaming Apps; Ports: HDMI 2.1, DisplayPort, USB-C, Speakers Built-in', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Monitor'
  AND sk.nama_sub_kategori = 'Monitor'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Samsung M7 Smart Monitor'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'LG 27GP950-B', 799, 'Resolution: 3840x2160 (4K); Panel: Nano IPS; Refresh Rate: 160Hz; Response Time: 1ms; HDR: Yes (HDR600); Price: $799; Color Gamut: 98% DCI-P3; Ports: 2x DisplayPort 1.4, HDMI 2.1, USB-A Hub', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Monitor'
  AND sk.nama_sub_kategori = 'Monitor'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'LG 27GP950-B'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Samsung Odyssey G7', 599, 'Resolution: 2560x1440; Panel: VA Curved (1000R); Refresh Rate: 240Hz; Response Time: 1ms; HDR: Yes (HDR600); Price: $599; Color Gamut: 95% DCI-P3; Ports: DisplayPort 1.4, 2x HDMI 2.0, USB Hub', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Monitor'
  AND sk.nama_sub_kategori = 'Monitor'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Samsung Odyssey G7'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'ASUS ROG Swift PG32UQ', 899, 'Resolution: 3840x2160 (4K); Panel: IPS; Refresh Rate: 144Hz; Response Time: 1ms; HDR: Yes (HDR1000); Price: $899; Color Gamut: 90% DCI-P3; Ports: DisplayPort 1.4, HDMI 2.1, USB-A Hub', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Monitor'
  AND sk.nama_sub_kategori = 'Monitor'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'ASUS ROG Swift PG32UQ'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Dell U2723QE', 649, 'Resolution: 3840x2160 (4K); Panel: IPS Black; Refresh Rate: 60Hz; Response Time: 5ms; HDR: Yes; Price: $649; Color Gamut: 99% sRGB, 99% Rec. 2020; Ports: Thunderbolt 4, DisplayPort, 2x HDMI, USB Hub', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Monitor'
  AND sk.nama_sub_kategori = 'Monitor'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Dell U2723QE'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'BenQ PD2725U', 799, 'Resolution: 3840x2160 (4K); Panel: IPS; Refresh Rate: 60Hz; Response Time: 5ms; HDR: Yes (HDR10); Price: $799; Color Gamut: 99% DCI-P3; Ports: Thunderbolt 3, DisplayPort, 2x HDMI, USB-C Hub', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Monitor'
  AND sk.nama_sub_kategori = 'Monitor'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'BenQ PD2725U'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Philips 276E8VJSB', 349, 'Resolution: 3840x2160 (4K); Panel: IPS; Refresh Rate: 60Hz; Response Time: 4ms; HDR: Yes; Price: $349; Color Gamut: 107% sRGB; Ports: DisplayPort, 2x HDMI', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Monitor'
  AND sk.nama_sub_kategori = 'Monitor'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Philips 276E8VJSB'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'NZXT Starter Pro', 1199, 'Processor: Intel Core i5-13600K; RAM: 16GB DDR5; Storage: 500GB NVMe SSD; GPU: NVIDIA RTX 3060 Ti; PSU: 750W 80+ Gold; Case: NZXT H510 Flow; Price: $1,199; Performance: 1080p Ultra 60fps', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Gaming PC'
  AND sk.nama_sub_kategori = 'Gaming PC'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'NZXT Starter Pro'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Corsair Vengeance a7R', 2299, 'Processor: Intel Core i7-13700K; RAM: 32GB DDR5; Storage: 1TB NVMe SSD; GPU: NVIDIA RTX 4070; PSU: 850W 80+ Platinum; Case: Corsair Crystal Series 570X; Price: $2,299; Performance: 1440p Ultra 100+ fps', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Gaming PC'
  AND sk.nama_sub_kategori = 'Gaming PC'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Corsair Vengeance a7R'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Alienware Aurora R16', 4499, 'Processor: Intel Core i9-13900K; RAM: 32GB DDR5; Storage: 2TB NVMe SSD; GPU: NVIDIA RTX 4090; PSU: 1000W 80+ Platinum; Case: Alienware Aurora; Price: $4,499; Performance: 4K Ultra 60+ fps', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Gaming PC'
  AND sk.nama_sub_kategori = 'Gaming PC'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Alienware Aurora R16'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'MSI Trident X Plus', 2799, 'Processor: Intel Core i7-13700K; RAM: 32GB DDR5; Storage: 1TB NVMe SSD; GPU: NVIDIA RTX 4070 Ti; PSU: 850W 80+ Gold; Case: MSI Trident Compact; Price: $2,799; Performance: 1440p Ultra 120+ fps', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Gaming PC'
  AND sk.nama_sub_kategori = 'Gaming PC'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'MSI Trident X Plus'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'iBuyPower Element 240R', 1499, 'Processor: AMD Ryzen 7 7700X; RAM: 16GB DDR5; Storage: 1TB NVMe SSD; GPU: NVIDIA RTX 4070; PSU: 750W 80+ Bronze; Case: IBuyPower Custom; Price: $1,499; Performance: 1440p High 80-100 fps', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Gaming PC'
  AND sk.nama_sub_kategori = 'Gaming PC'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'iBuyPower Element 240R'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Skytech Gaming Blaze', 799, 'Processor: Intel Core i5-13600K; RAM: 16GB DDR5; Storage: 500GB NVMe SSD; GPU: NVIDIA RTX 4060; PSU: 650W 80+ Bronze; Case: Skytech Gaming Case; Price: $799; Performance: 1080p High 60+ fps', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Gaming PC'
  AND sk.nama_sub_kategori = 'Gaming PC'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Skytech Gaming Blaze'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Custom RTX 4080 Build', 3200, 'Processor: AMD Ryzen 9 7900X; RAM: 32GB DDR5 6000MHz; Storage: 2TB NVMe Gen5 SSD; GPU: NVIDIA RTX 4080; PSU: 1000W 80+ Gold; Case: Lian Li O11 Dynamic EVO; Price: $3,200; Performance: 4K Ultra 60+ fps', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Gaming PC'
  AND sk.nama_sub_kategori = 'Gaming PC'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Custom RTX 4080 Build'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'ASUS ROG Strix', 5999, 'Processor: Intel Core i9-14900K; RAM: 64GB DDR5; Storage: 2TB NVMe SSD; GPU: NVIDIA RTX 4090; PSU: 1200W 80+ Titanium; Case: ROG Hyperion; Price: $5,999; Performance: 4K Ultra 120+ fps', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Gaming PC'
  AND sk.nama_sub_kategori = 'Gaming PC'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'ASUS ROG Strix'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'MSI MEG Trident X2', 5499, 'Processor: Intel Core i9-13900K; RAM: 64GB DDR5; Storage: 2TB NVMe SSD; GPU: NVIDIA RTX 4090; PSU: 1000W 80+ Platinum; Case: MSI MEG Compact; Price: $5,499; Performance: 4K Ultra 100+ fps', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Gaming PC'
  AND sk.nama_sub_kategori = 'Gaming PC'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'MSI MEG Trident X2'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'HP OMEN 45L', 3499, 'Processor: AMD Ryzen 9 7900X; RAM: 32GB DDR5; Storage: 1TB NVMe SSD; GPU: NVIDIA RTX 4080; PSU: 850W 80+ Gold; Case: HP OMEN 45L Tower; Price: $3,499; Performance: 4K High 60+ fps', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Gaming PC'
  AND sk.nama_sub_kategori = 'Gaming PC'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'HP OMEN 45L'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Intel Core i9-14900K', 559, 'Cores: 24 (8P+16E); Threads: 32; Base Clock: 3.2 GHz (P-core); Boost Clock: 6.0 GHz; TDP: 125W (253W max); Socket: LGA 1700; Price: $559; Generation: 14th Gen Raptor Lake Refresh', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Processor'
  AND sk.nama_sub_kategori = 'Processor'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Intel Core i9-14900K'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'AMD Ryzen 9 7950X', 549, 'Cores: 16; Threads: 32; Base Clock: 4.5 GHz; Boost Clock: 5.7 GHz; TDP: 170W; Socket: AM5; Price: $549; Generation: Zen 4', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Processor'
  AND sk.nama_sub_kategori = 'Processor'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'AMD Ryzen 9 7950X'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Intel Core i7-14700K', 379, 'Cores: 20 (8P+12E); Threads: 28; Base Clock: 3.4 GHz (P-core); Boost Clock: 5.6 GHz; TDP: 125W (253W max); Socket: LGA 1700; Price: $379; Generation: 14th Gen Raptor Lake Refresh', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Processor'
  AND sk.nama_sub_kategori = 'Processor'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Intel Core i7-14700K'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'AMD Ryzen 7 7800X3D', 349, 'Cores: 8; Threads: 16; Base Clock: 4.5 GHz; Boost Clock: 5.0 GHz; TDP: 120W; Socket: AM5; Price: $349; Generation: Zen 4 + 3D V-Cache', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Processor'
  AND sk.nama_sub_kategori = 'Processor'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'AMD Ryzen 7 7800X3D'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Intel Core i5-14600K', 249, 'Cores: 14 (6P+8E); Threads: 20; Base Clock: 3.5 GHz (P-core); Boost Clock: 5.3 GHz; TDP: 125W; Socket: LGA 1700; Price: $249; Generation: 14th Gen Raptor Lake Refresh', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Processor'
  AND sk.nama_sub_kategori = 'Processor'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Intel Core i5-14600K'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'NVIDIA RTX 4090', 1599, 'VRAM: 24GB GDDR6X; CUDA Cores: 16,384; Boost Clock: 2.52 GHz; TDP: 450W; Bus: PCIe 4.0 x16; Price: $1,599; Performance: 4K Ultra 100+ fps', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Graphics Card'
  AND sk.nama_sub_kategori = 'Graphics Card'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'NVIDIA RTX 4090'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'AMD RX 7900 XTX', 999, 'VRAM: 24GB GDDR6; Stream Processors: 12,288; Boost Clock: 2.5 GHz; TDP: 355W; Bus: PCIe 4.0 x16; Price: $999; Performance: 4K High 60+ fps', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Graphics Card'
  AND sk.nama_sub_kategori = 'Graphics Card'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'AMD RX 7900 XTX'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'NVIDIA RTX 4080', 1199, 'VRAM: 16GB GDDR6X; CUDA Cores: 9,728; Boost Clock: 2.51 GHz; TDP: 320W; Bus: PCIe 4.0 x16; Price: $1,199; Performance: 4K Ultra 60+ fps', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Graphics Card'
  AND sk.nama_sub_kategori = 'Graphics Card'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'NVIDIA RTX 4080'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'AMD RX 7900 XT', 799, 'VRAM: 20GB GDDR6; Stream Processors: 10,752; Boost Clock: 2.394 GHz; TDP: 315W; Bus: PCIe 4.0 x16; Price: $799; Performance: 4K Medium/High 60fps', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Graphics Card'
  AND sk.nama_sub_kategori = 'Graphics Card'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'AMD RX 7900 XT'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'NVIDIA RTX 4070 Ti', 799, 'VRAM: 12GB GDDR6X; CUDA Cores: 7,680; Boost Clock: 2.61 GHz; TDP: 285W; Bus: PCIe 4.0 x16; Price: $799; Performance: 1440p Ultra 100+ fps', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Graphics Card'
  AND sk.nama_sub_kategori = 'Graphics Card'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'NVIDIA RTX 4070 Ti'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Nike Air Max', 150, 'Type: Running / Lifestyle; Upper: Mesh + Leather overlays; Sole: Air Max cushioning unit; Fit: True to size; Price: $150; Best For: Running, casual wear', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Shoes'
  AND sk.nama_sub_kategori = 'Shoes'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Nike Air Max'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Adidas Ultraboost', 190, 'Type: Running; Upper: Primeknit+; Sole: Boost midsole; Fit: True to size; Price: $190; Best For: Long-distance running', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Shoes'
  AND sk.nama_sub_kategori = 'Shoes'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Adidas Ultraboost'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'New Balance 574', 85, 'Type: Lifestyle; Upper: Suede + Mesh; Sole: ENCAP midsole; Fit: True to size; Price: $85; Best For: Casual everyday wear', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Shoes'
  AND sk.nama_sub_kategori = 'Shoes'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'New Balance 574'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Converse Chuck Taylor', 65, 'Type: Lifestyle; Upper: Canvas; Sole: Vulcanized rubber; Fit: Runs half size large; Price: $65; Best For: Casual, fashion', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Shoes'
  AND sk.nama_sub_kategori = 'Shoes'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Converse Chuck Taylor'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Vans Old Skool', 70, 'Type: Skate / Lifestyle; Upper: Canvas + Suede; Sole: Waffle outsole; Fit: True to size; Price: $70; Best For: Skate, casual', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Shoes'
  AND sk.nama_sub_kategori = 'Shoes'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Vans Old Skool'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Puma RS-X', 110, 'Type: Lifestyle; Upper: Mesh + Leather; Sole: Running System technology; Fit: True to size; Price: $110; Best For: Retro-style casual', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Shoes'
  AND sk.nama_sub_kategori = 'Shoes'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Puma RS-X'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Reebok Classic', 80, 'Type: Lifestyle; Upper: Leather; Sole: EVA foam; Fit: True to size; Price: $80; Best For: Classic fashion, casual', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Shoes'
  AND sk.nama_sub_kategori = 'Shoes'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Reebok Classic'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Louis Vuitton Neverfull', 1550, 'Type: Tote Bag; Material: Monogram Canvas; Capacity: Medium / Large; Origin: France; Price: $1,550; Best For: Daily luxury use', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Bags'
  AND sk.nama_sub_kategori = 'Bags'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Louis Vuitton Neverfull'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Gucci Ophidia', 1180, 'Type: Shoulder Bag; Material: GG Supreme Canvas; Capacity: Medium; Origin: Italy; Price: $1,180; Best For: Daily fashion', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Bags'
  AND sk.nama_sub_kategori = 'Bags'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Gucci Ophidia'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Michael Kors Jet Set', 278, 'Type: Crossbody / Tote; Material: Saffiano Leather; Capacity: Medium; Origin: USA; Price: $278; Best For: Professional, daily', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Bags'
  AND sk.nama_sub_kategori = 'Bags'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Michael Kors Jet Set'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Coach Tabby', 350, 'Type: Shoulder Bag; Material: Pebble Leather; Capacity: Small / Medium; Origin: USA; Price: $350; Best For: Casual to semi-formal', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Bags'
  AND sk.nama_sub_kategori = 'Bags'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Coach Tabby'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Tumi Alpha 3', 595, 'Type: Business Backpack; Material: Ballistic Nylon; Capacity: 26L; Origin: USA; Price: $595; Best For: Business travel', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Bags'
  AND sk.nama_sub_kategori = 'Bags'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Tumi Alpha 3'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Samsonite Winfield', 169, 'Type: Hardshell Luggage; Material: Polycarbonate; Capacity: 50L (carry-on); Origin: USA; Price: $169; Best For: Travel', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Bags'
  AND sk.nama_sub_kategori = 'Bags'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Samsonite Winfield'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Eiger Adventure', 450000, 'Type: Backpack; Material: Nylon 600D; Capacity: 30L; Origin: Indonesia; Price: Rp 450,000; Best For: Outdoor / hiking', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Bags'
  AND sk.nama_sub_kategori = 'Bags'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Eiger Adventure'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Zara Midi Dress', 69, 'Style: Midi A-line; Material: Viscose blend; Fit: Regular; Price: $69; Best For: Office, casual', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Dress'
  AND sk.nama_sub_kategori = 'Dress'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Zara Midi Dress'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'H&M Wrap Dress', 35, 'Style: Wrap; Material: Woven fabric; Fit: Regular; Price: $35; Best For: Casual, date night', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Dress'
  AND sk.nama_sub_kategori = 'Dress'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'H&M Wrap Dress'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Mango Floral Dress', 79, 'Style: Floral midi; Material: Satin; Fit: Slim; Price: $79; Best For: Parties, summer', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Dress'
  AND sk.nama_sub_kategori = 'Dress'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Mango Floral Dress'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'ASOS Bodycon', 45, 'Style: Bodycon mini; Material: Jersey; Fit: Bodycon; Price: $45; Best For: Parties, nights out', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Dress'
  AND sk.nama_sub_kategori = 'Dress'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'ASOS Bodycon'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Uniqlo Linen Dress', 49, 'Style: Linen shift; Material: 100% Linen; Fit: Relaxed; Price: $49; Best For: Summer, casual', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Dress'
  AND sk.nama_sub_kategori = 'Dress'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Uniqlo Linen Dress'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Pandora Charm Bracelet', 65, 'Type: Bracelet; Material: Sterling Silver; Style: Charm; Origin: Denmark; Price: $65; Best For: Gift, everyday wear', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Jewelry'
  AND sk.nama_sub_kategori = 'Jewelry'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Pandora Charm Bracelet'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Swarovski Crystal Necklace', 85, 'Type: Necklace; Material: Rhodium-plated + Crystal; Style: Pendant; Origin: Austria; Price: $85; Best For: Special occasions', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Jewelry'
  AND sk.nama_sub_kategori = 'Jewelry'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Swarovski Crystal Necklace'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Tiffany & Co Open Heart', 250, 'Type: Necklace; Material: Sterling Silver / 18K Gold; Style: Heart pendant; Origin: USA; Price: $250; Best For: Romantic gift, luxury', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Jewelry'
  AND sk.nama_sub_kategori = 'Jewelry'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Tiffany & Co Open Heart'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Michael Kors Watch', 250, 'Type: Watch; Material: Stainless steel; Style: Chronograph; Origin: USA; Price: $250; Best For: Professional, fashion', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Jewelry'
  AND sk.nama_sub_kategori = 'Jewelry'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Michael Kors Watch'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Fossil Gen 6', 299, 'Type: Smartwatch; Material: Stainless steel; Style: Hybrid smart; OS: Wear OS; Price: $299; Best For: Tech + fashion', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Jewelry'
  AND sk.nama_sub_kategori = 'Jewelry'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Fossil Gen 6'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Casio G-Shock', 130, 'Type: Watch; Material: Resin + Stainless steel; Style: Sport; Origin: Japan; Price: $130; Best For: Outdoor, sport', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Jewelry'
  AND sk.nama_sub_kategori = 'Jewelry'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Casio G-Shock'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Ray-Ban Wayfarer', 175, 'Type: Sunglasses; Frame: Acetate; Lens: G-15 glass; UV Protection: 100% UV400; Price: $175; Best For: Classic fashion', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Accessories'
  AND sk.nama_sub_kategori = 'Accessories'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Ray-Ban Wayfarer'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Oakley Holbrook', 165, 'Type: Sunglasses; Frame: O-Matter; Lens: Plutonite; UV Protection: 100% UV; Price: $165; Best For: Sport, outdoor', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Accessories'
  AND sk.nama_sub_kategori = 'Accessories'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Oakley Holbrook'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Gucci Belt', 440, 'Type: Belt; Material: Leather; Buckle: Gold-tone GG interlocking; Width: 3.8cm; Price: $440; Best For: Luxury fashion', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Accessories'
  AND sk.nama_sub_kategori = 'Accessories'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Gucci Belt'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Hermès Scarf', 430, 'Type: Scarf; Material: Twill Silk; Size: 90x90cm; Origin: France; Price: $430; Best For: Luxury fashion', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Accessories'
  AND sk.nama_sub_kategori = 'Accessories'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Hermès Scarf'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Coach Lanyard', 65, 'Type: Lanyard / Keychain; Material: Leather; Style: Logo; Origin: USA; Price: $65; Best For: Daily accessory', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Accessories'
  AND sk.nama_sub_kategori = 'Accessories'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Coach Lanyard'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'The North Face Thermoball', 220, 'Type: Insulated Jacket; Fill: ThermoBall Eco synthetic; Warmth: Medium; Water Resistance: DWR coating; Price: $220; Best For: Cold weather, travel', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Outerwear'
  AND sk.nama_sub_kategori = 'Outerwear'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'The North Face Thermoball'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Uniqlo Ultra Light Down', 90, 'Type: Down Jacket; Fill: 90% Down, 10% Feather; Warmth: Medium; Water Resistance: Yes; Price: $90; Best For: Travel, lightweight warmth', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Outerwear'
  AND sk.nama_sub_kategori = 'Outerwear'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Uniqlo Ultra Light Down'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Patagonia Nano Puff', 299, 'Type: Insulated Jacket; Fill: PrimaLoft Gold synthetic; Warmth: Medium-High; Water Resistance: H2No performance; Price: $299; Best For: Outdoor, sustainability', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Outerwear'
  AND sk.nama_sub_kategori = 'Outerwear'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Patagonia Nano Puff'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Columbia Sportswear Jacket', 120, 'Type: Fleece / Shell Jacket; Material: Polyester fleece; Warmth: Low-Medium; Water Resistance: Omni-Shield; Price: $120; Best For: Outdoor, hiking', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Outerwear'
  AND sk.nama_sub_kategori = 'Outerwear'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Columbia Sportswear Jacket'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Zara Puffer Jacket', 89, 'Type: Puffer Jacket; Fill: Synthetic; Warmth: Medium; Water Resistance: Basic; Price: $89; Best For: Casual fashion', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Outerwear'
  AND sk.nama_sub_kategori = 'Outerwear'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Zara Puffer Jacket'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Coursera ML Specialization', 49, 'Provider: Coursera / DeepLearning.AI; Instructor: Andrew Ng; Duration: 3 months; Level: Beginner to Intermediate; Price: $49/month; Certificate: Yes', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Online Course'
  AND sk.nama_sub_kategori = 'Course'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Coursera ML Specialization'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Udemy Web Development Bootcamp', 15, 'Provider: Udemy; Instructor: Angela Yu; Duration: 65+ hours; Level: Beginner; Price: $15 (on sale); Certificate: Yes', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Online Course'
  AND sk.nama_sub_kategori = 'Course'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Udemy Web Development Bootcamp'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Coursera Google Data Analytics', 49, 'Provider: Coursera / Google; Instructor: Google Staff; Duration: 6 months; Level: Beginner; Price: $49/month; Certificate: Yes (Google)', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Online Course'
  AND sk.nama_sub_kategori = 'Course'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Coursera Google Data Analytics'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'edX MIT MicroMasters', 1500, 'Provider: edX / MIT; Instructor: MIT Faculty; Duration: 9-12 months; Level: Advanced; Price: $1,500 - $5,000; Certificate: MicroMasters credential', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Online Course'
  AND sk.nama_sub_kategori = 'Course'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'edX MIT MicroMasters'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Dicoding Flutter Developer', 750000, 'Provider: Dicoding; Language: Bahasa Indonesia; Duration: 30-60 hours; Level: Beginner to Intermediate; Price: Rp 750,000; Certificate: Yes (Industry recognized ID)', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Online Course'
  AND sk.nama_sub_kategori = 'Course'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Dicoding Flutter Developer'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Bangkit Academy', NULL, 'Provider: Google, Tokopedia, Gojek, Traveloka; Language: Bahasa Indonesia + English; Duration: 6 months; Level: Intermediate; Price: Free (selective); Certificate: Yes', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Online Course'
  AND sk.nama_sub_kategori = 'Course'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Bangkit Academy'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Udacity Nanodegree', 399, 'Provider: Udacity; Tracks: Data Science, ML, Android, etc.; Duration: 3-6 months; Level: Intermediate to Advanced; Price: $399/month; Certificate: Yes', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Online Course'
  AND sk.nama_sub_kategori = 'Course'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Udacity Nanodegree'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'AWS Solutions Architect', NULL, 'Provider: Amazon Web Services; Level: Associate / Professional; Duration: 3-6 months study; Exam Fee: $150 - $300; Validity: 3 years; Best For: Cloud architects', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Certification'
  AND sk.nama_sub_kategori = 'Certification'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'AWS Solutions Architect'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Google Cloud Professional', NULL, 'Provider: Google Cloud; Level: Professional; Duration: 3-6 months study; Exam Fee: $200; Validity: 2 years; Best For: Cloud engineers', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Certification'
  AND sk.nama_sub_kategori = 'Certification'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Google Cloud Professional'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Microsoft Azure AZ-900', NULL, 'Provider: Microsoft; Level: Fundamentals; Duration: 1-2 months study; Exam Fee: $165; Validity: Lifetime; Best For: Cloud beginners', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Certification'
  AND sk.nama_sub_kategori = 'Certification'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Microsoft Azure AZ-900'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'CompTIA Security+', NULL, 'Provider: CompTIA; Level: Entry-level security; Duration: 2-3 months study; Exam Fee: $404; Validity: 3 years; Best For: Cybersecurity beginners', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Certification'
  AND sk.nama_sub_kategori = 'Certification'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'CompTIA Security+'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Cisco CCNA', NULL, 'Provider: Cisco; Level: Associate; Duration: 3-6 months study; Exam Fee: $330; Validity: 3 years; Best For: Network engineers', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Certification'
  AND sk.nama_sub_kategori = 'Certification'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Cisco CCNA'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'PMI PMP', NULL, 'Provider: PMI; Level: Professional; Duration: 3-6 months study; Exam Fee: $405 (member) / $555; Validity: 3 years; Best For: Project managers', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Certification'
  AND sk.nama_sub_kategori = 'Certification'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'PMI PMP'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Hacktiv8', 25000, 'Location: Indonesia (Online + Offline); Tracks: Full Stack JS, Data Science; Duration: 12 weeks; Price: Rp 25,000,000; ISA: Available; Best For: Career switchers ID', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Bootcamp'
  AND sk.nama_sub_kategori = 'Bootcamp'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Hacktiv8'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Purwadhika', 20000, 'Location: Indonesia; Tracks: Digital Talent, Data Science; Duration: 3-6 months; Price: Rp 20,000,000 - 35,000,000; ISA: Available; Best For: Career switchers ID', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Bootcamp'
  AND sk.nama_sub_kategori = 'Bootcamp'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Purwadhika'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'RevoU', 18000, 'Location: Indonesia (Online); Tracks: Software Engineering, Data Analytics; Duration: 16 weeks; Price: Rp 18,000,000 or ISA; ISA: Available; Best For: Entry-level tech ID', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Bootcamp'
  AND sk.nama_sub_kategori = 'Bootcamp'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'RevoU'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'General Assembly', 14950, 'Location: Global (Online + Offline); Tracks: Software Engineering, Data Science, UX; Duration: 12 weeks; Price: $14,950; ISA: Available; Best For: Career changers global', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Bootcamp'
  AND sk.nama_sub_kategori = 'Bootcamp'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'General Assembly'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Le Wagon', 8000, 'Location: Global (40+ cities); Tracks: Web Development, Data Science; Duration: 9 weeks; Price: $8,000 - $12,000; ISA: No; Best For: Startup founders, career switchers', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Bootcamp'
  AND sk.nama_sub_kategori = 'Bootcamp'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Le Wagon'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Ironhack', 8500, 'Location: Global (Online + Offline); Tracks: Web Dev, UX/UI, Data Analytics, Cybersecurity; Duration: 9-24 weeks; Price: $8,500 - $14,000; ISA: Available; Best For: Career switchers global', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Bootcamp'
  AND sk.nama_sub_kategori = 'Bootcamp'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Ironhack'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Universitas Indonesia (UI)', NULL, 'Location: Depok, Indonesia; Ranking: #1 Indonesia (QS 2024); Type: Public; Tuition: Rp 0 - 10,000,000/semester; Notable Programs: Medical, Law, Engineering; Best For: Top Indonesian students', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'University'
  AND sk.nama_sub_kategori = 'University'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Universitas Indonesia (UI)'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Institut Teknologi Bandung (ITB)', NULL, 'Location: Bandung, Indonesia; Ranking: #2 Indonesia (QS 2024); Type: Public; Tuition: Rp 0 - 12,500,000/semester; Notable Programs: Engineering, Architecture, Design; Best For: STEM students ID', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'University'
  AND sk.nama_sub_kategori = 'University'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Institut Teknologi Bandung (ITB)'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Universitas Gadjah Mada (UGM)', NULL, 'Location: Yogyakarta, Indonesia; Ranking: #3 Indonesia (QS 2024); Type: Public; Tuition: Rp 0 - 10,000,000/semester; Notable Programs: Medicine, Agriculture, Social Sciences; Best For: Wide program selection', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'University'
  AND sk.nama_sub_kategori = 'University'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Universitas Gadjah Mada (UGM)'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Institut Teknologi Sepuluh Nopember (ITS)', NULL, 'Location: Surabaya, Indonesia; Ranking: Top 5 Indonesia; Type: Public; Tuition: Rp 0 - 9,000,000/semester; Notable Programs: Marine Engineering, Informatics; Best For: Engineering East Java', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'University'
  AND sk.nama_sub_kategori = 'University'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Institut Teknologi Sepuluh Nopember (ITS)'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Universitas Bina Nusantara (Binus)', NULL, 'Location: Jakarta, Indonesia; Ranking: Top 10 Indonesia; Type: Private; Tuition: Rp 15,000,000 - 22,000,000/semester; Notable Programs: Computer Science, Business, Animation; Best For: Tech & business careers', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'University'
  AND sk.nama_sub_kategori = 'University'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Universitas Bina Nusantara (Binus)'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Prasetiya Mulya', NULL, 'Location: Tangerang, Indonesia; Ranking: Top Business School ID; Type: Private; Tuition: Rp 35,000,000 - 45,000,000/semester; Notable Programs: Business, Entrepreneurship; Best For: Business & startup founders', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'University'
  AND sk.nama_sub_kategori = 'University'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Prasetiya Mulya'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Harvard Online', NULL, 'Location: USA (Online); Ranking: #1 World (multiple rankings); Type: Private; Tuition: $50,000+/year (residential); Notable Programs: Business, Law, Medicine, CS; Best For: World-class education', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'University'
  AND sk.nama_sub_kategori = 'University'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Harvard Online'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'MIT (Massachusetts Institute of Technology)', NULL, 'Location: Cambridge, USA; Ranking: #1 Engineering World; Type: Private; Tuition: $55,000+/year; Notable Programs: Engineering, CS, Physics; Best For: STEM research & innovation', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'University'
  AND sk.nama_sub_kategori = 'University'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'MIT (Massachusetts Institute of Technology)'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Stanford Online', NULL, 'Location: California, USA (Online courses); Ranking: Top 5 World; Type: Private; Tuition: $55,000+/year (residential); Notable Programs: CS, AI, Business, Medicine; Best For: Tech innovation, Silicon Valley', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'University'
  AND sk.nama_sub_kategori = 'University'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Stanford Online'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'LinkedIn Learning Premium', 39.99, 'Provider: LinkedIn / Microsoft; Format: Video + Quiz; Catalog: 20,000+ courses; Price: $39.99/month; Certificate: Yes (LinkedIn); Best For: Professional development', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Training Program'
  AND sk.nama_sub_kategori = 'Training Program'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'LinkedIn Learning Premium'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Pluralsight', 29, 'Provider: Pluralsight; Format: Video + Labs; Catalog: 7,000+ courses; Price: $29 - $45/month; Certificate: Yes + Skill assessments; Best For: IT, DevOps, software engineers', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Training Program'
  AND sk.nama_sub_kategori = 'Training Program'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Pluralsight'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'O''Reilly Learning', 499, 'Provider: O''Reilly Media; Format: Books, Videos, Live events; Catalog: 60,000+ resources; Price: $499/year; Certificate: Yes; Best For: Software engineers, architects', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Training Program'
  AND sk.nama_sub_kategori = 'Training Program'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'O''Reilly Learning'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Skill Academy', 300000, 'Provider: Skill Academy (Ruangguru); Format: Video + Mentoring; Language: Bahasa Indonesia; Price: Rp 300,000 - 1,500,000; Certificate: Yes; Best For: Indonesian learners', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Training Program'
  AND sk.nama_sub_kategori = 'Training Program'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Skill Academy'
  );
INSERT INTO public.pilihan_katalog (id_sub_kategori, nama_pilihan, harga, spesifikasi, rating)
SELECT sk.id_sub_kategori, 'Tokopedia Academy', NULL, 'Provider: Tokopedia; Format: Online training + mentoring; Language: Bahasa Indonesia; Price: Free; Certificate: Yes; Best For: E-commerce & digital skills ID', NULL
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
WHERE k.nama_kategori = 'Training Program'
  AND sk.nama_sub_kategori = 'Training Program'
  AND NOT EXISTS (
    SELECT 1 FROM public.pilihan_katalog pk
    WHERE pk.id_sub_kategori = sk.id_sub_kategori
      AND pk.nama_pilihan = 'Tokopedia Academy'
  );

-- 4. Verifikasi hasil
SELECT k.nama_kategori, sk.nama_sub_kategori, COUNT(pk.id_pilihan_katalog) AS jumlah_barang
FROM public.sub_kategori sk
JOIN public.kategori k ON k.id_kategori = sk.id_kategori
LEFT JOIN public.pilihan_katalog pk ON pk.id_sub_kategori = sk.id_sub_kategori
GROUP BY k.nama_kategori, sk.nama_sub_kategori
ORDER BY k.nama_kategori, sk.nama_sub_kategori;
