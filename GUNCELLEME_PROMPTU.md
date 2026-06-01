# 🛠️ Codex Promptu — UI & Özellik Güncellemeleri

> Bu promptu Claude Code'a veya Codex'e ver. CLAUDE.md projenin kök dizininde olmalı.
> Her değişiklik bağımsız, sırayla uygula.

---

```
CLAUDE.md dosyasını oku. Aşağıdaki 5 değişikliği sırayla uygula.
Her birini bitirince "✅ [Değişiklik adı] tamamlandı" yaz, sonra devam et.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DEĞİŞİKLİK 1 — RENK PALETİ: PEMBEDen GRİ/BEYAZA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

core/constants/app_colors.dart dosyasını tamamen yeniden yaz.
Pembe renk sistemini kaldır, aşağıdaki gri/beyaz paleti uygula:

```dart
class AppColors {
  // Primary — koyu antrasit/grafite
  static const Color primary       = Color(0xFF1C1C1E);  // neredeyse siyah
  static const Color primaryLight  = Color(0xFF3A3A3C);  // orta gri
  static const Color primaryMuted  = Color(0xFF8E8E93);  // soluk gri (label, ikon)

  // Background
  static const Color background    = Color(0xFFF2F2F7);  // iOS sistem gri
  static const Color surface       = Color(0xFFFFFFFF);  // kart yüzeyi
  static const Color surfaceAlt    = Color(0xFFE5E5EA);  // ayırıcı, input bg

