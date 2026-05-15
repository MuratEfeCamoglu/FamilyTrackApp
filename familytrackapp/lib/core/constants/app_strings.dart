/// Uygulamada kullanılan tüm Türkçe UI metin sabitleri.
///
/// CLAUDE.md kural: Hardcoded string yerine bu sabitler kullanılır.
/// İleride l10n (lokalizasyon) altyapısına geçiş buradan kolayca yapılır.
class AppStrings {
  AppStrings._();

  // ── Genel ────────────────────────────────────────────
  static const String appName = 'Aile Anları';
  static const String loading = 'Yükleniyor…';
  static const String errorGeneric = 'Bir hata oluştu. Lütfen tekrar deneyin.';
  static const String retry = 'Tekrar Dene';
  static const String cancel = 'İptal';
  static const String save = 'Kaydet';
  static const String delete = 'Sil';
  static const String edit = 'Düzenle';
  static const String confirm = 'Onayla';
  static const String close = 'Kapat';
  static const String add = 'Ekle';

  // ── Alt Navigasyon ────────────────────────────────────
  static const String navToday = 'Bugün';
  static const String navCalendar = 'Takvim';
  static const String navMoments = 'Anlar';
  static const String navProfile = 'Profil';

  // ── Bugün Sayfası ─────────────────────────────────────
  static const String todayTitle = 'Bugün';
  static const String todayDayCounter = 'gündür birliktesiniz';
  static const String todayUpcomingDays = 'Yaklaşan Özel Günler';
  static const String todayRecentMoments = 'Son Anlar';
  static const String todayNoUpcoming = 'Yaklaşan özel gün yok.';
  static const String todayNoMoments = 'Henüz bir an eklenmemiş.';

  // ── Takvim Sayfası ────────────────────────────────────
  static const String calendarTitle = 'Takvim';
  static const String calendarNoEvents = 'Bu günde özel bir etkinlik yok.';

  // ── Anlar Sayfası ─────────────────────────────────────
  static const String momentsTitle = 'Anlar';
  static const String momentsEmpty = 'Henüz bir anınız yok.\nİlk anı ekleyin!';
  static const String momentsAddNew = 'Yeni An Ekle';
  static const String momentsNote = 'Not';
  static const String momentsPhoto = 'Fotoğraf';

  // ── Profil Sayfası ────────────────────────────────────
  static const String profileTitle = 'Profil';
  static const String profilePersonList = 'Sevdiklerim';
  static const String profileAddPerson = 'Kişi Ekle';
  static const String profileNoPersons = 'Henüz kimse eklenmemiş.';
  static const String profileDetails = 'Kişisel Bilgiler';
  static const String profileSpecialDays = 'Özel Günler';
  static const String profileAddDetail = 'Bilgi Ekle';
  static const String profileAddSpecialDay = 'Özel Gün Ekle';

  // ── Özel Gün Türleri ─────────────────────────────────
  static const String dayBirthday = 'Doğum Günü';
  static const String dayAnniversary = 'Yıldönümü';
  static const String dayValentines = 'Sevgililer Günü';
  static const String dayNewYear = 'Yılbaşı';
  static const String dayMothers = 'Anneler Günü';
  static const String dayFathers = 'Babalar Günü';
  static const String dayCustom = 'Özel Gün';

  // ── Hata Mesajları ────────────────────────────────────
  static const String errorNetwork = 'İnternet bağlantısı yok.';
  static const String errorNotFound = 'İstenen içerik bulunamadı.';
  static const String errorPermission = 'Bu işlem için yetkiniz yok.';
  static const String errorPhotoSize = 'Fotoğraf boyutu 5 MB\'ı geçemez.';
  static const String errorAuthRequired = 'Bu işlem için giriş yapmanız gerekiyor.';

  // ── Başarı Mesajları ──────────────────────────────────
  static const String successSaved = 'Başarıyla kaydedildi.';
  static const String successDeleted = 'Başarıyla silindi.';
  static const String successPhotoUploaded = 'Fotoğraf yüklendi.';
}
