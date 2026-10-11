# MyChoice: AI-Assistant Personal Decision Support System

## 📋 Ringkasan Aplikasi

MyChoice adalah aplikasi mobile berbasis AI yang membantu mahasiswa dan dewasa muda dalam mengambil keputusan secara terstruktur berdasarkan kebutuhan, kondisi, dan prioritas pribadi. Aplikasi ini menggunakan Decision Engine dengan metode **Simple Additive Weighting (SAW)** untuk memberikan rekomendasi yang transparan dan dapat dijelaskan.

## 🎯 Masalah yang Diselesaikan

- **96.2%** responden mengalami kesulitan tingkat sedang-tinggi dalam memilih antara beberapa alternatif
- Proses perbandingan manual yang subjektif dan memakan waktu
- Kesulitan menentukan faktor mana yang harus diprioritaskan
- Kurangnya transparansi dalam hasil keputusan

## 💡 Solusi MyChoice

MyChoice mengubah proses pengambilan keputusan manual menjadi terstruktur dan transparan melalui:

1. **Pemilihan Kategori** - Technology, Education, Fashion
2. **Manajemen Pilihan** - Pilih dari katalog atau tambahkan sendiri
3. **Input Prioritas** - Tentukan kriteria dan bobot (total 100%)
4. **Decision Engine SAW** - Perhitungan otomatis: normalisasi → pembobotan → skor → ranking
5. **AI Explanation** - Penjelasan faktor yang mempengaruhi rekomendasi
6. **What-If Simulation** - Lihat dampak perubahan prioritas
7. **Decision History** - Evaluasi keputusan sebelumnya

## 🏗️ Arsitektur Sistem

```
┌─────────────────┐
│  Mobile App     │ ← Flutter (Android)
│  (Frontend)     │
└────────┬────────┘
         │
         │ REST API
         ▼
┌─────────────────┐
│  Backend API    │ ← Node.js + Express.js
│                 │
├─────────────────┤
│  Decision       │ ← Metode SAW
│  Engine         │   (Normalisasi, Pembobotan, Ranking)
│                 │
├─────────────────┤
│  AI Service     │ ← LLM (Pemahaman Konteks, Saran Kriteria,
│                 │   Penjelasan Hasil)
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Database       │ ← Supabase + PostgreSQL
│  (User, Choice, │
│   Decisions,    │
│   History)      │
└─────────────────┘
```

## 🎨 Fitur Utama

| ID | Fitur | Prioritas | Deskripsi |
|----|-------|-----------|-----------|
| **FT-01** | Authentication | Must | Registrasi dan login pengguna |
| **FT-02** | Create Decision | Must | Buat permasalahan keputusan baru |
| **FT-03** | Decision Category | Must | Pilih kategori: Technology, Education, Fashion |
| **FT-04** | Alternative Management | Must | Kelola pilihan dari katalog atau custom |
| **FT-05** | Priority & Preference Input | Must | Input kebutuhan, kriteria, dan bobot |
| **FT-06** | Decision Engine | Must | Perhitungan SAW otomatis |
| **FT-07** | Recommendation & AI Explanation | Must | Rekomendasi + penjelasan AI |
| **FT-08** | Comparison | Should | Bandingkan beberapa pilihan |
| **FT-09** | What-If Simulation | Should | Simulasi perubahan prioritas |
| **FT-10** | Decision History | Should | Riwayat keputusan pengguna |
| **FT-11** | User Account Management | Should | Pengelolaan akun oleh admin |
| **FT-12** | Catalog Management | Must | Pengelolaan katalog oleh admin |

## 🔢 Metode SAW (Simple Additive Weighting)

### Alur Proses Decision Engine:

1. **Decision Matrix** - Susun nilai setiap alternatif terhadap kriteria
2. **Criteria Classification** - Tentukan tipe kriteria (Benefit/Cost)
3. **Normalization**:
   - **Benefit**: `Rij = Xij / Max(Xij)` (semakin besar semakin baik)
   - **Cost**: `Rij = Min(Xij) / Xij` (semakin kecil semakin baik)
4. **Weighted Score**: `Yij = Rij × Wj` (nilai normalisasi × bobot)
5. **Final Score**: `Si = Σ Yij` (jumlahkan semua nilai terbobot)
6. **Ranking** - Urutkan dari skor tertinggi ke terendah

### Contoh Perhitungan:

**Decision Matrix:**
| Laptop | Harga (Cost) | RAM (Benefit) | Storage (Benefit) |
|--------|--------------|---------------|-------------------|
| A      | 8.5jt        | 90            | 512GB             |
| B      | 8.8jt        | 85            | 512GB             |
| C      | 8.2jt        | 80            | 512GB             |

**Bobot:** Harga 30%, RAM 35%, Storage 35%

**Hasil:** Decision Engine menghitung dan menghasilkan ranking otomatis

## 👥 Target Pengguna

### Pengguna Utama (Mahasiswa & Young Adult)
- Membuat keputusan
- Menentukan pilihan dan kriteria
- Melihat hasil dan rekomendasi
- Akses riwayat keputusan

