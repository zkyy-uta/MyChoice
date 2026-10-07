# 🔄 Replace Assets - Step by Step Guide

## ⚠️ PENTING: Assets TIDAK otomatis muncul!

Setelah copy files ke folder `assets/`, kamu perlu:
1. ✅ Copy files ke folder yang benar
2. ✅ Update code (replace placeholder)
3. ✅ Run `flutter pub get`
4. ✅ Restart app

---

## 📋 Step-by-Step Process

### STEP 1: Copy Assets Files

Copy files ke folder yang sesuai:

```
mychoice_app/
└── assets/
    ├── images/
    │   ├── logo_mychoice.png          ← COPY HERE
    │   └── avatar_default.png         ← COPY HERE
    ├── icons/
    │   ├── category_technology.png    ← COPY HERE
    │   ├── category_education.png     ← COPY HERE
    │   └── category_fashion.png       ← COPY HERE
    └── illustrations/
        ├── onboarding_welcome.png     ← COPY HERE
        ├── onboarding_understand.png  ← COPY HERE
        ├── onboarding_compare.png     ← COPY HERE
        └── onboarding_result.png      ← COPY HERE
```

---

### STEP 2: Update Flutter

Run command ini:
```bash
cd mychoice_app
flutter pub get
```

---

### STEP 3: Update Code

Ganti placeholder dengan asset files.

#### 🎨 **A. Splash Screen - Logo**

**File**: `lib/screens/splash/splash_screen.dart`

**BEFORE (Current - Line ~87):**
```dart
Container(
  width: 150,
  height: 150,
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.9),
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary88.withOpacity(0.3),
        blurRadius: 30,
        spreadRadius: 5,
      ),
    ],
  ),
  child: const Icon(
    Icons.help_outline_rounded,
    size: 80,
    color: AppColors.primary88,
  ),
),
```

**AFTER (Replace dengan):**
```dart
Container(
  width: 150,
  height: 150,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary88.withOpacity(0.3),
        blurRadius: 30,
        spreadRadius: 5,
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(30),
    child: Image.asset(
      'assets/images/logo_mychoice.png',
      width: 150,
      height: 150,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.help_outline_rounded,
          size: 80,
          color: AppColors.primary88,
        );
      },
    ),
  ),
),
```

---

#### 🎨 **B. Onboarding - Illustrations**

**File**: `lib/screens/onboarding/widgets/onboarding_page.dart`

**BEFORE (Current - Line ~25):**
```dart
Container(
  width: 200,
  height: 200,
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    borderRadius: BorderRadius.circular(24),
  ),
  child: Center(
    child: Text(
      data.illustration,
      style: const TextStyle(fontSize: 80),
    ),
  ),
),
```

**AFTER (Replace dengan):**
```dart
Image.asset(
  data.illustration,  // This will now be the file path
  width: 250,
  height: 250,
  fit: BoxFit.contain,
  errorBuilder: (context, error, stackTrace) {
    // Fallback ke emoji jika gambar tidak ada
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(
          '🖼️',  // Fallback emoji
          style: const TextStyle(fontSize: 80),
        ),
      ),
    );
  },
),
```

**DAN update data di**: `lib/screens/onboarding/onboarding_screen.dart`

**BEFORE (Current - Line ~23):**
```dart
final List<OnboardingData> _pages = const [
  OnboardingData(
    title: 'Welcome to MyChoice',
    subtitle: 'Clarity Before You Decide.',
    description: '...',
    illustration: '🐕', // ← Emoji placeholder
  ),
  OnboardingData(
    title: '🔍 Understand Your Needs',
    subtitle: 'Know What Matters Most',
    description: '...',
    illustration: '📋', // ← Emoji placeholder
  ),
  // ... dll
];
```

