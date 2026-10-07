# 📁 MyChoice Assets Folder

## 📂 Folder Structure

```
assets/
├── images/           # Logo, photos, general images
├── icons/            # Category icons, UI icons
└── illustrations/    # Onboarding illustrations, 3D graphics
```

---

## 🎯 Required Assets

### Priority 1: HIGH (Needed NOW)

#### Logo
- [x] Folder created: `images/`
- [ ] **logo_mychoice.png** (512x512 px, PNG transparent)
  - Usage: Splash screen, about page
  - Current: Icon placeholder

#### Onboarding Illustrations
- [x] Folder created: `illustrations/`
- [ ] **onboarding_welcome.png** (600x600 px)
  - Description: Maskot anjing dengan kacamata
  - Current: 🐕 emoji placeholder
- [ ] **onboarding_understand.png** (600x600 px)
  - Description: Dokumen dengan kaca pembesar
  - Current: 📋 emoji placeholder
- [ ] **onboarding_compare.png** (600x600 px)
  - Description: Timbangan
  - Current: ⚖️ emoji placeholder
- [ ] **onboarding_result.png** (600x600 px)
  - Description: Orang dengan checklist
  - Current: 📊 emoji placeholder

---

### Priority 2: MEDIUM (Phase 2)

#### Category Icons
- [x] Folder created: `icons/`
- [ ] **category_technology.png** (128x128 px)
  - Icon: Laptop/computer (purple theme)
- [ ] **category_education.png** (128x128 px)
  - Icon: Graduation cap/book (pink theme)
- [ ] **category_fashion.png** (128x128 px)
  - Icon: Clothing/hanger (orange theme)

---

### Priority 3: LOW (Can wait)

#### User Profile
- [ ] **avatar_default.png** (256x256 px)
  - Default user avatar
  - Current: Network image placeholder

---

## 📏 Size & Format Guidelines

| Asset Type | Size | Format | Notes |
|------------|------|--------|-------|
| Logo | 512x512 | PNG-24 transparent | Square, internal padding |
| Illustrations | 600x600 | PNG transparent | 3D style, purple palette |
| Icons | 128x128 | PNG transparent | Flat/minimalist |
| Avatar | 256x256 | PNG transparent | Circular crop area |

---

## 📝 File Naming Rules

✅ **CORRECT:**
- `logo_mychoice.png`
- `onboarding_welcome.png`
- `category_technology.png`

❌ **WRONG:**
- `Logo MyChoice.png` (ada spasi)
- `Onboarding-Welcome.PNG` (uppercase, dash)
- `logo1.png` (tidak descriptive)

**Rules:**
- Lowercase only
- Use underscore `_` (not dash `-` or space)
- Descriptive names
- Consistent prefixes

---

## 🔄 How to Add New Assets

### Step 1: Place Files
Copy your assets to the correct folder:
```bash
assets/images/logo_mychoice.png       ✅
assets/illustrations/onboarding_*.png ✅
assets/icons/category_*.png           ✅
```

### Step 2: Verify in pubspec.yaml
File `pubspec.yaml` sudah configured:
```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
    - assets/illustrations/
```

### Step 3: Run Flutter
```bash
flutter pub get
flutter run
```

---

## 💻 Usage in Code

### Load Image Asset
```dart
Image.asset(
  'assets/images/logo_mychoice.png',
  width: 150,
  height: 150,
  fit: BoxFit.contain,
)
```

### With Error Handling
```dart
Image.asset(
  'assets/illustrations/onboarding_welcome.png',
  width: 200,
  height: 200,
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.error_outline, size: 100);
  },
)
```

### Preload for Performance
```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  precacheImage(
    AssetImage('assets/images/logo_mychoice.png'),
    context,
  );
}
```

---

## 🎨 Design Resources

Refer to: **[ASSETS_NAMING_GUIDE.md](../ASSETS_NAMING_GUIDE.md)**

---

## ✅ Status

| Category | Status | Count |
|----------|--------|-------|
| **Logo** | ⏳ Waiting | 0/1 |
| **Illustrations** | ⏳ Waiting | 0/4 |
| **Icons** | ⏳ Waiting | 0/3 |
| **Avatar** | ⏳ Waiting | 0/1 |
| **Total** | ⏳ Waiting | **0/9** |

---

**Need Help?** 
- File naming → See [ASSETS_NAMING_GUIDE.md](../ASSETS_NAMING_GUIDE.md)
- Size requirements → See guide above
- Implementation → Ask developer

---

**Last Updated**: December 2024
