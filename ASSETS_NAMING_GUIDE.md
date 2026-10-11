# 📁 MyChoice Assets - File Naming Convention

## 📂 Folder Structure

```
assets/
├── images/
│   ├── logo_mychoice.png              # Logo utama
│   ├── logo_mychoice_white.png        # Logo putih (untuk dark bg)
│   └── avatar_default.png             # Avatar default
│
├── icons/
│   ├── category_technology.png        # Icon kategori Technology
│   ├── category_education.png         # Icon kategori Education
│   └── category_fashion.png           # Icon kategori Fashion
│
└── illustrations/
    ├── onboarding_welcome.png         # Onboarding slide 1
    ├── onboarding_understand.png      # Onboarding slide 2
    ├── onboarding_compare.png         # Onboarding slide 3
    └── onboarding_result.png          # Onboarding slide 4
```

---

## 🎨 Detailed Asset List

### 1. **Logo MyChoice**

#### Splash Screen & General
- **File**: `assets/images/logo_mychoice.png`
- **Size**: 512x512 px (square)
- **Format**: PNG dengan background transparan
- **Deskripsi**: Logo utama MyChoice (huruf M dengan gradient purple)
- **Usage**: Splash screen, about page, email signature

#### Logo Variants (Optional)
- **File**: `assets/images/logo_mychoice_white.png`
- **Size**: 512x512 px
- **Format**: PNG transparan
- **Deskripsi**: Logo putih untuk background gelap
- **Usage**: Dark mode (future)

---

### 2. **Onboarding Illustrations**

#### Slide 1: Welcome
- **File**: `assets/illustrations/onboarding_welcome.png`
- **Size**: 600x600 px (square) atau 800x600 px (landscape)
- **Format**: PNG transparan atau JPG
- **Deskripsi**: Maskot anjing pakai kacamata (3D illustration)
- **Alt Text**: "Welcome to MyChoice - Dog mascot with sunglasses"
- **Current**: Emoji 🐕 placeholder

#### Slide 2: Understand Your Needs
- **File**: `assets/illustrations/onboarding_understand.png`
- **Size**: 600x600 px
- **Format**: PNG transparan
- **Deskripsi**: Dokumen dengan kaca pembesar (3D illustration)
- **Alt Text**: "Understand your needs - Document with magnifying glass"
- **Current**: Emoji 📋 placeholder

#### Slide 3: Compare Your Options
- **File**: `assets/illustrations/onboarding_compare.png`
- **Size**: 600x600 px
- **Format**: PNG transparan
- **Deskripsi**: Timbangan keadilan (3D illustration)
- **Alt Text**: "Compare your options - Balance scale"
- **Current**: Emoji ⚖️ placeholder

#### Slide 4: Understand the Result
- **File**: `assets/illustrations/onboarding_result.png`
- **Size**: 600x600 px
- **Format**: PNG transparan
- **Deskripsi**: Orang dengan checklist/dokumen (3D illustration)
- **Alt Text**: "Understand the result - Person with checklist"
- **Current**: Emoji 📊 placeholder

---

### 3. **Category Icons**

#### Technology
- **File**: `assets/icons/category_technology.png`
- **Size**: 128x128 px
- **Format**: PNG transparan
- **Deskripsi**: Icon laptop/computer (purple theme)
- **Usage**: Category selection card, decision cards

#### Education
- **File**: `assets/icons/category_education.png`
- **Size**: 128x128 px
- **Format**: PNG transparan
- **Deskripsi**: Icon graduation cap/book (pink theme)
- **Usage**: Category selection card, decision cards

#### Fashion
- **File**: `assets/icons/category_fashion.png`
- **Size**: 128x128 px
- **Format**: PNG transparan
- **Deskripsi**: Icon clothing/hanger (orange theme)
- **Usage**: Category selection card, decision cards

---

### 4. **User Profile**

#### Default Avatar
- **File**: `assets/images/avatar_default.png`
- **Size**: 256x256 px (circular crop area)
- **Format**: PNG transparan
- **Deskripsi**: Avatar default untuk pengguna baru (person icon atau abstract)
- **Usage**: Profile page, dashboard header
- **Current**: Network image dari pravatar.cc

---

## 📏 Size Guidelines

### Recommended Sizes

| Asset Type | Minimum | Recommended | Maximum |
|------------|---------|-------------|---------|
| **Logo** | 256x256 | 512x512 | 1024x1024 |
| **Illustrations** | 400x400 | 600x600 | 1000x1000 |
| **Category Icons** | 96x96 | 128x128 | 256x256 |
| **Avatar** | 128x128 | 256x256 | 512x512 |

### Export Settings
- **Format**: PNG-24 (dengan transparency)
- **Resolution**: 72 DPI (web), 144 DPI (retina)
- **Color Space**: sRGB
- **Compression**: Optimized untuk web (tinypng.com)

---

## 🎨 Design Guidelines