### Admin
- Kelola akun pengguna
- Kelola katalog pilihan, kategori, dan kriteria

## 📦 Model Layanan

| Fitur | Basic (Gratis) | Premium |
|-------|----------------|---------|
| Membuat Keputusan | ✅ Max 5/bulan | ✅ Unlimited |
| Pilihan per Keputusan | ✅ Max 3 | ✅ Max 10 |
| Decision Engine SAW | ✅ | ✅ |
| AI Explanation | ✅ Dasar | ✅ Mendalam |
| What-If Simulation | ❌ / Terbatas | ✅ |
| Decision History | ❌ / Terbatas | ✅ Full |
| Personal Decision Pattern | ❌ | ✅ |

## 🛠️ Tech Stack

### Frontend (Mobile)
- **Framework**: Flutter
- **Language**: Dart
- **Platform**: Android
- **Design Tool**: Figma

### Backend
- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: Supabase + PostgreSQL
- **AI Service**: LLM External API

### Development Tools
- **IDE**: Visual Studio Code
- **Version Control**: Git + GitHub
- **Diagram**: Draw.io

## 📱 User Flow

```
Login/Register
    ↓
Dashboard (Beranda)
    ↓
Create New Choice
    ↓
Pilih Kategori (Technology/Education/Fashion)
    ↓
Tambah Pilihan (dari katalog atau manual)
    ↓
Input Kriteria & Bobot (total 100%)
    ↓
View Result (Decision Engine SAW)
    ↓
Rekomendasi + AI Explanation
    ↓
[Optional] Comparison / What-If Simulation
    ↓
Save to Decision History
```

## 🎯 Kebutuhan Non-Fungsional

| Parameter | Target |
|-----------|--------|
| **Performance** | Response time ≤ 5 detik |
| **Availability** | Stabil selama operasional |
| **Reliability** | Tingkat kegagalan ≤ 5% |
| **Usability** | Mudah digunakan tanpa bantuan |
| **Security** | Autentikasi wajib untuk akses data |
| **Portability** | Berjalan di smartphone Android |
| **Language** | Bahasa Inggris |

## 🚫 Batasan (Out of Scope)

- ❌ MyChoice **BUKAN** chatbot dengan prompt bebas
- ❌ **TIDAK** mengambil keputusan akhir menggantikan pengguna
- ❌ Kategori di luar Technology, Education, Fashion
- ❌ Integrasi transaksi atau layanan eksternal
- ❌ Training model AI sendiri (menggunakan LLM eksternal)
- ❌ Visualisasi AI yang membutuhkan resource besar

## 📐 Halaman & Antarmuka Utama

### 1. **Login/Register** (MF-1)
- Halaman pertama saat aplikasi dibuka
- Form registrasi dan login
- Validasi data dan error handling

### 2. **Dashboard/Beranda** (MF-2)
- Tombol "Create New Choice"
- Akses ke riwayat keputusan
- Profil pengguna

### 3. **Category Selection** (MF-3)
- Pilih Technology, Education, atau Fashion
- Visual card untuk setiap kategori

### 4. **Choice Management** (MF-4)
- Pilih dari katalog atau tambah manual
- Form input pilihan
- AI membantu struktur data

### 5. **Criteria & Priority Input** (MF-5)
- Input kriteria (AI dapat menyarankan)
- Tentukan tipe (Benefit/Cost)
- Slider untuk bobot (total 100%)

### 6. **Result & Recommendation** (MF-6, MF-7)
- Ranking pilihan dengan skor
- AI Explanation
- Detail perhitungan

### 7. **Comparison** (MF-8)
- Perbandingan side-by-side
- Nilai per kriteria
- Visual comparison

### 8. **What-If Simulation** (MF-9)
- Ubah bobot prioritas
- Real-time update ranking
- AI jelaskan perubahan

### 9. **Decision History** (MF-10)
- List keputusan sebelumnya
- Detail setiap keputusan
- Evaluasi hasil

### 10. **Admin Panel** (MF-11, MF-12)
- Kelola user accounts
- Kelola katalog pilihan
- Kelola kategori & kriteria

## 📋 Asumsi & Ketergantungan

- ✅ Pengguna memiliki smartphone Android + internet
- ✅ Backend API dan database di-deploy ke cloud
- ✅ AI Service bergantung pada LLM eksternal
- ✅ Data katalog dikelola admin
- ✅ Validasi hasil dengan Excel SAW sebagai acuan

## 📅 Pengembangan

- **Metodologi**: Agile Scrum
- **Durasi**: 16 minggu (16 sprint)
- **Tim**: PBL-516 (4 anggota)

## 📄 Dokumen Referensi

Proyek ini dilengkapi dengan:
1. **SRS** (Software Requirement Specifications) - IEEE Std 1058.1-1987
2. **PRD** (Product Requirement Document)
3. **TDD** (Technical Design Document) - Detail metode SAW


---

