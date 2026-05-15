import 'package:equatable/equatable.dart';

/// Uygulama genelinde kullanılan hata (failure) sınıfları.
///
/// CLAUDE.md: Tüm hata yönetimi `Failure` hiyerarşisi üzerinden yapılır.
/// Repository'ler `Either<Failure, T>` döndürür.
abstract class Failure extends Equatable {
  /// Kullanıcıya gösterilecek Türkçe hata mesajı.
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Firebase kaynaklı hatalar (Firestore, Auth, Storage).
class FirebaseFailure extends Failure {
  const FirebaseFailure(super.message);
}

/// Kimlik doğrulama (auth) hataları.
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Ağ bağlantısı hataları.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'İnternet bağlantısı yok.']);
}

/// Veri bulunamadı hatası.
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'İstenen içerik bulunamadı.']);
}

/// Yetki / erişim hataları.
class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Bu işlem için yetkiniz yok.']);
}

/// Geçersiz veri / doğrulama hataları.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Fotoğraf boyut sınırı aşıldı.
class FileSizeFailure extends Failure {
  const FileSizeFailure([super.message = 'Fotoğraf boyutu 5 MB\'ı geçemez.']);
}

/// Beklenmedik / bilinmeyen hatalar.
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Beklenmedik bir hata oluştu.']);
}
