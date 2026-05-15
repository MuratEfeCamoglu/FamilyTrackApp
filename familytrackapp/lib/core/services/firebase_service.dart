import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:familytrackapp/firebase_options.dart';

/// Firebase başlatma ve erişim servisi.
///
/// CLAUDE.md §Firebase Best Practices:
/// - Offline persistence aktif edilir.
/// - `Timestamp` işlemleri `FieldValue.serverTimestamp()` ile yapılır.
/// - Tüm işlemler `try/catch` ile `Failure`'a dönüştürülür.
class FirebaseService {
  FirebaseService._();

  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;

  /// Firebase'i başlatır ve Firestore offline persistence ayarlarını uygular.
  ///
  /// `main.dart` içinde `WidgetsFlutterBinding.ensureInitialized()` sonrası çağrılır.
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _configureFirestore();
    debugPrint('✅ Firebase başlatıldı');
  }

  /// Firestore offline persistence ve cache boyutu ayarları.
  static void _configureFirestore() {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      // 100 MB local cache — büyük aile albümleri için yeterli
      cacheSizeBytes: 104857600,
    );
  }

  /// Şu anda oturum açmış kullanıcının UID'si.
  /// Oturum yoksa `null` döner.
  static String? get currentUserId => auth.currentUser?.uid;

  /// Kullanıcının oturum açmış olup olmadığını kontrol eder.
  static bool get isAuthenticated => auth.currentUser != null;
}
