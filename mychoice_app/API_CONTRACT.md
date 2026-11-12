# Dokumentasi Kontrak API MyChoice

Dokumen ini mendefinisikan kontrak antarmuka antara frontend Flutter dan backend Supabase (PostgreSQL + Auth + REST/Realtime). Semua endpoint diakses melalui Supabase client (`supabase_flutter`) dengan header `Authorization: Bearer <access_token>` yang dikelola otomatis oleh SDK.

Base URL: `https://<project-ref>.supabase.co/rest/v1`

---

## 1. Authentication API (Auth)

Digunakan untuk login, register, dan manajemen sesi. Digengapi oleh Supabase Auth, tidak perlu menulis endpoint custom kecuali tabel `public.pengguna` untuk profil/role.

| # | Endpoint | Method | Deskripsi | Akses |
|---|----------|--------|-----------|-------|
| 1.1 | `/auth/v1/token?grant_type=password` | POST | Login email + password | Public |
| 1.2 | `/auth/v1/signup` | POST | Register akun baru | Public |
| 1.3 | `/auth/v1/logout` | POST | Keluar sesi saat ini | Authenticated |
| 1.4 | `/auth/v1/user` | GET | Ambil data user login saat ini | Authenticated |
| 1.5 | `/auth/v1/reset` (recovery OTP) | POST | Minta kode reset password via email | Public |
| 1.6 | `/auth/v1/otp` (type=recovery) | POST | Verifikasi kode OTP reset | Public |
| 1.7 | `/rest/v1/pengguna` | GET | Ambil profil & role user | Authenticated |
| 1.8 | `/rest/v1/pengguna` | PATCH | Update nama pengguna sendiri | Authenticated (own row) |

### 1.1 Login (POST /auth/v1/token?grant_type=password)

**Request body** (`application/json`):
```json
{
  "email": "user@example.com",
  "password": "string"
}
```

**Response success (200)**:
```json
{
  "access_token": "eyJhbG...",
  "refresh_token": "def502...",
  "expires_in": 3600,
  "token_type": "bearer",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "email_confirmed_at": null,
    "created_at": "2026-10-01T00:00:00Z"
  }
}
```

**Response error**:
| Status | Kondisi | Body contoh |
|--------|---------|-------------|
| 400 | Email/password kosong atau format salah | `{"error": "validation failed", "message": "..."}` |
| 400 | Kredensial salah | `{"error": "Invalid login credentials", ...}` |
| 429 | Terlalu banyak percobaan | `{"error": "Too many requests", ...}` |

---

## 2. Catalog API (Katalog Alternatif)

Digunakan untuk menampilkan daftar kategori, subkategori, dan opsi alternatif yang dapat dibandingkan dalam pengambilan keputusan. Data sumber saat ini adalah aset JSON lokal (`assets/data/alternatives_catalog.json`) yang di-layani melalui layanan API agar siap dipindahkan ke tabel Supabase di masa depan.

| # | Endpoint | Method | Deskripsi | Akses |
|---|----------|--------|-----------|-------|
| 2.1 | `/api/catalog/categories` | GET | Daftar semua kategori | Public |
| 2.2 | `/api/catalog/categories/{category}` | GET | Detail satu kategori | Public |
| 2.3 | `/api/catalog/categories/{category}/subcategories` | GET | Daftar subkategori dalam kategori | Public |
| 2.4 | `/api/catalog/subcategories/{subcategory}/alternatives` | GET | Daftar alternatif opsi dalam subkategori | Public |

### 2.1 List Categories (GET /api/catalog/categories)

**Query parameter**: none

**Response success (200)**:
```json
{
  "categories": [
    {
      "name": "Technology",
      "icon": "laptop",
      "subcategories": 7,
      "criteria": 23
    },
    {
      "name": "Education",
      "icon": "school",
      "subcategories": 5,
      "criteria": 11
    },
    {
      "name": "Fashion",
      "icon": "checkroom",
      "subcategories": 5,
      "criteria": 19
    }
  ]
}
```

### 2.4 List Alternatives (GET /api/catalog/subcategories/{subcategory}/alternatives)