### Logo
- **Background**: Transparan
- **Colors**: Purple gradient (#8B7EF2 → #B4A7FF)
- **Style**: Modern, minimalist, rounded
- **Padding**: 10% internal padding dari edge

### Illustrations
- **Style**: 3D modern/glassmorphism
- **Colors**: Purple palette konsisten dengan brand
- **Background**: Transparan atau gradient soft
- **Shadow**: Subtle drop shadow untuk depth

### Icons
- **Style**: Flat/minimalist atau subtle 3D
- **Line Weight**: 2-3px stroke
- **Color**: Sesuai kategori (purple/pink/orange)
- **Padding**: 15% internal padding

### Avatar
- **Style**: Simple, friendly
- **Background**: Light purple atau white
- **Icon Color**: Purple (#8B7EF2)

---

## 📝 File Format Options

### PNG (Recommended ⭐)
- **Pros**: Transparency support, lossless
- **Cons**: File size lebih besar
- **Use for**: Logo, icons, illustrations

### JPG
- **Pros**: File size kecil
- **Cons**: No transparency
- **Use for**: Photos only (kalau ada)

### SVG (Future Enhancement)
- **Pros**: Scalable, file size kecil
- **Cons**: Perlu flutter_svg package (sudah ada!)
- **Use for**: Icons, logo variants

---

## 🔄 How to Add Assets

### Step 1: Save Files
Masukkan files ke folder yang sesuai:
```
mychoice_app/
└── assets/
    ├── images/
    │   ├── logo_mychoice.png          ✅ PUT HERE
    │   └── avatar_default.png         ✅ PUT HERE
    ├── icons/
    │   └── category_technology.png    ✅ PUT HERE
    └── illustrations/
        └── onboarding_welcome.png     ✅ PUT HERE
```

### Step 2: Update Code

#### Replace Logo di Splash Screen:
```dart
// OLD (placeholder)
Icon(Icons.help_outline_rounded, size: 80)

// NEW (real logo)
Image.asset(
  'assets/images/logo_mychoice.png',
  width: 150,
  height: 150,
)
```

#### Replace Illustrations di Onboarding:
```dart
// OLD (emoji)
Text('🐕', style: TextStyle(fontSize: 80))

// NEW (real illustration)
Image.asset(
  'assets/illustrations/onboarding_welcome.png',
  width: 200,
  height: 200,
  fit: BoxFit.contain,
)
```

#### Replace Avatar di Dashboard:
```dart
// OLD (network image)
CircleAvatar(
  backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1'),
)

// NEW (default avatar)
CircleAvatar(
  backgroundImage: AssetImage('assets/images/avatar_default.png'),
)
```

---

## ✅ Checklist

Copy checklist ini untuk track progress:

### Logo
- [ ] `logo_mychoice.png` (512x512, PNG transparent)
- [ ] `logo_mychoice_white.png` (optional, untuk dark mode)

### Onboarding Illustrations
- [ ] `onboarding_welcome.png` (600x600, maskot anjing)
- [ ] `onboarding_understand.png` (600x600, dokumen + kaca pembesar)
- [ ] `onboarding_compare.png` (600x600, timbangan)
- [ ] `onboarding_result.png` (600x600, orang + checklist)

### Category Icons
- [ ] `category_technology.png` (128x128, laptop icon)
- [ ] `category_education.png` (128x128, graduation cap)
- [ ] `category_fashion.png` (128x128, clothing)

### User Profile
- [ ] `avatar_default.png` (256x256, default avatar)

---

## 📧 Deliverables

Kirimkan files dengan nama **EXACTLY** seperti di atas via:
1. Google Drive link
2. WeTransfer
3. ZIP file di WhatsApp/Email

**Format struktur ZIP:**
```
mychoice_assets.zip
├── images/
│   ├── logo_mychoice.png
│   └── avatar_default.png
├── icons/
│   ├── category_technology.png
│   ├── category_education.png
│   └── category_fashion.png
└── illustrations/
    ├── onboarding_welcome.png
    ├── onboarding_understand.png
    ├── onboarding_compare.png
    └── onboarding_result.png
```

---

## 🎯 Priority

| Priority | Assets | Why |
|----------|--------|-----|
| **HIGH** | Logo + Onboarding illustrations | User first impression |
| **MEDIUM** | Category icons | Decision flow screens (Phase 2) |
| **LOW** | Avatar default | Can use placeholder longer |

---

## 💡 Notes

- **Naming**: Lowercase, underscore separated (`onboarding_welcome` bukan `Onboarding-Welcome`)
- **No spaces**: Use `_` bukan spasi
- **Descriptive**: `logo_mychoice` lebih jelas dari `logo1`
- **Consistent**: Semua illustrations prefix dengan `onboarding_`

---

**Contact Developer untuk Questions:**
- File format issues → tanya developer
- Design approval → tanya PM
- Asset placement → refer ke guide ini

---

**Last Updated**: December 2024
**Status**: Waiting for assets delivery 📦
