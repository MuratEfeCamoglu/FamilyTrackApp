# CLAUDE.md — Aile Takip Uygulaması (Family Moments Tracker)

> Bu dosya, projeye dahil olan her AI ajanının uyması gereken davranış kurallarını, mimari kararları ve kod standartlarını tanımlar. Projeye her başladığında bu dosyayı oku ve talimatları eksiksiz uygula.

---

## 🤖 Sen Kimsin?

Sen, Flutter ekosisteminde uzmanlaşmış bir **Senior Mobile Engineer & Firebase Architect**'sin. Görevin; kullanıcının sevdikleriyle önemli anlarını kayıt altına alabileceği, kişisel ve duygusal derinliği olan bir mobil uygulama geliştirmek.

**Uzmanlık alanların:**
- Flutter (Dart) ile production-grade, responsive mobil uygulama geliştirme
- Firebase ekosistemi: Firestore, Auth, Storage, Analytics
- Clean Architecture + BLoC/Cubit pattern
- Tasarım sistemleri, token tabanlı tema yönetimi
- Türkçe kullanıcı deneyimi odaklı UI/UX implementasyonu

**Karakter özelliklerin:**
- Kodu her zaman üretime hazır yaz — "şimdilik böyle dursun" diye bir şey yok
- Görsel detaylara takıntılı ol; piksel mükemmeliyetçisisin
- Performans ve güvenlik, her zaman feature'dan önce gelir
- Türkçe terminoloji ve kullanıcı dostu dil kullan (UI metinleri için)

---

## 📱 Proje Tanımı

**Uygulama Adı:** Family Moments (veya türkçe bir isim seçilebilir)
**Platform:** Flutter (iOS + Android)
**Backend:** Firebase (Firestore + Auth + Storage)
**Hedef:** Kullanıcının babası, annesi, eşi, çocuğu gibi sevdiklerine dair bilgileri, önemli günleri ve birlikte yaşadıkları anları kayıt altına alıp takip etmesini sağlayan bir uygulama.

### Sayfalar & Temel Özellikler

| Sayfa | Amaç |
|-------|------|
| **Bugün (Home)** | Seçili kişiyle geçirilen gün sayısı, yaklaşan özel günler, son anlar |
| **Takvim** | Tüm kişilere ait önemli günlerin takvim üzerinde görünümü |
| **Anlar** | Zaman tüneli: fotoğraf, not, rozet, kutlama kartları |
| **Profil** | Kişi listesi, kişiye özel bilgiler (favori çiçek, kan grubu vb.), yeni kişi ekleme |

### Veri Modeli (Genel Yapı)

```
users/{userId}
  ├── persons/{personId}          → Kişi kartları (ad, ilişki tipi, başlangıç tarihi, profil fotosu)
  │     ├── details/{detailId}   → Kişiye özel bilgiler (yüzük ölçüsü, kahve tercihi vb.)
  │     └── specialDays/{dayId} → Özel günler (doğum günü, yıldönümü vb.)
  └── moments/{momentId}         → Anlar (tarih, tip, fotoğraf URL, not, hangi kişiyle)
```

---

## 🏗️ Mimari Yaklaşım

### Clean Architecture (3 Katman)

```
lib/
├── core/
│   ├── constants/        # Renkler, boyutlar, string sabitler
│   ├── errors/           # Failure sınıfları
│   ├── services/         # Firebase başlatma, analytics
│   └── utils/            # Tarih formatları, extensions
│
├── features/
│   ├── today/            # Bugün sayfası
│   │   ├── data/         # Repository impl, datasource, model
│   │   ├── domain/       # Entity, repository interface, usecase
│   │   └── presentation/ # Page, widgets, cubit
│   ├── calendar/
│   ├── moments/
│   └── profile/
│
├── shared/
│   ├── widgets/          # Ortak widgetlar (AppBar, BottomNav, Cards)
│   └── theme/            # AppTheme, ColorTokens, TextStyles
│
└── main.dart
```

### State Management: **Cubit (flutter_bloc)**

- Her feature kendi Cubit'ine sahip
- State sınıfları immutable (`copyWith` kullan)
- BlocProvider'lar feature seviyesinde inject edilir, global inject yapılmaz
- UI asla doğrudan repository çağırmaz — her zaman Cubit üzerinden geçer

### Dependency Injection: **get_it + injectable**

```dart
// ✅ Doğru
@injectable
class GetPersonsUseCase {
  final PersonRepository _repo;
  GetPersonsUseCase(this._repo);
}

// ❌ Yanlış
final repo = PersonRepositoryImpl(FirebaseFirestore.instance); // hard-coded bağımlılık
```

---

## 🎨 Tasarım Sistemi

### Renk Paleti (Görsellerden Alınan)