**Path parameter**: `subcategory` (misal: `Laptop`, `Smartphone`, `Course`)

**Response success (200)**:
```json
{
  "subcategory": "Laptop",
  "alternatives": [
    {
      "name": "Apple MacBook Pro 14\" (M3 Pro)",
      "specs": {
        "Price": "High",
        "RAM": "18 GB",
        "Storage": "512 GB SSD",
        "Processor": "Apple M3 Pro",
        "Battery": "18 hours",
        "Weight": "1.6 kg"
      }
    }
  ]
}
```

**Response error**:
| Status | Kondisi |
|--------|---------|
| 404 | Subkategori tidak ditemukan |
| 500 | Gagal memuat data katalog |

---

## 3. Decision API (Buat & Simpan Keputusan)

Digunakan untuk menyimpan hasil keputusan pengguna ke riwayat agar dapat dilihat kembali di layar History.

| # | Endpoint | Method | Deskripsi | Akses |
|---|----------|--------|-----------|-------|
| 3.1 | `/rest/v1/decision_histories` | POST | Simpan keputusan baru ke riwayat | Authenticated |
| 3.2 | `/rest/v1/decision_histories` | GET | Daftar riwayat keputusan sendiri | Authenticated |
| 3.3 | `/rest/v1/decision_histories/{id}` | GET | Detail satu riwayat keputusan | Authenticated (owner) |
| 3.4 | `/rest/v1/decision_histories/{id}` | PATCH | Perbarui riwayat (review + rating) | Authenticated (owner) |
| 3.5 | `/rest/v1/decision_histories/{id}` | DELETE | Hapus riwayat keputusan | Authenticated (owner) |

### 3.1 Create Decision History (POST /rest/v1/decision_histories)

**Headers**: `Authorization: Bearer <access_token>`, `apikey: <anon_key>`, `Content-Type: application/json`, `Prefer: return=representation`

**Request body**:
```json
{
  "user_id": "uuid",
  "category": "Technology",
  "subcategory": "Laptop",
  "title": "Lenovo IdeaPad Slim 5",
  "score": 0.89,
  "final_option": "Lenovo IdeaPad Slim 5",
  "decision_date": "2026-10-03T00:00:00Z",
  "priorities": {"Price": 30, "Performance": 35, "Battery": 20, "Storage": 15}
}
```

**Parameter**:
| Nama | Tipe | Wajib | Deskripsi |
|------|------|-------|-----------|
| user_id | uuid | Ya | ID user yang login (diisi otomatis via `auth.uid()`) |
| category | text | Ya | Kategori keputusan |
| subcategory | text | Tidak | Subkategori |
| title | text | Ya | Nama opsi terpilih / judul keputusan |
| score | float8 | Ya | Skor akhir (0.0 - 1.0) |
| final_option | text | Tidak | Opsi terbaik yang dipilih |
| decision_date | timestamptz | Tidak | Tanggal keputusan dibuat |
| priorities | jsonb | Tidak | Bobot kriteria dalam persen |

**Response success (201)**:
```json
{
  "id": "uuid",
  "user_id": "uuid",
  "category": "Technology",
  "subcategory": "Laptop",
  "title": "Lenovo IdeaPad Slim 5",
  "score": 0.89,
  "final_option": "Lenovo IdeaPad Slim 5",
  "decision_date": "2026-10-03T00:00:00Z",
  "created_at": "2026-10-10T08:00:00Z",
  "updated_at": "2026-10-10T08:00:00Z"
}
```

**Response error**:
| Status | Kondisi |
|--------|---------|
| 401 | Tidak terautentikasi / token kadaluarsa |
| 400 | Field wajib kosong atau score di luar rentang |
| 403 | Tidak diizinkan (RLS) |

---

## 4. Decision History API (Baca Riwayat & Ulasan)

Digunakan untuk membaca daftar riwayat dan detailnya, termasuk ulasan dan bintang rating yang diinput user sendiri.

### 4.1 List History (GET /rest/v1/decision_histories)

**Headers**: `Authorization: Bearer <access_token>`

