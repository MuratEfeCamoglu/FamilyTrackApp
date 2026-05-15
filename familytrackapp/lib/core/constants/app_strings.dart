/// Uygulamada kullanilan tum Turkce UI metin sabitleri.
class AppStrings {
  AppStrings._();

  // Genel
  static const String appName = 'Aile Anlari';
  static const String loading = 'Yukleniyor...';
  static const String errorGeneric = 'Bir hata olustu. Lutfen tekrar deneyin.';
  static const String errorTitle = 'Hata';
  static const String retry = 'Tekrar Dene';
  static const String cancel = 'Iptal';
  static const String save = 'Kaydet';
  static const String delete = 'Sil';
  static const String edit = 'Duzenle';
  static const String confirm = 'Onayla';
  static const String close = 'Kapat';
  static const String add = 'Ekle';
  static const String continueText = 'Devam Et';

  // Alt Navigasyon
  static const String navToday = 'Bugun';
  static const String navCalendar = 'Takvim';
  static const String navMoments = 'Anlar';
  static const String navProfile = 'Profil';

  // Bugun
  static const String todayTitle = 'Bugun';
  static const String todayDayCounter = 'gundur birliktesiniz';
  static const String todayUpcomingDays = 'Yaklasan Ozel Gunler';
  static const String todayRecentMoments = 'Son Anlar';
  static const String todayNoUpcoming = 'Yaklasan ozel gun yok.';
  static const String todayNoMoments = 'Henuz bir an eklenmemis.';

  // Takvim
  static const String calendarTitle = 'Takvim';
  static const String calendarNoEvents = 'Bu gunde ozel bir etkinlik yok.';

  // Anlar
  static const String momentsTitle = 'Anlar';
  static const String momentsEmpty = 'Henuz bir aniniz yok.\nIlk ani ekleyin!';
  static const String momentsAddNew = 'Yeni An Ekle';
  static const String momentsAddFab = 'An Ekle';
  static const String momentsCountSuffix = 'an';
  static const String momentsNote = 'Not';
  static const String momentsPhoto = 'Fotograf';
  static const String momentsPhotoLabel = 'Fotograf';
  static const String momentsPhotoSelect = 'Fotograf Sec';
  static const String momentsPhotoChange = 'Fotografi Degistir';
  static const String momentsPersonLabel = 'Kisi';
  static const String momentsTypeLabel = 'An Turu';
  static const String momentsTitleLabel = 'Baslik';
  static const String momentsTitleHint = 'Bu anin basligi...';
  static const String momentsBadgeLabel = 'Rozet Adi';
  static const String momentsBadgeHint = 'Orn: 1 Yil Birliktelik';
  static const String momentsDescriptionLabel = 'Aciklama (Istege bagli)';
  static const String momentsDescriptionHint = 'Ne hissettiniz?';
  static const String momentsDateLabel = 'Tarih';
  static const String momentsNiceMoment = 'GUZEL BIR AN';
  static const String momentsEmptyTitle = 'Henuz an yok';
  static const String momentsEmptyDescription =
      'Ilk once Profil sekmesinden\nbir kisi ekleyin,\nsonra + butonuyla an kaydedin.';
  static const String momentsDeleteTitle = 'Ani sil';
  static const String momentsBadgeWon = 'ROZET KAZANILDI';

  static String momentsDeleteDescription(String title) =>
      '"$title" anisini silmek istiyor musunuz?';

  // Profil
  static const String profileTitle = 'Profil';
  static const String profilePersonList = 'Sevdiklerim';
  static const String profileAddPerson = 'Kisi Ekle';
  static const String profileNoPersons = 'Henuz kimse eklenmemis.';
  static const String profileDetails = 'Kisisel Bilgiler';
  static const String profileSpecialDays = 'Ozel Gunler';
  static const String profileAddDetail = 'Bilgi Ekle';
  static const String profileAddSpecialDay = 'Ozel Gun Ekle';
  static const String profileAddShort = 'Yeni Ekle';
  static const String profileEmptyTitle = 'Henuz kimse yok';
  static const String profileEmptyDescription =
      'Sevdiklerinizi ekleyerek\nanilarinizi kaydetmeye baslayin.';
  static const String profileDeleteTitle = 'Kisiyi sil';

  static String profileSavedCount(int count) => '$count kisi kaydedildi';