  // Text
  static const Color textPrimary   = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF6C6C70);
  static const Color textMuted     = Color(0xFFAEAEB2);

  // Accent — tek renk vurgu (ince gri-mavi, nötr)
  static const Color accent        = Color(0xFF636366);

  // Timeline
  static const Color timelineDot   = Color(0xFF1C1C1E);
  static const Color timelineLine  = Color(0xFFD1D1D6);

  // Semantic
  static const Color danger        = Color(0xFFFF3B30);  // iOS kırmızı (silme)
  static const Color success       = Color(0xFF34C759);  // iOS yeşil
  static const Color divider       = Color(0xFFE5E5EA);
}
```

Sonra projedeki HER dosyayı tara:
- AppColors.primary → güncellendi (otomatik yansır)
- Hardcoded Color(0xFFE91E8C) veya Colors.pink geçen her yeri AppColors ile değiştir
- BottomNav aktif sekme: pembe yuvarlak yerine koyu gri (AppColors.primary) yuvarlak
- FAB butonu: pembe yerine AppColors.primary (koyu)
- Butonlar: outlined → border AppColors.primaryLight, filled → AppColors.primary

AppTheme'i de güncelle: colorScheme seed'i pembe yerine gri tabanlı yap.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DEĞİŞİKLİK 2 — PROFİL: KİŞİ SİLME
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

A) Domain katmanı:
   - PersonRepository interface'e `deletePerson(String personId)` metodu ekle
   - DeletePersonUseCase oluştur (person silinince ona ait tüm moments ve specialDays da silinsin — Firestore batch write kullan)

B) Data katmanı:
   - PersonRepositoryImpl'e deletePerson implementasyonu yaz
   - Batch içinde şu koleksiyonları sil:
     /users/{uid}/persons/{personId}
     /users/{uid}/persons/{personId}/details (subcollection)
     /users/{uid}/persons/{personId}/specialDays (subcollection)
     /users/{uid}/moments (personId == personId olanlar)

C) Presentation katmanı:
   ProfileCubit'e deletePersonRequested(String personId) eventi ekle.
   
   PersonDetailPage'de:
   - AppBar'a çöp kutusu ikonu ekle (Icons.delete_outline)
   - Tıklanınca şu confirmation dialog'u göster:
     Başlık: "Kişiyi Sil"
     İçerik: "[İsim] ve bu kişiye ait tüm anlar kalıcı olarak silinecek. Emin misin?"
     Butonlar: "Vazgeç" (outlined) | "Sil" (AppColors.danger rengi, dolu)
   - Onaylanırsa deletePerson çağır, başarılı olunca ProfilePage'e pop et

   PersonListPage (kişi grid'i) üzerinde:
   - Kişi kartına uzun basma (long press) → aynı confirmation dialog'u göster

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DEĞİŞİKLİK 3 — PROFİL: DEFAULT 10 KATEGORİ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

A) core/constants/default_categories.dart dosyası oluştur:

```dart
class DefaultCategories {
  static const List<Map<String, String>> items = [
    {'key': 'favoriteCoffee',  'label': 'Kahve Tercihi',    'icon': 'coffee'},
    {'key': 'favoriteFlower',  'label': 'En Sevdiği Çiçek', 'icon': 'flower'},
    {'key': 'ringSize',        'label': 'Yüzük Ölçüsü',     'icon': 'ring'},
    {'key': 'bloodType',       'label': 'Kan Grubu',         'icon': 'blood'},
    {'key': 'favoriteFood',    'label': 'En Sevdiği Yemek',  'icon': 'food'},
    {'key': 'favoriteDessert', 'label': 'En Sevdiği Tatlı',  'icon': 'cake'},
    {'key': 'favoriteArtist',  'label': 'Sanatçı / Müzik',   'icon': 'music'},
    {'key': 'shoeSize',        'label': 'Ayakkabı Numarası', 'icon': 'shoe'},
    {'key': 'allergy',         'label': 'Önemli Not / Alerji','icon': 'warning'},
    {'key': 'hobby',           'label': 'Hobi',              'icon': 'hobby'},
  ];
}
```

B) AddPersonUseCase veya PersonRepositoryImpl'de:
   Yeni kişi oluşturulunca DefaultCategories.items listesini döngüye al,
   her biri için value boş string olan PersonDetail belgesi oluştur
   ve persons/{personId}/details subcollection'ına batch write ile kaydet.

C) PersonDetailPage'de:
   - Boş kategoriler de gösterilsin (value == '' ise kart içinde "Ekle" yazısı ve soluk stil)
   - Kullanıcı boş kategori kartına tıklayınca düzenleme bottom sheet'i açılsın
   - "Yeni Kategori Ekle" butonu kalsın (custom kategori eklemek için)
   - Custom kategoride kullanıcı hem label hem value girer

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DEĞİŞİKLİK 4 — ANLAR: TAM FONKSİYONEL
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

A) MomentType enum'unu tanımla (zaten yoksa):
   badge (Rozet), memory (Güzel Bir An), celebration (Kutlama), note (Not)

B) MomentRepositoryImpl — eksiksiz yaz:
   - getMonuments(String? personId): Stream<List<Moment>> — realtime listener
   - addMoment(Moment moment, File? imageFile): Future<Either<Failure, void>>
     → imageFile varsa Storage'a yükle, URL'i moment'a ekle, sonra Firestore'a yaz
   - deleteMoment(String momentId): Future<Either<Failure, void>>

C) MomentsCubit:
   States: MomentsInitial, MomentsLoading, MomentsLoaded(moments), MomentsError
   Events: loadMoments, addMoment, deleteMoment

D) MomentsPage (zaman tüneli UI):
   - Stream ile anlık güncelleme (StreamBuilder veya Cubit stream)
   - Zaman çizgisi solda, tarih etiketi + içerik kartı sağda
   - Kart tipine göre farklı ikon (badge→madalya, memory→kamera, celebration→pasta, note→kalem)
   - Karta uzun basma → silme onay dialog'u

E) An Ekleme Bottom Sheet (FAB'a tıklayınca):
   Alanlar:
   1. Tip seçimi (4 chip: Rozet / An / Kutlama / Not)
   2. Kişi seçimi (dropdown — profiles'tan gelsin)
   3. Başlık (text field)
   4. Açıklama (multiline text field)
   5. Tarih seçici (date picker, default bugün)
   6. Fotoğraf ekle (sadece "An" ve "Kutlama" tiplerinde görünsün)
      → image_picker ile galeri/kamera seçimi
      → flutter_image_compress ile %70 kaliteye sıkıştır
   
   "Kaydet" butonu → MomentsCubit.addMoment() çağır
   Loading sırasında butonu disable et, CircularProgressIndicator göster

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DEĞİŞİKLİK 5 — TAKVİM & BUGÜN: ÖZEL GÜNLER
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

A) core/constants/national_holidays.dart oluştur.
   Sabit (her yıl tekrar eden) özel günler listesi:

```dart
class NationalHolidays {
  static List<SpecialDay> getForYear(int year) => [
    // Milli Bayramlar
    SpecialDay(id:'ny',   title:'Yılbaşı',                  date: DateTime(year,1,1),  type: SpecialDayType.nationalHoliday),
    SpecialDay(id:'feb',  title:'Sevgililer Günü',           date: DateTime(year,2,14), type: SpecialDayType.valentinesDay),
    SpecialDay(id:'apr',  title:'Ulusal Egemenlik ve Çocuk Bayramı', date: DateTime(year,4,23), type: SpecialDayType.nationalHoliday),
    SpecialDay(id:'may1', title:'Emek ve Dayanışma Günü',   date: DateTime(year,5,1),  type: SpecialDayType.nationalHoliday),
    SpecialDay(id:'may19',title:'Atatürk\'ü Anma ve Gençlik Bayramı', date: DateTime(year,5,19), type: SpecialDayType.nationalHoliday),
    SpecialDay(id:'mothd',title:'Anneler Günü',              date: _secondSundayOfMay(year), type: SpecialDayType.other),
    SpecialDay(id:'jul15',title:'Demokrasi ve Milli Birlik Günü', date: DateTime(year,7,15), type: SpecialDayType.nationalHoliday),
    SpecialDay(id:'aug30',title:'Zafer Bayramı',             date: DateTime(year,8,30), type: SpecialDayType.nationalHoliday),
    SpecialDay(id:'oct29',title:'Cumhuriyet Bayramı',        date: DateTime(year,10,29),type: SpecialDayType.nationalHoliday),
  ];
}
```

B) SpecialDayType enum'unu güncelle:
   birthday, anniversary, valentinesDay, newYear,
   nationalHoliday, mothersDay, fathersDay, custom

C) CalendarCubit güncelle:
   - loadDays(int year, int month) çağrılınca:
     1. Firestore'dan o kullanıcının kişisel özel günlerini çek
     2. NationalHolidays.getForYear(year) listesini al
     3. İkisini birleştir → CalendarLoaded(days: [...]) emit et
   
   - Takvim grid'inde nokta rengi:
     • NationalHoliday → AppColors.accent (gri vurgu)
     • Kişisel (birthday, anniversary) → AppColors.primary (koyu)

D) CalendarPage önemli günler listesi:
   Her öğede sol tarafta tip etiketine göre ikon:
   🎂 Doğum Günü | ❤️ Yıldönümü | 🎉 Kutlama | 🏳️ Milli Bayram | 💝 Sevgililer
   
   Listeyi iki bölüme ayır:
   "Kişisel Günler" → Firestore'dan gelenler (kişi adı da göster)
   "Genel Günler"   → NationalHolidays'den gelenler

E) TodayPage — Yaklaşan Günler bölümü:
   - Hem kişisel özel günleri hem milli bayramları birleştir
   - Tarihe göre sırala, en yakın 5 tanesini göster
   - "X gün kaldı" hesabı: bugünden o güne kaç gün var
   - Geçmiş günleri (bu yıl geçtiyse) gelecek yıla çevir
   - Filtre chip'leri ekle: "Tümü | Kişisel | Milli Bayramlar"

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
SON KONTROL
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Tüm değişiklikler tamamlanınca:
1. flutter analyze çalıştır — sıfır hata/uyarı olmalı
2. Kalan pembe renk var mı tara (0xFFE91E8C, Colors.pink, Colors.pinkAccent)
3. Eksik import varsa ekle
4. Türkçe özet ver: ne değişti, dikkat edilmesi gereken var mı?
```