**Query parameter** (opsional):
| Nama | Tipe | Deskripsi |
|------|------|-----------|
| select | string | Kolom yang ingin diambil (default `*`) |
| order | string | Urutan, misal `created_at.desc` |
| limit | integer | Batas jumlah data |
| offset | integer | Offset pagination |
| user_id | uuid | Filter milik user (RLS tetap diterapkan) |

**Response success (200)**:
```json
[
  {
    "id": "uuid",
    "category": "Technology",
    "title": "Lenovo IdeaPad Slim 5",
    "score": 0.89,
    "date_group": "Today",
    "decision_date": "2026-10-03T00:00:00Z",
    "created_at": "2026-10-10T08:00:00Z",
    "rating": 4,
    "review": "Sangat puas dengan pilihan ini."
  }
]
```

> Kolom `rating` dan `review` diambil melalui join dengan tabel `decision_history_reviews` (lihat bagian 4.3).

### 4.2 Detail History (GET /rest/v1/decision_histories?id=eq.<id>)

**Path parameter**: `id` (uuid)

**Response success (200)**: satu objek decision history lengkap dengan prioritas dan ulasan.

**Response error**:
| Status | Kondisi |
|--------|---------|
| 404 | Riwayat tidak ditemukan atau bukan milik user |

### 4.3 Ulasan & Bintang Rating (PATCH /rest/v1/decision_histories/{id})

User dapat menginput **bintang rating (1-5)** dan teks ulasan pada riwayat keputusan yang miliknya.

**Request body**:
```json
{
  "rating": 4,
  "review": "Keputusan tepat, laptopnya sesuai kebutuhan."
}
```

**Parameter**:
| Nama | Tipe | Wajib | Deskripsi | Validasi |
|------|------|-------|-----------|----------|
| rating | smallint | Ya | Bintang rating dari user | 1 s/d 5 |
| review | text | Tidak | Teks ulasan bebas | Maksimal 1000 karakter |

**Response success (200)**:
```json
{
  "id": "uuid",
  "decision_history_id": "uuid",
  "user_id": "uuid",
  "rating": 4,
  "review": "Keputusan tepat, laptopnya sesuai kebutuhan.",
  "updated_at": "2026-10-10T08:30:00Z"
}
```

**Response error**:
| Status | Kondisi |
|--------|---------|
| 400 | Rating di luar rentang 1-5 |
| 401 | Tidak terautentikasi |
| 403 | Tidak boleh mengulas riwayat orang lain |
| 404 | Riwayat tidak ditemukan |

---

## 5. Status Code Ringkasan

| Kode | Arti | Digunakan untuk |
|------|------|-----------------|
| 200 | OK | GET, PATCH berhasil |
| 201 | Created | POST berhasil membuat data baru |
| 204 | No Content | DELETE berhasil |
| 400 | Bad Request | Validasi input gagal |
| 401 | Unauthorized | Token hilang/kadaluarsa |
| 403 | Forbidden | RLS menolak akses (bukan milik user) |
| 404 | Not Found | Data tidak ditemukan |
| 429 | Too Many Requests | Rate limit (Auth) |
| 500 | Internal Server Error | Kesalahan server/database |

---

## 6. Keamanan (RLS)

Semua tabel riwayat dan ulasan diaktifkan **Row Level Security (RLS)**:
- User hanya dapat membaca, membuat, memperbarui, dan menghapus baris miliknya sendiri (`user_id = auth.uid()`).
- Tidak ada user yang dapat mengakses riwayat atau ulasan milik user lain.
- Publishable key (anon key) digunakan di aplikasi client; `service_role` key **tidak pernah** disimpan di kode Flutter.

---

## 7. File Implementasi Terkait

- `supabase/migrations/20261110000000_decision_history.sql` — skema & RLS riwayat keputusan
- `lib/features/decision_history/domain/entities/decision_history.dart` — entitas domain
- `lib/features/decision_history/domain/repositories/decision_history_repository.dart` — antarmuka repository
- `lib/features/decision_history/data/models/decision_history_model.dart` — model data
- `lib/features/decision_history/data/repositories/supabase_decision_history_repository.dart` — implementasi Supabase
- `lib/features/catalog/data/repositories/catalog_api_service.dart` — layanan katalog
- `lib/screens/user/history/history_screen.dart` — UI daftar riwayat (terhubung API)
- `lib/screens/user/history/history_detail_screen.dart` — UI detail + input bintang rating