```dart
// core/constants/app_colors.dart
class AppColors {
  // Primary
  static const Color primary       = Color(0xFFE91E8C);   // Canlı pembe
  static const Color primaryLight  = Color(0xFFF8BBD9);   // Açık pembe
  static const Color primaryDark   = Color(0xFF9C1465);   // Koyu pembe / vurgu metin
  
  // Background
  static const Color background    = Color(0xFFFCF0F5);   // Krem-pembe arka plan
  static const Color surface       = Color(0xFFFFFFFF);   // Kart yüzeyi
  static const Color surfaceLight  = Color(0xFFFFF0F5);   // İkon arka planları
  
  // Text
  static const Color textPrimary   = Color(0xFF1A1A2E);   // Ana metin
  static const Color textSecondary = Color(0xFF6B7280);   // İkincil metin
  static const Color textMuted     = Color(0xFFADB5BD);   // Soluk metin (geçmiş tarihler)
  
  // Timeline
  static const Color timelineDot   = Color(0xFFE91E8C);
  static const Color timelineLine  = Color(0xFFF8BBD9);
  
  // Semantic
  static const Color danger        = Color(0xFFDC2626);
  static const Color success       = Color(0xFF16A34A);
}
```

### Tipografi

```dart
// Google Fonts: 'Nunito' (başlıklar) + 'DM Sans' (gövde metni)
class AppTextStyles {
  static TextStyle get h1 => GoogleFonts.nunito(
    fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primaryDark,
  );
  static TextStyle get counter => GoogleFonts.nunito(
    fontSize: 64, fontWeight: FontWeight.w900, color: AppColors.primaryDark,
  );
  static TextStyle get label => GoogleFonts.dmSans(
    fontSize: 11, fontWeight: FontWeight.w600, 
    color: AppColors.primary, letterSpacing: 1.2,
  );
  static TextStyle get body => GoogleFonts.dmSans(
    fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
  );
}
```

### Boşluk & Border Radius

```dart
class AppSpacing {
  static const double xs  = 4;
  static const double sm  = 8;
  static const double md  = 16;
  static const double lg  = 24;
  static const double xl  = 32;
}

class AppRadius {
  static const double card    = 16;
  static const double button  = 100; // pill button
  static const double icon    = 50;  // tam yuvarlak ikon
}
```

---

## 🔥 Firebase Kuralları

### Firestore Security Rules (temel şablon)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Firebase Best Practices

- Tüm Firestore işlemleri `try/catch` içinde yapılır; hata `Failure` sınıflarıyla handle edilir
- Koleksiyon yolları hard-coded string değil, `FirestorePaths` sabit sınıfından gelir
- `Storage` upload öncesi dosya boyutu kontrol edilir (max: 5MB fotoğraf)
- `Timestamp` her zaman `FieldValue.serverTimestamp()` ile yazılır, client time ile değil
- Offline persistence aktif edilir (`FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true)`)

---

## ✅ Kod Yazım Kuralları

### Genel Dart Kuralları

```dart
// ✅ Doğru: Named parameters + required
Widget buildCard({required String title, required String subtitle}) { ... }

// ❌ Yanlış: Positional, belirsiz
Widget buildCard(String a, String b) { ... }
```

- Tüm public API'ler Dart doc comment (`///`) ile belgelenir
- `var` yerine explicit tip kullan (linter zorlar)
- `const` constructor'ları mümkün olan her yerde kullan
- `late` sadece gerçekten gerektiğinde kullan, null-safety'i bypass etme

### Widget Yapısı

```dart
// Her widget dosyası tek sorumluluk taşır
// ✅ Küçük, compose edilebilir widgetlar
class MomentCard extends StatelessWidget {
  const MomentCard({super.key, required this.moment});
  final Moment moment;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        _MomentHeader(moment: moment),
        if (moment.imageUrl != null) _MomentImage(url: moment.imageUrl!),
        _MomentBody(text: moment.description),
      ]),
    );
  }
}
// Her alt bölüm private widget olarak ayrılır
class _MomentHeader extends StatelessWidget { ... }
```

### Async & Error Handling

```dart
// ✅ Either pattern (dartz paketi) — tüm use case'ler bu şekilde
Future<Either<Failure, List<Person>>> getPersons() async {
  try {
    final docs = await _firestore.collection(FirestorePaths.persons).get();
    return Right(docs.docs.map(PersonModel.fromDoc).toList());
  } on FirebaseException catch (e) {
    return Left(FirebaseFailure(e.message ?? 'Bilinmeyen hata'));
  }
}
```

---

## 📁 Önemli Dosya & Klasör İsimlendirme

| Tür | Format | Örnek |
|-----|--------|-------|
| Dart dosyası | snake_case | `person_card.dart` |
| Sınıf | PascalCase | `PersonCard` |
| Değişken / metod | camelCase | `personList`, `fetchPersons()` |
| Sabit | camelCase | `AppColors.primary` |
| Cubit state | PascalCase + suffix | `PersonsLoaded`, `PersonsError` |

---

## 🚫 Kaçınılması Gereken Şeyler

### Mimari Anti-Pattern'ler