## ✅ **PHASE 1 FRONTEND - COMPLETE!** 🎉

### 🎨 Yang Sudah Dibuat:

#### 1. **Design System** (100%)
- ✅ Color Palette lengkap (Primary Purple, Secondary Pink, Category colors)
- ✅ Typography dengan Lexend font family
- ✅ Spacing System konsisten (2px - 48px)
- ✅ Material 3 Theme configuration

#### 2. **Screens Implemented** (5 Screens)
- ✅ **Splash Screen** - Animated logo dengan gradient background
- ✅ **Onboarding** (4 slides) - Welcome, Understand Needs, Compare Options, Understand Result
- ✅ **Login Screen** - Email/Password, Google Sign-In, Remember me, Forgot Password
- ✅ **Register Screen** - Full registration form dengan date picker & country code
- ✅ **Dashboard Screen** - Complete dengan Create Decision, Continue Decision, Summary, Recent, Bottom Nav

#### 3. **Project Structure**
```
mychoice_app/
├── lib/
│   ├── core/theme/          # Design system (colors, typography, spacing, theme)
│   ├── screens/             # All UI screens
│   │   ├── splash/
│   │   ├── onboarding/
│   │   ├── auth/
│   │   └── dashboard/
│   ├── app.dart             # App widget & routing
│   └── main.dart            # Entry point
├── assets/                  # Images, icons, illustrations (folders created)
├── test/                    # Widget tests
└── pubspec.yaml             # Dependencies
```

**Statistics:**
- **Total Files**: ~17 files
- **Lines of Code**: ~3,000+ lines
- **Dependencies**: 8 packages (google_fonts, provider, go_router, dll)
- **Routes**: 5 routes configured

### 📱 Cara Menjalankan:

```bash
cd mychoice_app
flutter pub get
flutter run
```

**Requirements:**
- Flutter 3.35.3+
- Dart 3.9.2+
- Android SDK atau iOS Simulator

### 📚 Dokumentasi:

- [**PHASE_1_COMPLETE.md**](PHASE_1_COMPLETE.md) - Complete summary & statistics
- [**FRONTEND_PROGRESS.md**](FRONTEND_PROGRESS.md) - Detailed progress tracking
- [**mychoice_app/README.md**](mychoice_app/README.md) - Flutter project README
- [**PROJECT_STRUCTURE.md**](PROJECT_STRUCTURE.md) - Full structure & checklist

### ⚠️ Assets yang Perlu Diganti:
1. **Logo MyChoice** → `assets/images/logo_mychoice.png` (512x512 px, PNG)
2. **Onboarding Illustrations** (4 files di `assets/illustrations/`):
   - `onboarding_welcome.png` - Maskot anjing dengan kacamata
   - `onboarding_understand.png` - Dokumen dengan kaca pembesar
   - `onboarding_compare.png` - Timbangan
   - `onboarding_result.png` - Orang dengan checklist
3. **Category Icons** (3 files di `assets/icons/`) - Untuk Phase 2:
   - `category_technology.png` - Laptop icon (purple)
   - `category_education.png` - Graduation cap (pink)
   - `category_fashion.png` - Clothing icon (orange)
4. **User Avatar** → `assets/images/avatar_default.png` (256x256 px)

📋 **Lihat detail lengkap**: [ASSETS_NAMING_GUIDE.md](ASSETS_NAMING_GUIDE.md)

### 🔜 Backend Integration (TODO):
- ❌ Authentication API
- ❌ Decision Engine API
- ❌ AI Service API
- ❌ Database integration

---

## 🎯 Next Phase: Decision Flow (Phase 2)

Screens yang akan dibuat selanjutnya:
1. **Category Selection** - Technology, Education, Fashion
2. **Choice Management** - Catalog + Custom
3. **Criteria Input** - AI suggestions + Weight sliders
4. **Result Screen** - Ranking + SAW calculation
5. **Comparison** - Side-by-side view
6. **What-If Simulation** - Interactive weight adjustment
7. **Decision History** - Past decisions list

**Status**: ✅ Ready for Phase 2 Development!

---

**Last Updated**: December 2024
**Developed by**: PBL-516 Team | Politeknik Negeri Batam


---

## 🎨 **UI Fixes - Latest Updates**

### ✅ Revisi Terbaru (December 2024):

1. **Logo Transparan** 🖼️
   - Logo sekarang fully transparent (no white background)
   - Size lebih besar: 200x200 (dari 150x150)
   - Perfect dengan gradient background

2. **Onboarding Illustrations Full View** 📱
   - Gambar full height (tidak terpotong)
   - Pas dengan card section di bawah
   - Preserve aspect ratio (no distortion)

3. **Icons Lebih Besar** 🎯
   - Ongoing Decision icons: 32px (dari 20px) - **+60%**
   - Recent Decision icons: 32px (dari 24px) - **+33%**
   - Easier to see & more professional

📋 **Lihat detail lengkap**: [UI_FIXES_SUMMARY.md](UI_FIXES_SUMMARY.md)