---

## 8. User Profile & Account Management API

Digunakan untuk mengelola profil pengguna, role (user/admin), dan plan langganan (basic/premium).

| # | Endpoint | Method | Deskripsi | Akses |
|---|----------|--------|-----------|-------|
| 8.1 | `/rest/v1/pengguna` | GET | Ambil profil lengkap pengguna login | Authenticated (own row) |
| 8.2 | `/rest/v1/pengguna` | PATCH | Update nama pengguna sendiri | Authenticated (own row) |
| 8.3 | `/rpc/get_user_profile` | POST (RPC) | Ambil profil lengkap via fungsi database | Authenticated |
| 8.4 | `/rest/v1/pengguna` | PATCH (admin) | Update role dan plan pengguna (admin only) | Admin only |
| 8.5 | `/rpc/is_admin_user` | POST (RPC) | Cek apakah pengguna adalah admin | Authenticated |
| 8.6 | `/rpc/is_premium_user` | POST (RPC) | Cek apakah pengguna memiliki plan premium | Authenticated |

### 8.1 Get User Profile (GET /rest/v1/pengguna)

**Headers**: `Authorization: Bearer <access_token>`

**Query parameter**:
| Nama | Tipe | Deskripsi |
|------|------|-----------|
| id_pengguna | uuid | ID user (RLS membatasi ke own row atau admin) |

**Response success (200)**:
```json
[
  {
    "id_pengguna": "uuid",
    "nama": "Budi Santoso",
    "email": "budi@example.com",
    "role": "user",
    "plan": "basic",
    "tanggal_dibuat": "2026-10-01T00:00:00Z"
  }
]
```

**Response error**:
| Status | Kondisi |
|--------|---------|
| 401 | Tidak terautentikasi |
| 403 | Tidak diizinkan melihat profil orang lain (bukan admin) |

### 8.2 Update User Profile (PATCH /rest/v1/pengguna)

**Headers**: `Authorization: Bearer <access_token>`, `Prefer: return=representation`

**Request body**:
```json
{
  "nama": "Budi Santoso Updated"
}
```

**Parameter**:
| Nama | Tipe | Wajib | Deskripsi |
|------|------|-------|-----------|
| nama | text | Tidak | Nama lengkap pengguna |

**Response success (200)**: objek pengguna yang diperbarui

**Response error**:
| Status | Kondisi |
|--------|---------|
| 400 | Field tidak valid |
| 401 | Tidak terautentikasi |
| 403 | Tidak diizinkan (bukan milik user) |

### 8.4 Update Role & Plan by Admin (PATCH /rest/v1/pengguna)

Hanya dapat diakses oleh role `admin`. Digunakan untuk mempromosikan user ke admin atau mengubah plan basic/premium.

**Request body**:
```json
{
  "role": "admin",
  "plan": "premium"
}
```

**Parameter**:
| Nama | Tipe | Wajib | Deskripsi | Validasi |
|------|------|-------|-----------|----------|
| role | text | Tidak | Role pengguna | `user` atau `admin` |
| plan | text | Tidak | Plan langganan | `basic` atau `premium` |

**Response error**:
| Status | Kondisi |
|--------|---------|
| 403 | Akses ditolak (bukan admin) |

### 8.5 Check Admin Status (POST /rpc/is_admin_user)

**Response success (200)**: `true` atau `false`

### 8.6 Check Premium Status (POST /rpc/is_premium_user)

**Response success (200)**: `true` atau `false`

---

## 9. Role & Plan Access Control

| Role | Plan | Akses Dashboard | Fitur Khusus |
|------|------|-----------------|--------------|
| user | basic | Dashboard User | Maksimal 3 opsi keputusan |
| user | premium | Dashboard User | Maksimal 10 opsi keputusan, fitur premium |
| admin | any | Dashboard Admin | Manajemen pengguna, katalog, laporan |

