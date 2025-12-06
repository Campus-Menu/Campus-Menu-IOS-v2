# Campus Menu iOS

[![iOS CI](https://github.com/Campus-Menu/Campus-Menu-IOS-v2/actions/workflows/ios-ci.yml/badge.svg)](https://github.com/Campus-Menu/Campus-Menu-IOS-v2/actions/workflows/ios-ci.yml)
[![Test Coverage](https://github.com/Campus-Menu/Campus-Menu-IOS-v2/actions/workflows/coverage.yml/badge.svg)](https://github.com/Campus-Menu/Campus-Menu-IOS-v2/actions/workflows/coverage.yml)
[![Swift Version](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2017.0+-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

SwiftUI ile geliştirilmiş, yerli JSON depolama kullanan kampüs yemekhane uygulaması.

## 🚀 Özellikler

### Öğrenci Özellikleri
- 📅 **Günlük Menü:** Bugünün menüsünü kategori filtresiyle görüntüle
- 🗓️ **Menü Takvimi:** Gelecekteki menüleri takvimden seç ve görüntüle
- ⭐ **Değerlendirme Sistemi:** Yemekleri puanla ve yorum yap
- ❤️ **Favoriler:** Sevdiğin yemekleri favorilere ekle
- 🔔 **Duyurular:** Kampüs duyurularını takip et
- 🧪 **Alerji Filtreleme:** Alerjenlerini tanımla, o içerikleri içeren yemekleri gizle
- 🎨 **Temalar:** 4 renk teması (Turuncu, Mavi, Yeşil, Mor) + Karanlık mod
- 🌍 **Çoklu Dil:** Türkçe, İngilizce, Almanca, Fransızca

### Yönetici Özellikleri
- 📝 **Menü Yönetimi:** Menü günleri ekle, düzenle, sil
- 📋 **Yemek CRUD:** Yemek öğeleri ekle (kategori, kalori, alerjen bilgileriyle)
- 💬 **Değerlendirme Yönetimi:** Öğrenci yorumlarını onayla ve yanıtla
- 📢 **Duyuru Görüntüleme:** Kampüs duyurularını gör

## 📱 Sistem Gereksinimleri

- **iOS:** 17.0+
- **Xcode:** 15.0+
- **Swift:** 5.9+

## 🏗️ Mimari

### Proje Yapısı

```
Campus Menu/
├── Models/
│   └── Models.swift              # Veri modelleri (MenuItem, MenuDay, Student, vb.)
├── Managers/
│   ├── DataRepository.swift       # JSON tabanlı veri katmanı
│   ├── ThemeManager.swift         # Tema yönetimi (4 renk + dark mode)
│   └── LocalizationManager.swift  # Çoklu dil desteği (TR/EN/DE/FR)
├── Views/
│   ├── Auth/
│   │   ├── RoleSelectionView.swift
│   │   ├── AdminLoginView.swift
│   │   ├── StudentLoginView.swift
│   │   └── StudentRegisterView.swift
│   ├── Student/
│   │   ├── HomeView.swift
│   │   ├── CalendarView.swift
│   │   ├── FavoritesView.swift
│   │   ├── AnnouncementsView.swift
│   │   └── ProfileView.swift
│   ├── Admin/
│   │   ├── AdminManagementView.swift
│   │   └── AdminReviewsView.swift
│   └── Components/
│       ├── MenuItemCard.swift
│       ├── CategoryChip.swift
│       └── ReviewDialog.swift
├── Campus_MenuApp.swift           # Ana uygulama entry point
└── ContentView.swift              # Root view + navigasyon
```

### Veri Depolama

Tüm veriler JSON formatında `Documents` dizininde saklanır:
- `students.json` - Öğrenci hesapları
- `menu_history.json` - Menü takvimi
- `reviews.json` - Değerlendirmeler
- `announcements.json` - Duyurular
- `preferences.json` - Kullanıcı tercihleri

## 🔐 Demo Hesaplar

### Yönetici
- **Email:** admin@campus.com
- **Şifre:** admin123

### Öğrenci
- **Email:** ogrenci@campus.com
- **Şifre:** 123456

## 🎨 Tema Sistemi

### 4 Renk Teması:
1. **Turuncu** (Varsayılan): #FF6B35 → #FF8C61
2. **Mavi**: #2196F3 → #42A5F5
3. **Yeşil**: #4CAF50 → #66BB6A
4. **Mor**: #9C27B0 → #AB47BC

### Karanlık Mod:
- Arka plan: #121212
- Kartlar: #1E1E1E / #2C2C2C
- Metin: #FFFFFF / #B0B0B0

**Özellik:** Tüm tema değişiklikleri ANINDA uygulanır (uygulama yeniden başlatma gerekmez).

## 🌍 Desteklenen Diller

- 🇹🇷 **Türkçe** (Varsayılan)
- 🇬🇧 **İngilizce**
- 🇩🇪 **Almanca**
- 🇫🇷 **Fransızca**

Dil değişiklikleri anlık olarak uygulanır.

## 🧪 Alerjenler

Uygulama 7 alerjen tipini destekler:
- 🌾 Gluten
- 🥛 Süt Ürünleri
- 🥚 Yumurta
- 🥜 Kuruyemiş
- 🫘 Soya
- 🐟 Balık
- 🦐 Kabuklu Deniz Ürünleri

Öğrenciler profil ayarlarından alerjenlerini seçebilir. Seçilen alerjenleri içeren yemekler ana ekranda otomatik olarak gizlenir.

## 📊 Veri Modelleri

### MenuCategory (6 Kategori)
- Kahvaltı 🍳
- Öğle Yemeği 🍽️
- Akşam Yemeği 🌙
- Çorba 🍜
- Atıştırmalık 🍪
- Tatlı 🍰

### MenuItem
```swift
id: String
name: String
category: MenuCategory
calories: Int
description: String?
allergens: [Allergen]
rating: Double       // 0.0-5.0 (1 ondalık basamak)
reviewCount: Int
```

### Review
```swift
id: String
studentId: String
studentName: String
menuItemId: String
menuItemName: String
rating: Int          // 1-5
comment: String?
date: Date
isApproved: Bool
adminResponse: String?
```

## 🛠️ Kurulum

1. **Xcode'da Projeyi Aç:**
   ```bash
   cd "Campus-Menu-IOS-v2"
   open "Campus Menu.xcodeproj"
   ```

2. **Dosyaları Xcode'a Ekle:**
   - Xcode'da sağ tık → "Add Files to 'Campus Menu'..."
   - Aşağıdaki klasörleri seç ve "Create groups" seçeneğini işaretle:
     - `Models/` klasörü
     - `Managers/` klasörü
     - `Views/` klasörünü (tüm alt klasörleriyle: Auth, Student, Admin, Components)

3. **Build & Run:**
   - Target: iOS 17.0+ Simulator veya Device
   - Command + R ile çalıştır

## 📦 Bağımlılıklar

**SIFIR BAĞIMLILIK!** 🎉

Bu uygulama tamamen yerel iOS SDK'sı ile geliştirilmiştir:
- SwiftUI (UI Framework)
- Combine (Reactive Programming)
- Foundation (JSON encoding/decoding, FileManager)

CocoaPods, SPM veya harici kütüphane gerektirmez.

## 🔄 Veri Akışı

### Öğrenci Akışı:
1. Rol seçimi (Öğrenci/Yönetici)
2. Login veya Register
3. Tab Bar Navigation:
   - Ana Sayfa (filtrelenmiş menüler)
   - Takvim (tarih seçimi)
   - Favoriler
   - Duyurular
   - Profil (ayarlar + çıkış)

### Yönetici Akışı:
1. Rol seçimi → Admin
2. Admin login (hardcoded: admin@campus.com/admin123)
3. Tab Bar Navigation:
   - Ana Sayfa
   - Takvim
   - **Yönetim** (menü CRUD)
   - **Değerlendirmeler** (onay + yanıtlama)
   - Duyurular
   - Profil

## 📝 Önemli Notlar

### İlk Çalışma
İlk açılışta örnek veriler otomatik oluşturulur:
- 7 günlük menü (bugün + 6 gün)
- 2 duyuru
- 1 demo öğrenci hesabı
- Her menü 8 yemek içerir

### Rating Sistemi
- Kullanıcılar 1-5 yıldız ve isteğe bağlı yorum gönderebilir
- Ortalama puan 1 ondalık basamakla hesaplanır (örn: 4.3)
- Admin yorumları onaylamalı veya yanıtlamalıdır

### JSON Depolama
- Tüm CRUD işlemleri `DataRepository.shared` üzerinden yapılır
- ObservableObject pattern sayesinde UI anında güncellenir
- ISO8601 tarih formatı kullanılır

## 🐛 Bilinen Sorunlar

Şu anda bilinen kritik hata bulunmamaktadır. Ancak aşağıdaki iyileştirmeler yapılabilir:
- [ ] Duyuru oluşturma (şu an sadece görüntüleme var)
- [ ] Profil fotoğrafı yükleme
- [ ] Push notification entegrasyonu
- [ ] iPad layout optimizasyonu

## 📄 Lisans

Bu proje eğitim amaçlı geliştirilmiştir.

## 👨‍💻 Geliştirici

Created with ❤️ using SwiftUI

---

**Son Güncelleme:** 06.12.2025  
**Versiyon:** 1.0.0  
**iOS Target:** 17.0+