**AFTER (Replace dengan):**
```dart
final List<OnboardingData> _pages = const [
  OnboardingData(
    title: 'Welcome to MyChoice',
    subtitle: 'Clarity Before You Decide.',
    description: 'MyChoice membantu kamu membandingkan berbagai pilihan berdasarkan kebutuhan, prioritas, dan kondisi kamu.',
    illustration: 'assets/illustrations/onboarding_welcome.png', // ← Real file
  ),
  OnboardingData(
    title: '🔍 Understand Your Needs',
    subtitle: 'Know What Matters Most',
    description: 'Bingung menentukan apa yang paling penting? MyChoice membantu memahami kebutuhan kamu dan menyarankan kriteria yang relevan.',
    illustration: 'assets/illustrations/onboarding_understand.png', // ← Real file
  ),
  OnboardingData(
    title: '⚖️ Compare Your Options',
    subtitle: 'Compare Without the Confusion',
    description: 'Bandingkan beberapa pilihan berdasarkan kriteria yang benar-benar penting buat kamu.',
    illustration: 'assets/illustrations/onboarding_compare.png', // ← Real file
  ),
  OnboardingData(
    title: '✨ Understand the Result',
    subtitle: 'You Decide. MyChoice Helps.',
    description: 'MyChoice memberikan hasil berdasarkan data dan prioritasmu, menjelaskan alasannya, dan membantu melihat kemungkinan hasil jika prioritasmu berubah.',
    illustration: 'assets/illustrations/onboarding_result.png', // ← Real file
  ),
];
```

---

#### 🎨 **C. Dashboard - Avatar**

**File**: `lib/screens/dashboard/dashboard_screen.dart`

**BEFORE (Current - Line ~96):**
```dart
CircleAvatar(
  radius: 24,
  backgroundColor: Colors.white,
  backgroundImage: const NetworkImage(
    'https://i.pravatar.cc/150?img=1',
  ),
  onBackgroundImageError: (exception, stackTrace) {},
  child: const Icon(
    Icons.person,
    color: AppColors.primary88,
  ),
),
```

**AFTER (Replace dengan):**
```dart
CircleAvatar(
  radius: 24,
  backgroundColor: Colors.white,
  backgroundImage: const AssetImage(
    'assets/images/avatar_default.png',
  ),
  onBackgroundImageError: (exception, stackTrace) {},
  child: const Icon(
    Icons.person,
    color: AppColors.primary88,
  ),
),
```

---

### STEP 4: Hot Restart App

**JANGAN hot reload (r)**, tapi **HOT RESTART (R)** atau restart app completely:

```bash
# Option 1: Hot Restart dari terminal
# Press 'R' (capital R) di terminal

# Option 2: Stop & Run ulang
flutter run -d chrome --release
```

---

## 🤖 Auto-Replace Script (Optional)

Saya buatkan script untuk auto-replace (nanti):

**File**: `replace_assets.dart` (akan saya buat)

```bash
# Run script
dart replace_assets.dart
```

---

## ✅ Verification Checklist

Setelah update code, check ini:

### Visual Check:
- [ ] Splash Screen menampilkan logo MyChoice (bukan icon)
- [ ] Onboarding Slide 1 menampilkan maskot anjing
- [ ] Onboarding Slide 2 menampilkan dokumen + kaca pembesar
- [ ] Onboarding Slide 3 menampilkan timbangan
- [ ] Onboarding Slide 4 menampilkan orang + checklist
- [ ] Dashboard header menampilkan avatar (bukan network image)

### Error Check:
```bash
flutter analyze
```
Pastikan tidak ada error `Asset not found`

---

## ⚠️ Common Issues

### Issue 1: "Unable to load asset"
**Cause**: File tidak ada atau nama salah
**Solution**: 
- Check file name exactly match (case-sensitive!)
- Run `flutter pub get` lagi
- Restart app (bukan hot reload)

### Issue 2: Image tidak muncul (tampil blank)
**Cause**: Format file atau size terlalu besar
**Solution**:
- Check format: PNG atau JPG
- Compress image (max 500KB per file)
- Check dimension sesuai guideline

### Issue 3: "Asset not declared in pubspec.yaml"
**Cause**: pubspec.yaml belum include folder
**Solution**:
File `pubspec.yaml` sudah correct:
```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
    - assets/illustrations/
```

Jika masih error, run:
```bash
flutter clean
flutter pub get
```

---

## 🎯 Quick Summary

```bash
# 1. Copy files to assets/ folders
# 2. Run pub get
flutter pub get

# 3. Update code (3 files)
#    - splash_screen.dart (logo)
#    - onboarding_screen.dart (illustrations path)
#    - onboarding_page.dart (widget)
#    - dashboard_screen.dart (avatar)

# 4. Hot Restart (R) atau run ulang
flutter run -d chrome --release
```

---

## 💡 Pro Tips

1. **Test one by one**: Replace logo dulu, test, baru illustrations
2. **Keep fallback**: ErrorBuilder akan show emoji jika gambar gagal load
3. **Optimize images**: Compress dengan tinypng.com sebelum copy
4. **Use PNG**: Lebih bagus untuk logo & illustrations (support transparency)

---

**Need help?** Tanya developer untuk auto-replace script! 🚀