**Validasi di sisi client** (`RoleGuard`):
- Route `/admin` dan sub-route admin hanya untuk role `admin`
- Route `/dashboard` untuk role `user`
- Fitur premium (lebih dari 3 opsi) memerlukan plan `premium`

**Validasi di sisi database** (RLS + fungsi):
- `is_admin_user()` — cek role admin
- `is_premium_user()` — cek plan premium
- Admin hanya yang bisa update role dan plan pengguna lain

---

## 10. Decision CRUD API (Lengkap)

Digunakan untuk membuat, membaca, memperbarui, dan menghapus keputusan pengguna.

| # | Endpoint | Method | Deskripsi | Akses |
|---|----------|--------|-----------|-------|
| 10.1 | `/rest/v1/decision_histories` | POST | Create: simpan keputusan baru | Authenticated |
| 10.2 | `/rest/v1/decision_histories` | GET | Read: daftar semua keputusan sendiri | Authenticated |
| 10.3 | `/rest/v1/decision_histories?id=eq.<id>` | GET | Read: detail satu keputusan | Authenticated (owner) |
| 10.4 | `/rest/v1/decision_histories?id=eq.<id>` | PATCH | Update: perbarui keputusan (review, rating, dll) | Authenticated (owner) |
| 10.5 | `/rest/v1/decision_histories?id=eq.<id>` | DELETE | Delete: hapus keputusan | Authenticated (owner) |

Detail implementasi lihat **Bagian 3** dan **Bagian 4** di atas.

---

## 11. Status Code Ringkasan (Lengkap)

| Kode | Arti | Digunakan untuk |
|------|------|-----------------|
| 200 | OK | GET, PATCH berhasil |
| 201 | Created | POST berhasil membuat data baru |
| 204 | No Content | DELETE berhasil |
| 400 | Bad Request | Validasi input gagal |
| 401 | Unauthorized | Token hilang/kadaluarsa / belum login |
| 403 | Forbidden | RLS menolak akses (bukan milik user / bukan admin) |
| 404 | Not Found | Data tidak ditemukan |
| 429 | Too Many Requests | Rate limit (Auth) |
| 500 | Internal Server Error | Kesalahan server/database |

---

## 12. Keamanan (RLS & Otorisasi)

Semua tabel diaktifkan **Row Level Security (RLS)**:

- `public.pengguna`: user hanya bisa read/update baris miliknya sendiri; admin bisa read semua dan update role/plan
- `public.decision_histories`: user hanya bisa CRUD baris miliknya sendiri (`user_id = auth.uid()`)
- `public.decision_history_reviews`: user hanya bisa CRUD ulasan miliknya sendiri (`user_id = auth.uid()`)
- Publishable key (anon key) digunakan di aplikasi client; `service_role` key **tidak pernah** disimpan di kode Flutter
- Fungsi database (`is_admin_user`, `is_premium_user`, `get_user_profile`) berjalan dengan `security definer`

---

## 13. File Implementasi Terkait

- `supabase/migrations/20261110000000_decision_history.sql` — skema & RLS riwayat keputusan
- `supabase/migrations/20261110000001_user_plan_management.sql` — kolom plan, fungsi admin/premium, RLS pengguna
- `supabase/migrations/20261028010000_auth_use_pengguna.sql` — tabel pengguna, role, trigger signup
- `lib/features/auth/domain/repositories/auth_repository.dart` — kontrak autentikasi
- `lib/features/auth/data/repositories/supabase_auth_repository.dart` — implementasi Supabase Auth
- `lib/features/auth/presentation/providers/auth_provider.dart` — status autentikasi
- `lib/features/decision_history/domain/entities/decision_history.dart` — entitas riwayat keputusan
- `lib/features/decision_history/domain/repositories/decision_history_repository.dart` — antarmuka repository riwayat
- `lib/features/decision_history/data/models/decision_history_model.dart` — model data riwayat
- `lib/features/decision_history/data/repositories/supabase_decision_history_repository.dart` — implementasi Supabase riwayat
- `lib/features/decision_history/presentation/providers/decision_history_provider.dart` — provider riwayat
- `lib/core/routes/role_guard.dart` — pemeriksaan akses layar user/admin

