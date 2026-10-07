# 🎨 Gradient Animation Guide - MyChoice

## ✅ Yang Sudah Diimplementasikan

### 1. **Soft Gradient Background** 
Gradient yang lebih halus seperti di UI/UX design:
- Purple di atas (top)
- Putih/sangat light purple di tengah (center)
- Purple di bawah (bottom)
- Smooth transitions dengan stops

### 2. **Animated Gradient** 
Background yang bergerak/shimmer dengan animasi subtle:
- Gradient bergerak smooth
- Warna berubah perlahan (color lerp)
- Duration 3-4 detik per cycle
- Repeat mode (bolak-balik)

### 3. **Frosted Glass Effect**
Blur effect dengan gradient overlay:
- Decorative blur circles
- Radial gradient overlays
- Seperti efek frosted glass

---

## 🚀 Cara Penggunaan

### Option 1: Static Soft Gradient (Recommended untuk performa)

```dart
import '../../core/widgets/animated_gradient_background.dart';

// Wrap screen dengan SoftGradientBackground
SoftGradientBackground(
  child: YourContent(),
)
```

**Dipakai di:**
- ✅ Onboarding Screen
- ✅ Login Screen
- ✅ Register Screen

---

### Option 2: Animated Gradient (Untuk special screens)

```dart
import '../../core/widgets/animated_gradient_background.dart';

// Wrap dengan AnimatedGradientBackground
AnimatedGradientBackground(
  animate: true,
  duration: Duration(seconds: 3),
  child: YourContent(),
)
```

**Dipakai di:**
- ✅ Splash Screen (dengan animasi)

---

### Option 3: Frosted Glass Effect

```dart
import '../../core/widgets/animated_gradient_background.dart';

// Wrap dengan FrostedGradientBackground
FrostedGradientBackground(
  blurSigma: 100.0,
  child: YourContent(),
)
```

**Best for:**
- Modal/Dialog backgrounds
- Overlay screens
- Special effects

---

## 🎨 Gradient Variants Available

### 1. `AppColors.backgroundGradient`
**Original** - Simple purple gradient (top to bottom)
```dart
const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFB4A7FF), // Light Purple
    Color(0xFF8B7EF2), // Primary Purple
  ],
)
```

### 2. `AppColors.softGradientBackground` ⭐ **RECOMMENDED**
**Soft** - Like UI/UX design (purple → white → purple)
```dart
const LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  stops: [0.0, 0.3, 0.7, 1.0],
  colors: [
    Color(0xFFB4A7FF), // Purple top
    Color(0xFFF5F3FF), // Very light purple/white
    Color(0xFFF5F3FF), // Very light purple/white
    Color(0xFFB4A7FF), // Purple bottom
  ],
)
```

### 3. Animated Gradient Colors
**For shimmer effect:**
```dart
static const List<Color> animatedGradientColors = [
  Color(0xFFE3DDFF), // Light purple
  Color(0xFFB4A7FF), // Medium purple
  Color(0xFF8B7EF2), // Primary purple
  Color(0xFFB4A7FF), // Medium purple
  Color(0xFFE3DDFF), // Light purple
];
```

---

## 📋 Implementation Details

### Splash Screen ✨
```dart
AnimatedGradientBackground(
  animate: true,
  duration: const Duration(seconds: 3),
  child: Center(
    child: Column(
      children: [
        // Logo with shadow
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.primary88.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        // Gradient text
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              AppColors.primary88,
              AppColors.primaryLight,
            ],
          ).createShader(bounds),
          child: Text('MyChoice'),
        ),
      ],
    ),
  ),
)
```

**Features:**
- ✅ Animated gradient background (3s cycle)
- ✅ Logo fade + scale animation
- ✅ Gradient text effect
- ✅ Glowing shadow effect

---

### Onboarding/Login/Register 🌈
```dart
SoftGradientBackground(
  child: SafeArea(
    child: YourScreenContent(),
  ),
)
```

**Features:**
- ✅ Static soft gradient (better performance)
- ✅ Purple top & bottom
- ✅ White center
- ✅ Smooth color transitions

---

## 🎯 Customization

### Change Animation Speed
```dart
AnimatedGradientBackground(
  duration: Duration(seconds: 5), // Slower
  child: child,
)
```

### Disable Animation (static)
```dart
AnimatedGradientBackground(
  animate: false, // Static
  child: child,
)
```

### Custom Blur Amount
```dart
FrostedGradientBackground(
  blurSigma: 150.0, // More blur
  child: child,
)
```

---

## 💡 Tips

### Performance
- **Static gradient** (`SoftGradientBackground`) lebih ringan
- **Animated gradient** hanya untuk splash/special screens
- Avoid animating terlalu banyak screens sekaligus

### Visual Balance
- Purple di top/bottom memberikan frame natural
- White center memudahkan readability
- Soft transitions lebih elegant dari hard stops

### Consistency
- Gunakan **SoftGradientBackground** sebagai default
- **AnimatedGradientBackground** hanya untuk wow factor
- **FrostedGradientBackground** untuk overlays/modals

---

## 🔄 Migration from Old Gradient

### Before (Old):
```dart
Container(
  decoration: const BoxDecoration(
    gradient: AppColors.backgroundGradient,
  ),
  child: child,
)
```

### After (New):
```dart
SoftGradientBackground(
  child: child,
)
```

**Much cleaner!** ✨

---

## 📊 Comparison

| Type | Performance | Visual | Use Case |
|------|-------------|--------|----------|
| **Static Soft** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | Default screens |
| **Animated** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Splash, special |
| **Frosted Glass** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | Modals, overlays |

---

## ✅ Screens Updated

- [x] Splash Screen → **AnimatedGradientBackground**
- [x] Onboarding Screen → **SoftGradientBackground**
- [x] Login Screen → **SoftGradientBackground**
- [x] Register Screen → **SoftGradientBackground**
- [ ] Dashboard (already has custom header gradient)

---

## 🎨 Result

Background sekarang:
1. ✅ **Lebih soft** - Purple-white-purple gradient
2. ✅ **Ada animasi** di splash screen
3. ✅ **Sesuai UI/UX** design yang diberikan
4. ✅ **Professional** look & feel

---

**Enjoy the smooth gradients!** 🌈✨
