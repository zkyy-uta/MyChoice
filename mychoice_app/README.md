# MyChoice Mobile App 📱

AI-Assisted Personal Decision Support System - Flutter Mobile Application

## 🎯 About

MyChoice adalah aplikasi mobile berbasis AI yang membantu mahasiswa dan dewasa muda dalam mengambil keputusan secara terstruktur berdasarkan kebutuhan, kondisi, dan prioritas pribadi menggunakan metode **Simple Additive Weighting (SAW)**.

## ✨ Features (Phase 1)

### ✅ Implemented
- [x] Splash Screen dengan animasi
- [x] Onboarding (4 slides) dengan ilustrasi
- [x] Login & Register screens
- [x] Dashboard dengan:
  - User greeting
  - Create New Decision button
  - Continue Your Decision cards
  - Decision Summary statistics
  - Recent Decisions list
  - Bottom Navigation Bar

### 🔄 Coming Next (Phase 2)
- [ ] Category Selection (Technology, Education, Fashion)
- [ ] Choice Management (dari katalog atau custom)
- [ ] Criteria Input dengan AI suggestions
- [ ] Result & Ranking (SAW calculation)
- [ ] Comparison view
- [ ] What-If Simulation
- [ ] Decision History

## 🏗️ Tech Stack

- **Framework**: Flutter 3.35.3
- **Language**: Dart 3.9.2
- **State Management**: Provider (planned)
- **Navigation**: Flutter Navigation (MaterialPageRoute)
- **Fonts**: Google Fonts (Lexend family)
- **Platform**: Android (iOS support included)

## 📦 Dependencies

```yaml
dependencies:
  google_fonts: ^6.1.0      # Typography
  provider: ^6.1.1          # State management
  go_router: ^12.1.1        # Navigation (for future use)
  flutter_svg: ^2.0.9       # SVG support
  http: ^1.1.0              # API calls
  shared_preferences: ^2.2.2 # Local storage
  intl: ^0.18.1             # Date formatting
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK: 3.35.3 or higher
- Dart SDK: 3.9.2 or higher
- Android Studio or VS Code
- Android SDK or iOS Simulator

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd mychoice_app
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

### Run on specific device
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

## 📂 Project Structure

```
lib/
├── core/
│   └── theme/
│       ├── app_colors.dart       # Color palette
│       ├── app_typography.dart   # Text styles
│       ├── app_spacing.dart      # Spacing system
│       └── app_theme.dart        # Theme configuration
├── screens/
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── onboarding/
│   │   ├── onboarding_screen.dart
│   │   └── widgets/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   └── dashboard/
│       └── dashboard_screen.dart
├── app.dart                      # App widget & routing
└── main.dart                     # Entry point
```

## 🎨 Design System

### Color Palette
- **Primary**: Purple gradient (#8B7EF2 - #B4A7FF)
- **Secondary**: Pink (#FFB6E5)
- **Category Colors**:
  - Technology: Purple
  - Education: Pink  
  - Fashion: Orange

### Typography
- **Font Family**: Lexend (Google Fonts)
- **Weights**: Regular (400), Semibold (600), Bold (700), Extra Bold (800)
- **Sizes**: 10sp - 28sp

### Spacing
- Base unit: 4px
- Scale: xs (4) → sm (8) → md (12) → lg (16) → xl (20) → xxl (24) → huge (32)

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

## 🔍 Code Analysis

```bash
# Analyze code for issues
flutter analyze

# Format code
flutter format lib/
```

## 📱 Build

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### iOS (requires macOS)
```bash
flutter build ios --release
```

## 🐛 Known Issues

- Assets (logo, illustrations) masih menggunakan placeholder
- Backend integration belum diimplementasikan
- Google Sign-In belum terintegrasi
- Data di Dashboard masih static/hardcoded

## 📝 TODO

### High Priority
- [ ] Replace placeholder assets dengan design sebenarnya
- [ ] Implement Decision Flow screens (Phase 2)
- [ ] Setup state management dengan Provider
- [ ] Integrate dengan Backend API

### Medium Priority
- [ ] Unit tests untuk business logic
- [ ] Widget tests untuk UI components
- [ ] Integration tests untuk user flows
- [ ] Error handling improvement

### Low Priority
- [ ] Add animations & transitions
- [ ] Implement dark mode
- [ ] Add internationalization (i18n)
- [ ] Performance optimization

## 📖 Documentation

- [Design System](../docs/DESIGN_SYSTEM.md)
- [API Integration](../docs/API_INTEGRATION.md)
- [State Management](../docs/STATE_MANAGEMENT.md)
- [Testing Guide](../docs/TESTING.md)

## 🤝 Contributing

1. Create feature branch (`git checkout -b feature/AmazingFeature`)
2. Commit changes (`git commit -m 'Add some AmazingFeature'`)
3. Push to branch (`git push origin feature/AmazingFeature`)
4. Open Pull Request

## 📄 License

Copyright © 2026 PBL-516 Team

---

**Team Members:**
- 4342411046 - Ghifarry Ramadhan Mahendra
- 4342401066 - Thalita Aurelia Marsim
- 4342401080 - Adhyca Hafeez Wibowo
- 4342401086 - Ananda Meliana Sembiring

**Program Studi Teknologi Rekayasa Perangkat Lunak**
**Jurusan Teknik Informatika**
**Politeknik Negeri Batam**
