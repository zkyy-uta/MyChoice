# Cara Kerja Backend Autentikasi MyChoice

Dokumen ini menjelaskan implementasi login, register, lupa password, reset
password, role user/admin, dan perlindungan halaman dengan bahasa yang dapat
digunakan untuk presentasi atau diskusi proyek.

## Ringkasan arsitektur

MyChoice menggunakan **Supabase Auth sebagai layanan backend autentikasi
terkelola**. Flutter tidak menyimpan atau memeriksa password sendiri dan tidak
mengirim password ke tabel profil. Supabase menangani verifikasi password,
konfirmasi email, sesi, token, dan email pemulihan.

```text
Widget Flutter
    ↓
AuthProvider (status dan alur UI)
    ↓
AuthRepository (kontrak operasi autentikasi)
    ↓
SupabaseAuthRepository (implementasi Supabase)
    ↓
Supabase Auth + public.pengguna + RLS
```

Komponen utama:

| Komponen | Tanggung jawab |
|---|---|
| `AuthProvider` | Mengelola status seperti loading, login, error, dan logout. |
| `AuthRepository` | Mendefinisikan operasi autentikasi agar UI tidak bergantung langsung pada SDK. |
| `SupabaseAuthRepository` | Memanggil Supabase Auth dan membaca profil serta role. |
| `auth.users` | Dikelola Supabase Auth; menyimpan identitas, email terverifikasi, dan kredensial secara aman. |
| `public.pengguna` | Menyimpan profil aplikasi, nama, email, role, dan tanggal pembuatan akun. |
| Trigger database | Membuat baris pengguna dengan role `user` ketika akun Auth baru dibuat. |
| RLS | Membatasi pembacaan dan perubahan baris pengguna berdasarkan sesi. |
| `RoleGuard` | Memeriksa sesi dan peran sebelum layar privat dibuka. |

`RoleGuard` adalah perlindungan navigasi di client. Otorisasi data yang
sebenarnya harus tetap diterapkan di database/API, misalnya dengan RLS.

## Login

1. Pengguna memasukkan email dan password di layar login.
2. Widget memvalidasi format input, lalu meminta
   `AuthProvider.login(email, password)`.
3. Provider memindahkan status ke `loading` dan memanggil repository.
4. `SupabaseAuthRepository.login` memanggil
   `supabase.auth.signInWithPassword`.
5. Password diverifikasi oleh Supabase Auth, bukan dibandingkan dengan nilai
   di kode Flutter atau tabel profil.
6. Jika login berhasil, repository menggunakan id pengguna untuk membaca
   `nama`, `role`, dan `tanggal_dibuat` dari `public.pengguna`.
7. Role `user` dipetakan ke aktor user dan role `admin` dipetakan ke aktor
   admin. Role yang tidak dikenal ditolak.
8. Provider menyimpan user dan sesi pada status aplikasi.
9. Layar login memilih tujuan:
   - user → `/dashboard`
   - admin → `/admin`
10. Jika profil tidak ditemukan atau role tidak valid, sesi dibatalkan dan
    akses tidak diberikan.

Supabase Flutter mengelola penyimpanan dan refresh sesi. Aplikasi tidak perlu
menciptakan token buatan sendiri.

## Login dengan Google

1. Tombol **Continue with Google** memanggil
   `supabase.auth.signInWithOAuth` melalui `AuthProvider` dan repository.
2. Web memakai origin situs yang sedang dibuka sebagai redirect. Android/iOS
   memakai deep link `mychoice://login-callback`.
3. Supabase dan Google menangani autentikasi OAuth. Setelah callback, Supabase
   menerbitkan event `signedIn`; aplikasi membaca profil dan role dari
   `public.pengguna`, lalu mengarahkan user/admin ke dashboard masing-masing.
4. Akun Google baru mendapatkan baris `pengguna` dengan role default `user`
   dari trigger database.

