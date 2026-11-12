# Bug Log & Regression Test — MyChoice Backend

Tanggal: 12 November 2026  
Proyek: MyChoice (Flutter + Supabase)  
Fitur: Decision History, User Profile & Account Management, Role/Plan Access Control

---

## 1. Daftar Bug Ditemukan & Status

| ID | Judul | Deskripsi | Severity | Status | Penyelesaian |
|----|-------|-----------|----------|--------|--------------|
| BUG-001 | Rating bintang hardcoded 5 | Di `history_detail_screen.dart`, field `rating` diinisialisasi dengan nilai `5` secara konstan dan ikon bintang hanya tampilan statis — user tidak bisa mengubahnya. | Tinggi | **Diperbaiki** | Rating sekarang default `0`, ikon bintang diubah jadi `IconButton` yang dapat diklik, dan tombol "Simpan Ulasan & Rating" menkirim rating + review ke API via `DecisionHistoryProvider`. |
| BUG-002 | History pakai sample data hardcoded | `history_screen.dart` menggunakan `historySampleDecisions` (data palsu) alih-alih data dari backend/API. | Tinggi | **Diperbaiki** | History sekarang memuat data dari Supabase melalui `DecisionHistoryProvider` dan `SupabaseDecisionHistoryRepository`. |
| BUG-003 | Simpan keputusan tidak ke API | `create_decision_screen.dart` dan `result_screen.dart` hanya menyimpan ke `historySampleDecisions` (memori lokal), tidak tersimpan permanen. | Tinggi | **Diperbaiki** | `_saveDecision()` sekarang memanggil `DecisionHistoryProvider.addHistory()` yang menyimpan ke tabel `decision_histories` di Supabase. |
| BUG-004 | Ulasan tidak tersimpan | Field ulasan di history detail hanya disimpan di controller teks lokal, tidak dikirim ke server. | Tinggi | **Diperbaiki** | Ditambahkan `updateReviewAndRating()` di repository + provider, dan UI tombol simpan di detail screen. |
| BUG-005 | Tidak ada validasi rating 1-5 | Tidak ada batasan nilai bintang saat diinput. | Sedang | **Diperbaiki** | Validasi di repository: rating harus antara 1 dan 5, tabel database memiliki `check (rating >= 1 and rating <= 5)`. |
| BUG-006 | RLS belum diterapkan pada tabel history | Tabel riwayat belum ada, sehingga tidak ada pembatasan akses data per user. | Tinggi | **Diperbaiki** | Migration `20261110000000_decision_history.sql` membuat tabel + RLS (user hanya bisa akses baris miliknya sendiri via `auth.uid()`). |
| BUG-007 | Tidak ada kolom plan (basic/premium) | Tabel `pengguna` belum memiliki kolom plan untuk membedakan user basic dan premium. | Tinggi | **Diperbaiki** | Migration `20261110000001_user_plan_management.sql` menambahkan kolom `plan` dengan check constraint `basic`/`premium`. |
| BUG-008 | Tidak ada fungsi cek admin/premium | Tidak ada fungsi database untuk memeriksa role admin dan plan premium. | Tinggi | **Diperbaiki** | Ditambahkan fungsi `is_admin_user()`, `is_premium_user()`, dan `get_user_profile()`. |
| BUG-009 | HistoryScreen crash saat provider tidak tersedia | Test widget yang tidak menyediakan `DecisionHistoryProvider` menyebabkan crash di `initState`. | Tinggi | **Diperbaiki** | `_loadHistories()` dibungkus try-catch untuk `ProviderNotFoundException`. |

---

## 2. Ringkasan Perubahan Implementasi

### Backend / Database
- `supabase/migrations/20261110000000_decision_history.sql`
  - Tabel `decision_histories`: riwayat keputusan per user.
  - Tabel `decision_history_reviews`: ulasan + bintang rating (1-5) per user per riwayat.
  - RLS pada kedua tabel, user hanya mengelola baris miliknya sendiri.
  - Fungsi helper `get_user_decision_history_with_review()`.
- `supabase/migrations/20261110000001_user_plan_management.sql`
  - Kolom `plan` (basic/premium) pada tabel `pengguna`.
  - Fungsi `is_admin_user()`, `is_premium_user()`, `get_user_profile()`.
  - RLS untuk update role/plan (hanya admin).
  - Index untuk query per role, plan, dan email.

