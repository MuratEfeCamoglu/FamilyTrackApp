# 🏠 FamilyTrackApp — Family Moments Tracker

> **🚧 Bu proje aktif geliştirme aşamasındadır. Katkı ve önerileriniz için PR açabilirsiniz.**

Sevdiklerinizle yaşadığınız özel anları, önemli günleri ve kişisel detayları tek bir yerde kayıt altına alın. **FamilyTrackApp**, ailenizi ve sevdiklerinizi merkezine alan, duygusal bir hafıza defteri mobil uygulamasıdır.

---

## 📱 Ekran Görüntüleri

| Bugün | Takvim | Anlar | Profil |
|-------|--------|-------|--------|
| Gün sayacı ve yaklaşan özel günler | Tüm kişilere ait etkinlik takvimi | Zaman tüneli — fotoğraf ve notlar | Kişi listesi ve detay kartları |

---

## ✨ Özellikler

- 👤 **Kişi Yönetimi** — Baba, anne, eş, çocuk gibi sevdiklerinize özel profil kartları oluşturun
- 📅 **Özel Gün Takibi** — Doğum günü, yıldönümü ve özel günleri otomatik hatırlatın
- 📸 **Anlar / Zaman Tüneli** — Fotoğraf, not ve rozetlerle anıları kaydedin
- 🗓️ **Takvim Görünümü** — Tüm önemli günleri tek bir takvimde görüntüleyin
- 🏠 **Bugün Sayfası** — Kişiyle kaç gün birlikte olduğunuzu ve yaklaşan özel günleri gösterir
- 🔒 **Güvenli Veri** — Firebase Auth + Firestore güvenlik kuralları ile kişisel veriler korunur
- 📴 **Çevrimdışı Destek** — Firestore offline persistence ile internet olmadan da çalışır

---

## 🛠️ Kullanılan Teknolojiler

### Platform & Dil
| Teknoloji | Sürüm | Açıklama |
|-----------|-------|----------|
| **Flutter** | ≥ 3.9 | iOS & Android cross-platform |
| **Dart** | ≥ 3.9.2 | Null-safe, statik tipli dil |

### Backend — Firebase
| Servis | Paket | Açıklama |
|--------|-------|----------|
| **Firebase Core** | `firebase_core ^3.6.0` | Firebase başlatma |
| **Firebase Auth** | `firebase_auth ^5.3.1` | Kullanıcı kimlik doğrulama |
| **Cloud Firestore** | `cloud_firestore ^5.4.4` | NoSQL bulut veritabanı |
| **Firebase Storage** | `firebase_storage ^12.3.2` | Fotoğraf ve medya depolama |

### Mimari & State Management
| Paket | Sürüm | Açıklama |
|-------|-------|----------|
| **flutter_bloc** | `^8.1.5` | BLoC/Cubit tabanlı state yönetimi |
| **get_it** | `^7.6.7` | Service locator (bağımlılık konteyneri) |
| **injectable** | `^2.3.2` | Kod üretimiyle dependency injection |
| **dartz** | `^0.10.1` | Either pattern — fonksiyonel hata yönetimi |
| **equatable** | `^2.0.5` | Value equality (state sınıfları için) |

### Navigasyon
| Paket | Sürüm | Açıklama |
|-------|-------|----------|
| **go_router** | `^17.2.3` | Bildirimsel, tip güvenli yönlendirme |

### UI & Tasarım
| Paket | Sürüm | Açıklama |
|-------|-------|----------|
| **google_fonts** | `^6.2.1` | Nunito (başlıklar) + DM Sans (gövde) |
| **flutter_animate** | `^4.5.2` | Mikro animasyonlar ve geçişler |
| **cached_network_image** | `^3.3.1` | Ağ görsellerini önbellekle yükler |
| **cupertino_icons** | `^1.0.8` | iOS stil ikonlar |

### Medya & Dosya
| Paket | Sürüm | Açıklama |
|-------|-------|----------|
| **image_picker** | `^1.1.2` | Galeriden / kameradan fotoğraf seçme |
| **flutter_image_compress** | `^2.2.0` | Upload öncesi max 5MB sıkıştırma |

### Yardımcı Araçlar
| Paket | Sürüm | Açıklama |
|-------|-------|----------|
| **intl** | `^0.20.2` | Tarih/saat formatlama, tr_TR yerelleştirme |
| **uuid** | `^4.4.0` | Benzersiz kimlik üretimi |
| **flutter_localizations** | SDK | Türkçe yerelleştirme desteği |

### Geliştirici Araçları
| Paket | Sürüm | Açıklama |
|-------|-------|----------|
| **injectable_generator** | `^2.4.2` | DI kodu üretimi |
| **build_runner** | `^2.4.9` | Kod üretim motoru |
| **flutter_lints** | `^4.0.0` | Dart/Flutter linting kuralları |