Provider Google, OAuth Client ID/Secret, dan URL callback Supabase harus
disiapkan di Dashboard Supabase dan Google Cloud Console. Rahasia OAuth tidak
disimpan di aplikasi. Lihat [panduan setup Supabase](./SUPABASE_SETUP.md)
untuk langkah konfigurasi.

## Register

1. Form meminta nama, email, password, dan persetujuan syarat. Tanggal lahir
   tidak diminta.
2. `RegisterScreen` membentuk `RegistrationData` tanpa role.
3. Provider memanggil `SupabaseAuthRepository.register`.
4. Repository mengirim email, password, dan nama ke
   `supabase.auth.signUp`.
5. Supabase membuat identitas autentikasi. Trigger database membuat baris
   `pengguna` dengan `role = 'user'`.
6. Role tidak diambil dari input pengguna atau metadata form. Karena itu,
   pengguna yang mendaftar sendiri tidak bisa memilih admin.
7. Jika konfirmasi email aktif dan Supabase belum memberi sesi, aplikasi
   meminta pengguna memeriksa email. Setelah email dikonfirmasi, pengguna
   login seperti biasa.
8. Jika proyek mengizinkan login langsung setelah pendaftaran, sesi dan profil
   dibaca lalu pengguna diarahkan menurut role yang tersimpan di database.

Password hanya digunakan untuk permintaan pendaftaran ke Supabase Auth.
Password tidak disalin ke `public.pengguna`.

## Lupa password dan reset password

### Meminta kode reset

1. Pengguna memasukkan email di layar **Forgot Password**.
2. Aplikasi memanggil `supabase.auth.resetPasswordForEmail`.
3. Template email recovery menampilkan OTP `{{ .Token }}` dan tidak menyertakan
   link `{{ .ConfirmationURL }}`.
4. Supabase mengirim kode pemulihan melalui email.
5. Pesan keberhasilan dibuat umum agar aplikasi tidak mengungkapkan apakah
   suatu alamat email terdaftar.

### Mengatur password baru

1. Pengguna memasukkan kode email di aplikasi.
2. Repository memanggil `supabase.auth.verifyOTP` dengan tipe `recovery`.
   Supabase memverifikasi kode dan membuat sesi recovery.
3. Event `passwordRecovery` membuka `/reset-password`.
4. Form meminta password baru dan konfirmasi password.
5. Repository memanggil `supabase.auth.updateUser` untuk mengganti password,
   lalu logout agar sesi recovery tidak terus digunakan.
6. Pengguna diminta login kembali menggunakan password baru.

Kode OTP memberi bukti kepemilikan email tanpa perlu membuka browser atau link
eksternal. Jangan izinkan perubahan password tanpa verifikasi recovery.

Alur OTP recovery tidak memerlukan redirect URL karena kode diverifikasi di
dalam aplikasi. Redirect URL tetap digunakan untuk OAuth Google dan tautan
recovery lama. SMTP dan template email perlu dikonfigurasi untuk pengiriman
yang andal di produksi.

## Dua aktor: user dan admin

Pemisahan aktor disimpan di kolom `role` pada `public.pengguna`, bukan
ditentukan oleh tombol login:

| Nilai database | Aktor aplikasi | Halaman awal setelah login |
|---|---|---|
| `user` | `UserRole.basic` | Dashboard user |
| `admin` | `UserRole.admin` | Dashboard admin |

Alur membuat admin:

1. Operator membuat akun Supabase Auth melalui cara normal.
2. Trigger membuat profil awal sebagai `user`.
3. Operator yang berwenang mengubah role akun tertentu menjadi `admin` lewat
   SQL Editor.
4. Pada login berikutnya, aplikasi membaca role tersebut dari database.

Tidak ada password admin universal, default, atau sederhana yang ditanam
dalam aplikasi. Autentikasi memverifikasi identitas; kolom role menentukan
otorisasi.

## Apa yang diamankan?

### Di Supabase

