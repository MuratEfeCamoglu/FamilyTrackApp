// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// ⚠️  PLACEHOLDER — Gerçek değerleri FlutterFire CLI ile doldur!
///
/// Kurulum adımları:
/// ```bash
/// dart pub global activate flutterfire_cli
/// flutterfire configure --project=YOUR_PROJECT_ID
/// ```
/// Bu komut bu dosyayı otomatik olarak doğru değerlerle yeniden yazar.
///
/// Manuel doldurma:
/// Firebase Console → Proje Ayarları → Uygulamalar bölümünden
/// `google-services.json` (Android) ve `GoogleService-Info.plist` (iOS) indir,
/// değerleri aşağıdaki alanlara kopyala.
class DefaultFirebaseOptions {
  DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) throw _unsupported('Web');
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw _unsupported('macOS');
      case TargetPlatform.windows:
        throw _unsupported('Windows');
      case TargetPlatform.linux:
        throw _unsupported('Linux');
      default:
        throw _unsupported('Unknown');
    }
  }

  // ── Android ───────────────────────────────────────────
  /// google-services.json → client[0].api_key[0].current_key
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'YOUR_ANDROID_API_KEY',
    // google-services.json → client[0].client_info.mobilesdk_app_id
    appId: 'YOUR_ANDROID_APP_ID',
    // google-services.json → project_info.project_number
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    // google-services.json → project_info.project_id
    projectId: 'YOUR_PROJECT_ID',
    // google-services.json → project_info.storage_bucket
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
  );

  // ── iOS ───────────────────────────────────────────────
  /// GoogleService-Info.plist → API_KEY
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    // GoogleService-Info.plist → GOOGLE_APP_ID
    appId: 'YOUR_IOS_APP_ID',
    // GoogleService-Info.plist → GCM_SENDER_ID
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    // GoogleService-Info.plist → PROJECT_ID
    projectId: 'YOUR_PROJECT_ID',
    // GoogleService-Info.plist → STORAGE_BUCKET
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    // GoogleService-Info.plist → BUNDLE_ID
    iosBundleId: 'com.example.familytrackapp',
  );

  static UnsupportedError _unsupported(String platform) =>
      UnsupportedError('Bu platform desteklenmiyor: $platform');
}