### Kontrak API
- `API_CONTRACT.md`: dokumentasi lengkap untuk:
  - **Bagian 1**: Authentication API (register, login, token/session, logout)
  - **Bagian 2**: Catalog API
  - **Bagian 3 & 10**: Decision CRUD API (create, read, update, delete)
  - **Bagian 4**: Decision History API (baca riwayat + ulasan/rating)
  - **Bagian 8 & 9**: User Profile & Account Management (profil, role, plan, hak akses)
  - **Bagian 5, 11**: Status code ringkap
  - **Bagian 6, 12**: Keamanan (RLS & otorisasi)

### Flutter (Backend Integration)
- `lib/features/decision_history/` (6 file): entitas, repository, model, implementasi Supabase, provider
- `lib/features/user_profile/` (6 file): entitas, repository, model, implementasi Supabase, provider
- `lib/app.dart`: register semua repository dan provider di DI

### Frontend Integration
- `lib/screens/user/history/history_screen.dart` — muat daftar riwayat dari API
- `lib/screens/user/history/history_detail_screen.dart` — bintang rating diklik-able (1-5), input ulasan, simpan ke API
- `lib/screens/user/decision/create_decision_screen.dart` — simpan keputusan baru ke API
- `lib/screens/user/decision/result_screen.dart` — simpan hasil keputusan ke API

---

## 3. Regression Test

Test otomatis tersedia di:
- `test/decision_history_model_test.dart` — 6 test: JSON serialization, entity, status getter, copyWith
- `test/decision_history_provider_test.dart` — 9 test: load, add, update review/rating, delete, error handling
- `test/user_profile_test.dart` — 14 test: model parsing, isAdmin/isPremium, provider load/update/clearError

Total: **29 test, semua lulus**

### Cara menjalankan regression test

```powershell
# Dari folder mychoice_app
flutter test test/decision_history_model_test.dart
flutter test test/decision_history_provider_test.dart
flutter test test/user_profile_test.dart
```

### Skenario regresi yang diuji

| Skenario | Harapan |
|----------|---------|
| JSON → model parsing semua field | Semua field terisi benar, default kosong saat field hilang |
| Model → entity konversi | Semua field preserved, `isAdmin`/`isPremium` benar |
| Rating > 0 → status 'Rated' | `status` bernilai `'Rated'` |
| Rating 0 → status 'Decision Made' | `status` bernilai `'Decision Made'` |
| copyWith rating/review | Field diupdate, field lain tidak berubah |
| Provider loadHistories sukses | `histories` terisi, `isLoading=false`, `error=null` |
| Provider loadHistories gagal | `histories` kosong, `error` berisi pesan |
| Provider addHistory sukses | Data masuk ke urutan teratas, dikembalikan |
| Provider addHistory gagal | Kembalikan `null`, `error` terisi |
| Provider saveReviewAndRating (1-5) | Rating dan review diupdate lokal |
| Provider saveReviewAndRating gagal | Kembalikan `false`, `error` terisi |
| Provider deleteHistory | Item dihapus dari daftar |
| Provider clearError | `error` menjadi null |
| UserProfile fromJson | Semua field terisi, default 'user'/'basic' |
| UserProfile isAdmin (admin role) | `true` |
| UserProfile isAdmin (user role) | `false` |
| UserProfile isPremium (premium plan) | `true` |
| UserProfile isPremium (basic plan) | `false` |
| Provider loadProfile sukses | `profile` terisi, `isLoading=false` |
| Provider updateName sukses | Nama diupdate secara lokal |
| Provider updateRoleAndPlan sukses | Role dan plan diupdate |
| Provider clearError | `error` menjadi null |

---

## 4. Checklist Sebelum Rilis

- [ ] Migration `20261110000000_decision_history.sql` dijalankan di Supabase SQL Editor
- [ ] Migration `20261110000001_user_plan_management.sql` dijalankan di Supabase SQL Editor
- [ ] Tabel `decision_histories`, `decision_history_reviews` muncul di Table Editor
- [ ] Kolom `plan` ditambahkan ke tabel `pengguna`
- [ ] RLS aktif pada semua tabel sensitif
- [ ] Fungsi `get_user_decision_history_with_review`, `is_admin_user`, `is_premium_user`, `get_user_profile` dapat dieksekusi
- [ ] `flutter analyze` tidak menunjukkan error baru
- [ ] `flutter test` untuk decision history dan user profile lolos semua
- [ ] Manual test: login → buat keputusan → simpan → buka History → input bintang (1-5) + ulasan → simpan → verifikasi
- [ ] Manual test: buka profil → lihat role dan plan → update nama → verifikasi tersimpan
