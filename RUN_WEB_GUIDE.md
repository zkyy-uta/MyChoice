# 🌐 MyChoice - Web Running Guide

## ✅ Web Support Sudah Diaktifkan!

Folder `web/` sudah dibuat di project.

---

## 🚀 Cara Run di Chrome

### Option 1: Debug Mode (dengan Hot Reload)

```bash
cd mychoice_app
flutter run -d chrome
```

**Jika ada error WebSocket/Firewall:**
- Matikan antivirus sementara
- Atau gunakan Option 2 (Release Mode)

---

### Option 2: Release Mode (Recommended - No WebSocket Issue)

```bash
cd mychoice_app
flutter run -d chrome --release
```

✅ **Kelebihan:**
- Tidak ada masalah WebSocket/Firewall
- Lebih cepat
- Tidak perlu debug service

❌ **Kekurangan:**
- Tidak bisa hot reload
- Restart app kalau ada perubahan code

---

### Option 3: Build & Serve (Production-like)

```bash
# Build production web
flutter build web

# Serve dengan web server (install dulu)
# npm install -g http-server
# http-server build/web -p 8080

# Atau pakai Python
cd build/web
python -m http.server 8080
```

Buka browser: `http://localhost:8080`

---

## 🔥 Quick Commands

```bash
# List devices
flutter devices

# Run di Chrome (debug)
flutter run -d chrome

# Run di Chrome (release - recommended)
flutter run -d chrome --release

# Run di Edge
flutter run -d edge --release

# Clean build jika error
flutter clean
flutter pub get
flutter run -d chrome --release
```

---

## ⚠️ Troubleshooting

### Error: "WebSocket connection failed"

**Penyebab:**
- Firewall Windows
- Antivirus (Kaspersky, Avast, dll)
- Corporate network restrictions

**Solusi 1 - Matikan Firewall Sementara:**
```powershell
# Run as Administrator
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
```

**Solusi 2 - Tambah Exception ke Firewall:**
- Buka Windows Defender Firewall
- Advanced Settings
- Inbound Rules → New Rule
- Allow: `dart.exe`, `flutter.exe`, `chrome.exe`

**Solusi 3 - Gunakan Release Mode (Paling Mudah):**
```bash
flutter run -d chrome --release
```
Release mode tidak perlu debug WebSocket jadi tidak ada masalah!

---

### Error: "This application is not configured to build on the web"

**Solusi:**
```bash
flutter config --enable-web
flutter create --platforms web .
flutter clean
flutter pub get
```

---

### Chrome tidak otomatis terbuka

**Manual:**
1. Run command: `flutter run -d chrome --release`
2. Copy URL dari terminal (biasanya `http://localhost:xxxxx`)
3. Buka Chrome manual dan paste URL

---

## 📱 Devices Available

```bash
flutter devices
```

Output:
```
Chrome (web) • chrome • web-javascript • Google Chrome
Edge (web)   • edge   • web-javascript • Microsoft Edge
```

---

## 🎯 Recommended Workflow untuk Development:

### Development (dengan Hot Reload):
```bash
flutter run -d chrome
```

Jika error WebSocket, gunakan Release Mode:
```bash
flutter run -d chrome --release
```

### Production Build:
```bash
flutter build web --release
```

Output: `build/web/` folder

---

## 🌟 Tips

1. **Release Mode lebih stabil** untuk web development
2. Hot Reload di web lebih lambat, **restart app** kalau perubahan besar
3. Google Fonts butuh **internet connection**
4. Network images (avatar) butuh **internet connection**

---

## ✅ Quick Start

Jalankan ini sekarang:

```bash
cd C:\MyChoice\mychoice_app
flutter run -d chrome --release
```

Tunggu 20-30 detik, Chrome akan buka otomatis! 🎉

---

**Press `q` to quit app dari terminal**

**Happy coding!** 🚀
