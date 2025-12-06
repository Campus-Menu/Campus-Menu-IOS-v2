# Campus Menu iOS - Kurulum Kılavuzu

SwiftUI ile geliştirilmiş, yerli JSON depolama kullanan kampüs yemekhane uygulaması.

## ✅ Proje Durumu

Tüm dosyalar **Campus Menu/** klasörüne yerleştirilmiştir ve Xcode projesine eklenmeye hazır!

## 📂 Klasör Yapısı

```
Campus Menu/
├── Models/
│   └── Models.swift                  ✅ Veri modelleri
├── Services/
│   └── DataRepository.swift          ✅ JSON veri katmanı
├── Utils/
│   ├── ThemeManager.swift            ✅ Tema yönetimi
│   └── LocalizationManager.swift     ✅ Dil yönetimi
├── Views/
│   ├── Auth/
│   │   ├── RoleSelectionView.swift   ✅ Rol seçimi
│   │   ├── AdminLoginView.swift      ✅ Admin giriş
│   │   ├── StudentLoginView.swift    ✅ Öğrenci giriş
│   │   └── StudentRegisterView.swift ✅ Kayıt ekranı
│   ├── Main/
│   │   ├── MainTabView.swift         ✅ Ana tab navigasyon
│   │   ├── HomeView.swift            ✅ Günlük menü
│   │   ├── CalendarView.swift        ✅ Menü takvimi
│   │   ├── FavoritesView.swift       ✅ Favoriler
│   │   ├── AnnouncementsView.swift   ✅ Duyurular
│   │   └── ProfileView.swift         ✅ Profil & ayarlar
│   ├── Admin/
│   │   ├── AdminManagementView.swift ✅ Menü yönetimi
│   │   └── AdminReviewsView.swift    ✅ Değerlendirmeler
│   └── Components/
│       ├── MenuItemCard.swift        ✅ Yemek kartı
│       ├── CategoryChip.swift        ✅ Kategori chip
│       └── ReviewDialog.swift        ✅ Değerlendirme dialog
├── Campus_MenuApp.swift              ✅ Ana entry point
├── ContentView.swift                 ✅ Root view
└── Assets.xcassets/                  ✅ Görseller
```

## 🚀 Xcode'da Çalıştırma (3 ADIM)

### ADIM 1: Projeyi Aç
```bash
cd "/Users/cagansahbaz/Desktop/flight/Flight Schedule/Campus-Menu-IOS-v2"
open "Campus Menu.xcodeproj"
```

### ADIM 2: Dosyaları Xcode'a Ekle

**📍 ÖNEMLİ:** Dosyalar zaten doğru klasörlerde, sadece Xcode'a tanıtmanız gerekiyor!

#### 🟢 Yöntem 1: Sürükle-Bırak (EN KOLAY)

1. **Finder'da** `Campus Menu` klasörünü açın
2. Aşağıdaki 4 klasörü **Xcode Project Navigator'a** (sol panel) sürükleyin:
   - `Models/`
   - `Services/`
   - `Utils/`
   - `Views/` (tüm alt klasörleriyle)

3. Açılan dialog'da:
   - ✅ **"Create groups"** seçin
   - ❌ **"Copy items if needed"** KALDIRIN (dosyalar zaten içeride)
   - ✅ Target: **"Campus Menu"** işaretli olsun
   - **"Add"** butonuna tıklayın

#### 🔵 Yöntem 2: Add Files Menüsü

1. Xcode'da `Campus Menu` klasörüne **sağ tıklayın**
2. **"Add Files to 'Campus Menu'..."** seçin
3. Açılan dialog'da `Campus Menu` klasörüne gidin
4. **Command** tuşuna basılı tutarak şu 4 klasörü seçin:
   - `Models/`
   - `Services/`
   - `Utils/`
   - `Views/`
5. Options kısmında:
   - ✅ **"Create groups"** seçin
   - ❌ **"Copy items if needed"** KALDIRIN
   - ✅ **"Add to targets: Campus Menu"** işaretli olsun
6. **"Add"** butonuna tıklayın

### ADIM 3: Build & Run

1. **Simulator Seçin:** iPhone 15 Pro (iOS 17.0+)
2. **Command + R** ile çalıştırın
3. İlk açılışta örnek veriler otomatik oluşturulacak

## ✅ Doğrulama

Build sonrası **0 error** olmalı. Project Navigator'da şu yapıyı görmelisiniz:

```
📁 Campus Menu
  ├── 📁 Models (1 dosya)
  ├── 📁 Services (1 dosya)  
  ├── 📁 Utils (2 dosya)
  ├── 📁 Views
  │   ├── 📁 Auth (4 dosya)
  │   ├── 📁 Main (6 dosya)
  │   ├── 📁 Admin (2 dosya)
  │   └── 📁 Components (3 dosya)
  ├── 📄 Campus_MenuApp.swift
  ├── 📄 ContentView.swift
  └── 📁 Assets.xcassets
```

**Toplam:** 21 Swift dosyası

## 🔐 Demo Hesaplar

### 👨‍💼 Yönetici
```
Email: admin@campus.com
Şifre: admin123
```

### 👨‍🎓 Öğrenci
```
Email: ogrenci@campus.com
Şifre: 123456
```

## 🎨 Özellikler

✅ **Dual-role sistem** (Öğrenci/Yönetici)  
✅ **4 renk teması** (Turuncu/Mavi/Yeşil/Mor) + Dark mode  
✅ **4 dil** (TR/EN/DE/FR) - Anlık değişim  
✅ **7 alerjen** desteği - Otomatik filtreleme  
✅ **6 menü kategorisi** (Kahvaltı, Öğle, Akşam, Çorba, Atıştırmalık, Tatlı)  
✅ **Rating sistemi** (1-5 yıldız + yorum)  
✅ **Favori yönetimi**  
✅ **Menü takvimi** (7 günlük örnek veri)  
✅ **Admin menü CRUD**  
✅ **Admin değerlendirme moderasyonu**  
✅ **JSON tabanlı yerel depolama**  
✅ **SIFIR bağımlılık** - Sadece SwiftUI + Foundation  

## 📊 Teknik Detaylar

- **Platform:** iOS 17.0+
- **Framework:** SwiftUI
- **Dil:** Swift 5.9+
- **Mimari:** MVVM + Repository Pattern
- **State Management:** ObservableObject + @Published
- **Depolama:** FileManager + JSON (Documents dizini)
- **Bağımlılık:** YOK (100% native)

## 🗂️ Veri Depolama

JSON dosyaları `Documents` dizininde:
- `students.json` - Öğrenci hesapları
- `menu_history.json` - Menü takvimi  
- `reviews.json` - Değerlendirmeler
- `announcements.json` - Duyurular
- `preferences.json` - Kullanıcı tercihleri

## 🐛 Sorun Giderme

### Dosyalar Xcode'da görünmüyor
1. Project Navigator'da (⌘+1) olduğunuzdan emin olun
2. Finder'da dosyaların `Campus Menu/` içinde olduğunu doğrulayın
3. Xcode'u kapatıp yeniden açın

### Build hatası alıyorum
1. **Product → Clean Build Folder** (⇧⌘K)
2. **Product → Build** (⌘B)
3. Tüm dosyaların "Campus Menu" target'ına ekli olduğunu doğrulayın

### Simulator açılmıyor
1. **Xcode → Open Developer Tool → Simulator**
2. **Hardware → Device → iOS 17.0** seçin
3. Simulator'u yeniden başlatın

## 📝 Önemli Notlar

- İlk açılışta örnek veriler otomatik oluşturulur (7 gün menü, 2 duyuru, 1 demo öğrenci)
- Rating ortalaması 1 ondalık basamakla hesaplanır (4.3 formatında)
- Tema değişiklikleri ANINDA uygulanır (yeniden başlatma gerekmez)
- Alerjen filtreleme otomatik çalışır (seçilen alerjenleri içeren yemekler gizlenir)

## 🎯 Sonraki Adımlar

Projeyi çalıştırdıktan sonra:
1. ✅ Rol seçimi ekranından Öğrenci veya Admin seçin
2. ✅ Demo hesaplarla giriş yapın
3. ✅ Menüleri görüntüleyin ve değerlendirin
4. ✅ Admin olarak menü ekleyin/düzenleyin
5. ✅ Tema ve dil ayarlarını test edin

## 📄 Lisans

Bu proje eğitim amaçlı geliştirilmiştir.

---

**Son Güncelleme:** 06.12.2025  
**Versiyon:** 1.0.0  
**iOS Target:** 17.0+  
**Dosya Sayısı:** 21 Swift dosyası  
**Satır Sayısı:** ~3,500+ satır kod