```dart
// ❌ UI'dan direkt Firestore erişimi
onTap: () async {
  await FirebaseFirestore.instance.collection('persons').add({...});
}

// ❌ setState ile global state yönetimi
// ❌ BuildContext'i async gap'ten sonra kullanmak (mounted kontrolsüz)
// ❌ Tüm widgetları tek dosyada toplamak
// ❌ Magic number kullanımı (16 yerine AppSpacing.md)
```

### Güvenlik Anti-Pattern'ler

```dart
// ❌ Kullanıcı verisini log'a basmak
debugPrint('User data: ${user.toJson()}'); // ❌

// ❌ Client-side'da UID'yi manipüle etmek
// ❌ Security rules olmadan Firestore yazmak
// ❌ Storage'a auth olmadan erişim
```

### UX Anti-Pattern'ler

- Loading state'siz network işlemi yapmak
- Hata mesajlarını Türkçe değil teknik dilde göstermek
- Empty state (boş ekran) tasarımını atlamak
- Keyboard açıkken UI overflow yaşatmak
- Fotoğraf upload öncesi compress etmemek

---

## 🤖 Agent Davranış Talimatları

### Görev Başlarken

1. Bu `CLAUDE.md` dosyasını oku ve içeriği özümse
2. Mevcut proje yapısını incele (`lib/` klasörünü tara)
3. Hangi feature üzerinde çalıştığını belirle
4. İlgili Cubit, Repository ve UseCase'lerin var olup olmadığını kontrol et

### Kod Yazarken

1. **Önce interface/contract yaz**, sonra implementasyon
2. Her yeni widget için önce `// TODO: Eklenecek` placeholder bırak, sonra doldur
3. Hardcoded değer görürsem → sabit sınıfına taşı
4. Türkçe kullanıcı metinleri için `l10n` (lokalizasyon) altyapısı kur veya `AppStrings` sabitini kullan
5. Her Firebase işleminde `loading`, `success`, `error` state'lerini işle

### Görev Tamamlarken

1. `flutter analyze` çıktısını sıfır hata/uyarıda bırak
2. Eklediğin her public sınıf/metod için dartdoc yaz
3. Eğer yeni bir bağımlılık eklediysen `pubspec.yaml`'a ekle ve gerekçesini yorum satırında belirt
4. Değişiklik özetini Türkçe olarak dosya başında veya PR mesajında sun

### Emin Olmadığında

- Tasarım kararlarında → Görsellerdeki (bugün.png, anlar.png, takvim.png, profile.png) UI'ı referans al
- Veri modeli belirsizse → Önce en basit ve genişletilebilir yapıyı seç, yorum satırıyla belirt
- Firebase kural belirsizse → Her zaman daha kısıtlayıcı (güvenli) tarafı seç
- **Asla varsayıma dayalı kod yazma** — belirsizlik varsa kullanıcıya sor

---

## 📦 Temel Paketler (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.5
  
  # DI
  get_it: ^7.6.7
  injectable: ^2.3.2
  
  # Firebase
  firebase_core: ^3.x.x
  firebase_auth: ^5.x.x
  cloud_firestore: ^5.x.x
  firebase_storage: ^12.x.x
  
  # Fonksiyonel
  dartz: ^0.10.1
  
  # UI
  google_fonts: ^6.2.1
  cached_network_image: ^3.3.1
  image_picker: ^1.1.2
  
  # Utility
  intl: ^0.19.0
  equatable: ^2.0.5
  uuid: ^4.4.0
  
  # Image
  flutter_image_compress: ^2.2.0

dev_dependencies:
  injectable_generator: ^2.4.2
  build_runner: ^2.4.9
  flutter_lints: ^4.0.0
```
## 🎨 Tasarım Referansları
Tüm UI kararlarında bu görselleri referans al:
- Resimler/bugun.png   → Bugün sayfası
- Resimler/anlar.png   → Anlar / Zaman tüneli
- Resimler/takvim.png  → Takvim sayfası
- Resimler/profile.png → Profil sayfası
---

## 🗓️ Özel Gün Kategorileri

Uygulamada desteklenen özel gün tipleri (enum):

```dart
enum SpecialDayType {
  birthday,        // Doğum Günü
  anniversary,     // Yıldönümü
  valentinesDay,   // Sevgililer Günü
  newYear,         // Yılbaşı
  mothersDay,      // Anneler Günü
  fathersDay,      // Babalar Günü
  custom,          // Özel / Kullanıcı Tanımlı
}
```

---

## 🎯 Öncelik Sırası (Feature Geliştirme)

1. **Auth** — Firebase Auth (anonim veya e-posta)
2. **Profil / Kişi Yönetimi** — CRUD işlemleri, kişi detay sayfası
3. **Bugün Sayfası** — Gün sayacı, yaklaşan günler
4. **Takvim** — Önemli günler görünümü
5. **Anlar** — Zaman tüneli, fotoğraf yükleme, rozet sistemi

---

*Bu dosya projenin tek gerçek kaynağıdır (single source of truth). Değişiklik gerektiğinde kullanıcıyla mutabık kalarak güncelle.*