  static String profileDeleteDescription(String name) =>
      '"$name" adli kisiyi ve tum bilgilerini silmek istediginize emin misiniz?';

  // Kisi Detay
  static const String detailTogether = 'Birlikte';
  static const String detailStartDate = 'Baslangic';
  static const String detailAddNew = 'Yeni Bilgi Ekle';
  static const String detailIcon = 'Ikon';
  static const String detailTitle = 'Bilgi Basligi';
  static const String detailTitleHint = 'Orn: Favori Cicek, Kan Grubu';
  static const String detailValue = 'Deger';
  static const String detailValueHint = 'Orn: Gul, A Rh+';
  static const String detailEmptyTitle = 'Henuz bilgi yok';
  static const String detailEmptyDescription =
      'Favori cicegi, kan grubu, kahve tercihi...\nBilgi Ekle butonuna tiklayarak baslayin.';
  static const String detailFillAllFields = 'Lutfen tum alanlari doldurun.';
  static const String detailDeleteTitle = 'Bilgiyi sil';

  static String detailDeleteDescription(String key) =>
      '"$key" bilgisini silmek istediginize emin misiniz?';

  // Kisi ekleme
  static const String addPersonTitle = 'Yeni Kisi Ekle';
  static const String addPersonPhotoSoon = 'Fotograf secimi yakinda eklenecek!';
  static const String addPersonPhoto = 'Fotograf Ekle';
  static const String addPersonName = 'Ad Soyad';
  static const String addPersonNameHint = 'Orn: Annem, Ahmet, Canim';
  static const String addPersonNameRequired = 'Lutfen bir isim girin.';
  static const String addPersonNameMin = 'Isim en az 2 karakter olmalidir.';
  static const String addPersonRelationType = 'Iliski Turu';
  static const String addPersonStartDate = 'Birliktelik Baslangic Tarihi';
  static const String addPersonStartDateHint =
      'Tanistiginiz veya birlikte olmaya basladiginiz tarih';

  // Ozel gun tipleri
  static const String dayBirthday = 'Dogum Gunu';
  static const String dayAnniversary = 'Yildonumu';
  static const String dayValentines = 'Sevgililer Gunu';
  static const String dayNewYear = 'Yilbasi';
  static const String dayMothers = 'Anneler Gunu';
  static const String dayFathers = 'Babalar Gunu';
  static const String dayCustom = 'Ozel Gun';

  // Hata mesajlari
  static const String errorNetwork = 'Internet baglantisi yok.';
  static const String errorNotFound = 'Istenen icerik bulunamadi.';
  static const String errorPermission = 'Bu islem icin yetkiniz yok.';
  static const String errorPhotoSize = 'Fotograf boyutu 5 MB\'i gecemez.';
  static const String errorAuthRequired =
      'Bu islem icin giris yapmaniz gerekiyor.';
  static const String errorMomentTitleRequired = 'Lutfen bir baslik girin.';
  static const String errorLoginFailed =
      'Giris yapilamadi. Lutfen tekrar deneyin.';

  // Basari mesajlari
  static const String successSaved = 'Basariyla kaydedildi.';
  static const String successDeleted = 'Basariyla silindi.';
  static const String successPhotoUploaded = 'Fotograf yuklendi.';

  // Giris
  static const String loginTitle = 'Hos Geldiniz';
  static const String loginSubtitle =
      'Anilarinizi kaydetmek ve sevdiklerinizi takip etmek icin giris yapin.';
  static const String loginEmailHint = 'E-posta';
  static const String loginPasswordHint = 'Sifre';
  static const String loginButton = 'Giris Yap';
  static const String loginRegisterButton = 'Kayit Ol';
  static const String loginSwitchToRegister = 'Hesabin yok mu? Kayit ol';
  static const String loginSwitchToLogin = 'Zaten hesabin var mi? Giris yap';
  static const String loginEmailRequired = 'Lutfen e-posta girin.';
  static const String loginEmailInvalid = 'Gecerli bir e-posta girin.';
  static const String loginPasswordRequired = 'Lutfen sifre girin.';
  static const String loginPasswordMin = 'Sifre en az 6 karakter olmali.';
  static const String loginErrorUserNotFound = 'Kullanici bulunamadi.';
  static const String loginErrorInvalidCredential =
      'E-posta veya sifre hatali.';
  static const String loginErrorEmailInUse = 'Bu e-posta zaten kayitli.';
}
