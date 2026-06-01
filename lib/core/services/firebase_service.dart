import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:familytrackapp/firebase_options.dart';

/// Firebase baslatma ve erisim servisi.
class FirebaseService {
  FirebaseService._();

  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;
  static bool _isInitialized = false;
  static Object? _lastInitError;

  /// Firebase'i baslatir ve Firestore ayarlarini uygular.
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _configureFirestore();
      _isInitialized = true;
      debugPrint('Firebase baslatildi');
    } catch (e) {
      _isInitialized = false;
      _lastInitError = e;
      debugPrint('Firebase baslatilamadi: $e');
      return;
    }
  }

  static void _configureFirestore() {
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: 104857600,
    );
  }

  /// E-posta/sifre ile giris yapar.
  static Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  /// E-posta/sifre ile yeni kullanici olusturur.
  static Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Cikis yapar.
  static Future<void> signOut() {
    return auth.signOut();
  }

  static String? get currentUserId => auth.currentUser?.uid;

  static bool get isAuthenticated {
    final user = auth.currentUser;
    if (user == null) return false;
    return !user.isAnonymous;
  }

  static bool get isInitialized => _isInitialized;

  static Object? get lastInitError => _lastInitError;
}
