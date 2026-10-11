# 🚀 MyChoice Frontend - Quick Start Guide

## ✅ Phase 1 Status: COMPLETE!

5 screens telah selesai diimplementasikan dengan design system lengkap.

---

## 📱 Run the App

```bash
cd mychoice_app
flutter pub get
flutter run
```

---

## 🎨 Screens Available

### 1. **Splash Screen** (`/`)
- Animated MyChoice logo
- Auto-navigate to onboarding after 3s

### 2. **Onboarding** (`/onboarding`)
- 4 slides dengan page indicators
- Skip button
- Back/Next navigation
- "Let's Get Started" button

### 3. **Login** (`/login`)
- Email & password
- Remember me
- Forgot password link
- Google Sign-In
- Link to Register

### 4. **Register** (`/register`)
- Full registration form:
  - First name, Last name
  - Email
  - Date of birth (picker)
  - Phone (with country code)
  - Password
- Link to Login

### 5. **Dashboard** (`/dashboard`)
- User greeting
- Create New Decision button
- Continue Your Decision cards
- Decision Summary (3 stats)
- Recent Decisions list
- Bottom Navigation (5 items)

---

## 🎨 Design System

### Colors
```dart
AppColors.primary88        // #8B7EF2 (Purple)
AppColors.secondary80      // #FFB6E5 (Pink)
AppColors.categoryTechnology
AppColors.categoryEducation
AppColors.categoryFashion
```

### Typography
```dart
AppTypography.screenTitle        // 28sp, 800
AppTypography.sectionTitle       // 20sp, 700
AppTypography.sectionInnerTitle  // 16sp, 600
AppTypography.body               // 14sp, 400
AppTypography.buttonLarge        // 16sp, 600
```

### Spacing
```dart
AppSpacing.xs    // 4px
AppSpacing.sm    // 8px
AppSpacing.md    // 12px
AppSpacing.lg    // 16px
AppSpacing.xl    // 20px
AppSpacing.xxl   // 24px
```

---

## 📂 Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | Entry point |
| `lib/app.dart` | App widget & routing |
| `lib/core/theme/app_colors.dart` | Color palette |
| `lib/core/theme/app_typography.dart` | Text styles |
| `lib/core/theme/app_theme.dart` | Theme config |
| `lib/screens/splash/splash_screen.dart` | Splash |
| `lib/screens/onboarding/onboarding_screen.dart` | Onboarding |
| `lib/screens/auth/login_screen.dart` | Login |
| `lib/screens/auth/register_screen.dart` | Register |
| `lib/screens/dashboard/dashboard_screen.dart` | Dashboard |

---

## 🛠️ Useful Commands

```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Run on specific device
flutter run -d <device-id>

# List devices
flutter devices

# Analyze code
flutter analyze

# Format code
flutter format lib/

# Build APK
flutter build apk --release

# Run tests
flutter test

# Clean build
flutter clean
```

---

## 🐛 Troubleshooting

### Issue: "Waiting for another flutter command to release the startup lock"
```bash
flutter clean
```

### Issue: Google Fonts tidak load
- Pastikan ada koneksi internet
- Check pubspec.yaml sudah include `google_fonts`

### Issue: Asset not found
- Pastikan folder `assets/` sudah ada
- Check `pubspec.yaml` bagian assets

---

## 📚 Documentation

- **[PHASE_1_COMPLETE.md](PHASE_1_COMPLETE.md)** - Complete summary
- **[FRONTEND_PROGRESS.md](FRONTEND_PROGRESS.md)** - Progress tracking
- **[PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md)** - Full structure
- **[mychoice_app/README.md](mychoice_app/README.md)** - Flutter README

---

## 🎯 Next Steps

### Phase 2: Decision Flow Screens
1. Category Selection
2. Choice Management
3. Criteria Input
4. Result & Ranking
5. Comparison
6. What-If Simulation
7. Decision History

### Assets Needed
- [ ] MyChoice logo (PNG/SVG)
- [ ] Onboarding illustrations (4 images)
- [ ] Category icons (Technology, Education, Fashion)
- [ ] Default user avatar

---

## 👥 Team

**PBL-516** | Politeknik Negeri Batam
- Ghifarry Ramadhan Mahendra
- Thalita Aurelia Marsim
- Adhyca Hafeez Wibowo
- Ananda Meliana Sembiring

---

**Happy Coding!** 🚀