---

## 🏗️ Mimari

Proje **Clean Architecture** (3 katman) + **BLoC/Cubit** pattern ile geliştirilmektedir:

```
lib/
├── core/
│   ├── constants/        # AppColors, AppStrings, AppSpacing
│   ├── di/               # get_it + injectable bağımlılık ayarları
│   ├── errors/           # Failure sınıfları
│   ├── router/           # go_router yapılandırması
│   ├── services/         # Firebase başlatma, analytics
│   ├── usecases/         # Temel UseCase arayüzü
│   └── utils/            # Tarih formatları, Dart extensions
│
├── features/
│   ├── auth/             # Firebase kimlik doğrulama
│   ├── today/            # Bugün sayfası — gün sayacı
│   ├── calendar/         # Takvim görünümü
│   ├── moments/          # Anlar — zaman tüneli
│   └── profile/          # Profil — kişi yönetimi
│       ├── data/         # Repository impl, Firestore datasource, model
│       ├── domain/       # Entity, repository interface, use case
│       └── presentation/ # Page widget, alt widget'lar, Cubit
│
├── shared/
│   ├── widgets/          # Paylaşılan widget'lar (AppBar, Cards, vb.)
│   └── theme/            # AppTheme, renk token'ları, metin stilleri
│
└── main.dart
```

### Veri Modeli (Firestore)

```
users/{userId}
  ├── persons/{personId}          → Kişi kartları (ad, ilişki, başlangıç tarihi)
  │     ├── details/{detailId}   → Kişiye özel bilgiler (yüzük ölçüsü, kan grubu)
  │     └── specialDays/{dayId}  → Özel günler (doğum günü, yıldönümü)
  └── moments/{momentId}         → Anlar (tarih, tip, fotoğraf URL, not)
```

---

## 🎨 Tasarım Sistemi

**Renk Paleti:** Sıcak pembe tonlar (#E91E8C ana renk) üzerine kurulu, sevgi odaklı bir tema.

**Tipografi:**
- Başlıklar: **Nunito** (yumuşak, samimi)
- Gövde metni: **DM Sans** (okunabilir, modern)

**Tasarım Prensipleri:** Mikro animasyonlar, pill butonlar, yumuşak gölgeler ve krem-pembe arka plan ile premium bir deneyim hedeflenmektedir.

---

## 🚀 Kurulum & Çalıştırma

### Gereksinimler

- [Flutter SDK](https://flutter.dev/docs/get-started/install) ≥ 3.9
- [Firebase CLI](https://firebase.google.com/docs/cli)
- Android Studio / Xcode (platform bağlı)

### Adımlar

```bash
# 1. Repoyu klonlayın
git clone https://github.com/MuratEfeCamoglu/FamilyTrackApp.git
cd FamilyTrackApp/familytrackapp

# 2. Bağımlılıkları yükleyin
flutter pub get

# 3. Kod üretimini çalıştırın (injectable için)
dart run build_runner build --delete-conflicting-outputs

# 4. Firebase yapılandırmasını ekleyin
# google-services.json (Android) ve GoogleService-Info.plist (iOS)
# dosyalarını ilgili platform klasörlerine yerleştirin.

# 5. Uygulamayı başlatın
flutter run
```

---

## 📋 Feature Geliştirme Yol Haritası

| Öncelik | Feature | Durum |
|---------|---------|-------|
| 1 | 🔐 Firebase Auth (e-posta / anonim) | 🚧 Geliştiriliyor |
| 2 | 👤 Profil / Kişi Yönetimi (CRUD) | 🚧 Geliştiriliyor |
| 3 | 🏠 Bugün Sayfası — gün sayacı | 🚧 Geliştiriliyor |
| 4 | 🗓️ Takvim — önemli gün görünümü | ⏳ Planlandı |
| 5 | 📸 Anlar — zaman tüneli, fotoğraf | ⏳ Planlandı |

---

## 🤝 Katkıda Bulunma

1. Bu repoyu fork edin
2. Feature branch oluşturun: `git checkout -b feature/yeni-ozellik`
3. Değişikliklerinizi commit edin: `git commit -m 'feat: yeni özellik eklendi'`
4. Branch'i push edin: `git push origin feature/yeni-ozellik`
5. Pull Request açın

> Lütfen kod yazarken `CLAUDE.md` dosyasındaki mimari kararlar ve kod standartlarına uyun.

---

## 📄 Lisans

Bu proje özel kullanım amaçlıdır. Lisans bilgisi için proje sahibiyle iletişime geçin.

---

<p align="center">
  Sevdiklerinizle geçirdiğiniz her an değerlidir. 💖
</p>