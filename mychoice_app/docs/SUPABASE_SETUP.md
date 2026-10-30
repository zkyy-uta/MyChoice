# Panduan Setup Supabase MyChoice

Dokumen ini menjelaskan konfigurasi Supabase untuk login, pendaftaran,
pemulihan password, dan akun admin di aplikasi MyChoice.

## Yang perlu disiapkan

- Akses ke proyek Supabase yang digunakan aplikasi.
- Akses ke [Supabase Dashboard](https://supabase.com/dashboard).
- Inbox email yang dapat dibuka untuk pengujian konfirmasi dan reset password.
- Untuk penggunaan produksi: domain dan kredensial SMTP dari penyedia email.

Aplikasi mengambil URL proyek dan publishable key dari `lib/main.dart`.
Publishable key boleh digunakan oleh aplikasi client. **Jangan pernah
memasukkan `service_role` key, password SMTP, atau password admin ke kode
Flutter atau repository.**

## Penghapusan akun user

Fitur **Delete Account** di profil user menghapus akun Auth yang sedang login
dan data terkait yang memiliki foreign key `ON DELETE CASCADE`. Penghapusan
permanen ini memerlukan Edge Function karena aplikasi Flutter tidak boleh
memegang `service_role` key.

1. Pastikan Supabase CLI sudah terpasang, lalu login:

   ```powershell
   supabase login
   ```

2. Dari folder `mychoice_app`, deploy function ke project yang dipakai aplikasi:

   ```powershell
   supabase functions deploy delete-account --project-ref mwthzxveegbjpiujolzb
   ```

   Supabase menyediakan `SUPABASE_URL` dan `SUPABASE_SERVICE_ROLE_KEY` untuk
   Edge Function. Jangan menyalin service role key ke aplikasi atau menyimpannya
   di source code.
3. Buka aplikasi, masuk ke **My Profile → DATA & PRIVACY → Delete Account**,
   lalu konfirmasi **Hapus akun**. Jika function belum dideploy atau gagal,
   aplikasi menampilkan error dan tidak mengeluarkan pengguna dari akun.

Function memvalidasi access token dan hanya menghapus ID user yang berasal dari
token tersebut; client tidak dapat mengirim ID akun lain. Periksa foreign key
untuk tabel tambahan buatan sendiri dan pastikan relasi data milik pengguna
menggunakan `ON DELETE CASCADE`, atau hapus data terkait dengan kebijakan yang
sesuai sebelum mengaktifkan fitur.

## 1. Siapkan tabel pengguna dan role

1. Masuk ke Supabase Dashboard dan pilih proyek MyChoice.
2. Pada proyek baru, jalankan sekali seluruh file
   [`../MyChoice_Supabase_Setup_Pilihan.sql`](../MyChoice_Supabase_Setup_Pilihan.sql)
   melalui **SQL Editor → New query**. File tersebut membuat tabel
   `public.pengguna`, role default `user`, RLS, dan trigger signup.
3. Jika setup tabel sudah pernah dijalankan, jangan jalankan ulang file setup
   492 baris. Sebagai gantinya, jalankan seluruh isi migration
   [`../supabase/migrations/20261028010000_auth_use_pengguna.sql`](../supabase/migrations/20261028010000_auth_use_pengguna.sql)
   melalui query baru. Migration ini menambahkan kolom role ke `pengguna`,
   menyalin role/nama dari `profiles` jika tabel itu telanjur dibuat, dan
   mengisi data `pengguna` untuk akun Auth yang sudah ada.
4. Di **Table Editor → pengguna**, pastikan ada kolom `id_pengguna`, `nama`,
   `email`, `role`, dan `tanggal_dibuat`. Role harus bernilai `user` atau
   `admin`.

Tabel `public.pengguna` adalah sumber data profil dan role aplikasi. Tabel
`public.profiles` yang mungkin sudah dibuat oleh instruksi sebelumnya tidak
perlu dihapus sekarang. Migration upgrade menyalin datanya; biarkan tabel itu
tetap ada sampai login dan role sudah diverifikasi. Trigger lama yang menulis
ke `profiles` dihentikan oleh migration; pendaftaran baru hanya membuat baris
di `pengguna`.

## 2. Aktifkan autentikasi email

1. Buka **Authentication → Sign In / Providers → Email**. Nama menu dapat
   sedikit berbeda tergantung versi Dashboard.
2. Pastikan provider Email aktif.
3. Aktifkan **Confirm email**, lalu simpan.
4. Sesuaikan kebijakan password Supabase agar setidaknya memenuhi aturan
   aplikasi: minimal 8 karakter, satu huruf besar, dan satu angka.
5. Daftarkan akun uji dengan email yang inbox-nya dapat diakses.
6. Buka email konfirmasi, ikuti tautannya, lalu login melalui aplikasi.

Saat konfirmasi email aktif, pendaftaran dapat berhasil tanpa membuat sesi
login. Aplikasi memberi tahu pengguna untuk mengonfirmasi email sebelum login.

## 3. Aktifkan login Google

Error `Unsupported provider: provider is not enabled` berarti provider Google
belum diaktifkan di Supabase. Tombol aplikasi sudah memulai OAuth, tetapi
konfigurasi Google Cloud dan Supabase harus diselesaikan satu kali:

1. Buka Supabase Dashboard, pilih proyek MyChoice, lalu buka **Authentication
   → Sign In / Providers → Google**. Aktifkan Google dan salin **Callback
   URL** yang ditampilkan di halaman tersebut. Biasanya formatnya
   `https://<project-ref>.supabase.co/auth/v1/callback`.
2. Buka [Google Cloud Console](https://console.cloud.google.com/) dan pilih
   atau buat project.
3. Buka **Google Auth Platform → Branding** (atau **OAuth consent screen**),
   isi nama aplikasi dan email dukungan, lalu simpan. Jika status audiens
   **Testing**, tambahkan akun Google yang dipakai untuk uji coba sebagai
   **Test user**.
4. Buka **Google Auth Platform → Clients** (atau **Credentials → Create
   Credentials → OAuth client ID**), buat client bertipe **Web application**,
   lalu masukkan Callback URL dari langkah pertama pada **Authorized redirect
   URIs**. URL yang dimasukkan di sini adalah callback Supabase, bukan
   `mychoice://login-callback`.
5. Salin **Client ID** dan **Client Secret** dari Google ke pengaturan Google
   provider di Supabase. Simpan dan pastikan provider tetap aktif.
6. Di Supabase, buka **Authentication → URL Configuration → Redirect URLs**
   dan tambahkan `mychoice://login-callback`. Untuk web, tambahkan juga origin
   web aplikasi, misalnya `https://domain-web-anda.example` atau
   `http://localhost:5000`.
7. Jalankan ulang aplikasi Android setelah instalasi/build baru agar deep link
   `mychoice://login-callback` terdaftar pada HP. Uji dengan akun Google yang
   sudah ditambahkan sebagai test user jika aplikasi Google masih berstatus
   Testing.

Saat login, Chrome atau browser sistem dapat terbuka sebentar untuk Google
OAuth; setelah berhasil, browser semestinya kembali ke aplikasi MyChoice.
Jika muncul halaman JSON `Unsupported provider`, kembali ke langkah pertama
dan pastikan Google sudah **Enabled** pada proyek Supabase yang sama dengan
URL proyek aplikasi. Jangan taruh Client Secret di aplikasi Flutter atau
repository.

## 4. Konfigurasikan SMTP

Untuk produksi, siapkan penyedia email SMTP, misalnya Resend, Postmark, atau
SendGrid.

1. Ikuti petunjuk penyedia untuk memverifikasi domain pengirim.
2. Buat kredensial SMTP khusus dan catat host, port, username, password, serta
   alamat pengirim yang telah diverifikasi.
3. Di Supabase Dashboard, buka **Project Settings → Authentication → SMTP
   Settings** atau **Authentication → SMTP Settings**.
4. Aktifkan custom SMTP dan masukkan kredensial dari penyedia email.
5. Simpan, lalu uji email konfirmasi dan email reset password.

Gunakan kredensial SMTP dari penyedia, bukan password email pribadi. Jangan
commit kredensial tersebut ke Git. Layanan email bawaan Supabase memiliki
batas pengiriman untuk pengujian dan bukan pengganti konfigurasi email
produksi.

## 5. Atur reset password tanpa membuka browser

Aplikasi menggunakan kode OTP recovery: pengguna meminta kode melalui email,
memasukkan kode tersebut di aplikasi, lalu mengatur password baru di form
MyChoice. Supabase tetap memverifikasi kepemilikan email sebelum mengizinkan
perubahan password.

1. Di Supabase Dashboard, buka **Authentication → Email Templates → Reset
   Password**.
2. Ubah isi email agar menampilkan kode OTP, bukan tautan. Contoh:

   ```html
   <h2>Reset password MyChoice</h2>
   <p>Gunakan kode berikut di aplikasi MyChoice:</p>
   <p style="font-size: 24px; font-weight: bold;">{{ .Token }}</p>
   <p>Kode ini hanya dapat digunakan sekali. Jika Anda tidak meminta reset,
   abaikan email ini.</p>
   ```

   Pastikan template tidak lagi menggunakan `{{ .ConfirmationURL }}` sebagai
   tombol/link reset. Simpan template.
3. Dari aplikasi MyChoice, pilih **Lupa password?**, masukkan email, lalu tekan
   **Kirim kode reset**. Aplikasi otomatis membuka halaman **Masukkan Kode
   Reset**; halaman ini tidak menampilkan tombol kembali ke login.
4. Buka email, salin kode 8 digit, kembali ke aplikasi, masukkan kode, lalu
   tekan **Verifikasi kode**. Jika valid, aplikasi berpindah ke halaman **Buat
   Password Baru**.
5. Isi **Password baru** dan **Konfirmasi password baru**. Tombol simpan aktif
   hanya jika password memenuhi aturan (minimal 8 karakter, satu huruf besar,
   satu angka) dan kedua isian sama. Jika berbeda, aplikasi menampilkan pesan
   bahwa password belum sama dan tidak mengizinkan lanjut.
6. Tekan **Simpan password baru** setelah tombol aktif. Password diperbarui di
   Supabase dan aplikasi meminta pengguna login lagi.

Langkah ini tidak memerlukan redirect URL, Chrome, atau custom scheme. Bagian
redirect `mychoice://reset-password` yang sudah ada hanya diperlukan untuk
tautan recovery lama yang mungkin masih berada di inbox. Jangan mengubah
Site URL atau redirect konfigurasi OAuth Google saat mengatur template reset.

Jangan hilangkan verifikasi OTP dan jangan mengganti alur ini dengan perubahan
password tanpa bukti kepemilikan email. Validasi format password saja tidak
cukup untuk mencegah pihak lain mengambil alih akun.

### Jika login/reset menampilkan `Failed host lookup`

1. Pastikan HP terhubung ke internet. Coba ganti Wi-Fi ke data seluler atau
   sebaliknya, lalu nonaktifkan sementara VPN atau Private DNS untuk pengujian.
2. Pastikan URL project Supabase di `lib/main.dart` sama dengan URL project
   yang dibuka di Dashboard.
3. Pasang ulang APK hasil build terbaru. Permission internet aplikasi Android
   sudah didaftarkan pada `android/app/src/main/AndroidManifest.xml`; APK lama
   yang dibuat sebelum perubahan itu belum membawa permission tersebut.

## 6. Buat akun admin dengan aman

Tidak ada password admin default di source code. Buat akun admin secara
terkontrol:

1. Buat akun memakai email yang dikuasai tim, melalui aplikasi atau
   **Authentication → Users → Add user**.
2. Gunakan password sementara yang kuat dan unik. Jika dibuat melalui aplikasi
   dengan konfirmasi email aktif, konfirmasikan email terlebih dahulu.
3. Setelah akun dibuat dan trigger membuat baris pengguna, buka **SQL Editor →
   New query**.
4. Ganti alamat email contoh di bawah dengan email akun admin, lalu jalankan:

   ```sql
   update public.pengguna
   set role = 'admin'
   where id_pengguna = (
     select id from auth.users where email = 'admin@example.com'
   );
   ```

5. Pastikan hanya satu baris yang diperbarui. Jika tidak ada baris yang
   berubah, pastikan akun Auth sudah ada dan baris `pengguna` sudah dibuat.
6. Login menggunakan akun tersebut. Role database seharusnya membawa akun ke
   dashboard admin.
7. Ganti password sementara sesudah login pertama. Jangan membagikan
   kredensial admin di dokumentasi publik.

Promosi role dilakukan operator proyek lewat SQL Editor, bukan oleh pengguna
dari aplikasi. Jangan memberikan akses SQL Editor atau service-role key
kepada pengguna biasa.

## 7. Uji setup

- Daftar akun user dan konfirmasikan email.
- Login user: aplikasi membuka dashboard user.
- Login admin: aplikasi membuka dashboard admin.
- Minta reset password, buka tautan di perangkat, lalu simpan password baru.
- Logout: sesi Supabase berakhir dan halaman privat tidak lagi dapat dibuka.
- Dari akun user, coba buka URL `/admin` secara langsung: akses harus ditolak.
- Dari akun admin, coba buka URL `/dashboard`: akses harus diarahkan ke area
  admin.

Route guard di aplikasi adalah lapisan UX dan tidak menggantikan RLS. Setiap
tabel bisnis baru (misalnya keputusan, katalog, atau laporan) tetap perlu
RLS dan kebijakan akses yang sesuai sebelum dipakai di produksi.