- Password ditangani Supabase Auth dan tidak disimpan di tabel profil aplikasi.
- Sesi dan token dikelola Supabase Flutter.
- Trigger menetapkan role default `user` tanpa menerima role dari pendaftaran.
- `public.pengguna` mengaktifkan RLS.
- Pengguna terautentikasi hanya dapat membaca barisnya sendiri.
- Hak update kolom dibatasi ke `nama`; pengguna tidak diberi hak update
  kolom `role`.
- Peran admin dipromosikan lewat operator proyek, bukan lewat form client.

### Di Flutter

- Route privat diperiksa oleh `RoleGuard`.
- Halaman admin hanya ditampilkan untuk role admin.
- Halaman user tidak ditampilkan untuk role admin.
- Logout memanggil Supabase Auth, bukan hanya berpindah halaman.
- Error autentikasi ditampilkan tanpa membuat status sukses palsu.

### Batas keamanan yang perlu dijelaskan

`RoleGuard` berjalan di aplikasi client sehingga bukan batas keamanan untuk
data: client dapat dimodifikasi. RLS atau pemeriksaan izin di server harus
melindungi setiap tabel dan operasi sensitif. Setup database memasang RLS
untuk `pengguna`; tabel lain yang menyimpan data keputusan atau
laporan harus memiliki policy sendiri. Publishable key bukan rahasia; jangan
pernah mengirim `service_role` key ke aplikasi.

## File implementasi yang relevan

- `lib/main.dart` — inisialisasi Supabase.
- `lib/app.dart` — dependency injection repository/provider dan listener
  recovery.
- `lib/features/auth/domain/repositories/auth_repository.dart` — kontrak
  autentikasi dan data registrasi.
- `lib/features/auth/data/repositories/supabase_auth_repository.dart` —
  implementasi Supabase untuk login, register, reset, logout, dan profil.
- `lib/features/auth/presentation/providers/auth_provider.dart` — status dan
  operasi autentikasi.
- `lib/screens/auth/login_screen.dart` — UI login dan
  routing berdasarkan role.
- `lib/screens/auth/register_screen.dart` — UI
  pendaftaran dan konfirmasi email.
- `lib/screens/auth/forgot_password_screen.dart` —
  permintaan email reset.
- `lib/screens/auth/reset_password_screen.dart` — form
  password baru.
- `lib/core/routes/role_guard.dart` — pemeriksaan akses layar user/admin.
- `supabase/migrations/20261028010000_auth_use_pengguna.sql` — menyelaraskan
  autentikasi ke tabel `pengguna` dan memindahkan role dari tabel `profiles`
  lama bila ada.
- `android/app/src/main/AndroidManifest.xml` dan `ios/Runner/Info.plist` —
  pendaftaran scheme untuk callback OAuth dan tautan recovery lama.

## Contoh jawaban singkat untuk dosen

**Apakah ini backend buatan sendiri?**  
Autentikasi backend menggunakan Supabase Auth sebagai layanan terkelola.
Flutter berkomunikasi dengan Supabase melalui repository, sedangkan database
Postgres menyimpan profil dan role. Jadi password dan token tidak dikelola
secara manual oleh widget.

**Bagaimana aplikasi membedakan user dan admin?**  
Setelah Supabase memverifikasi login, aplikasi membaca role dari
`public.pengguna`. Role `user` diarahkan ke dashboard user dan role `admin`
ke dashboard admin.

**Bagaimana mencegah pengguna mendaftar sebagai admin?**  
Form tidak mengirim role. Trigger database selalu membuat profil baru dengan
role `user`; perubahan ke `admin` dilakukan operator melalui dashboard
Supabase.

**Apakah menyembunyikan halaman admin sudah cukup aman?**  
Tidak. Route guard membantu mencegah navigasi biasa, tetapi client bisa
dimodifikasi. Karena itu, akses data harus juga dibatasi dengan RLS atau
otorisasi server.

**Bagaimana lupa password bekerja?**  
Aplikasi meminta Supabase mengirim email recovery. Tautan mengarah ke
`mychoice://reset-password`, aplikasi menerima event recovery, lalu pengguna
mengatur password baru melalui Supabase Auth.
