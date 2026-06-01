import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:familytrackapp/core/constants/firestore_paths.dart';
import 'package:familytrackapp/features/profile/data/models/person_model.dart';
import 'package:familytrackapp/features/profile/data/models/person_detail_model.dart';
import 'package:familytrackapp/features/profile/data/models/special_day_model.dart';
import 'package:familytrackapp/core/constants/default_categories.dart';

/// Kişi verileri için Firestore veri kaynağı sözleşmesi.
abstract class PersonRemoteDatasource {
  Future<List<PersonModel>> getPersons({required String userId});
  Future<PersonModel> getPersonById({required String userId, required String personId});
  Future<PersonModel> addPerson({required String userId, required PersonModel model});
  Future<PersonModel> updatePerson({required String userId, required PersonModel model});
  Future<void> deletePerson({required String userId, required String personId});
  Future<List<PersonDetailModel>> getPersonDetails({required String userId, required String personId});
  Future<PersonDetailModel> addPersonDetail({required String userId, required String personId, required PersonDetailModel model});
  Future<void> deletePersonDetail({required String userId, required String personId, required String detailId});
  Future<List<SpecialDayModel>> getSpecialDays({required String userId, required String personId});
  Future<List<SpecialDayModel>> getAllSpecialDays({required String userId});
  Future<SpecialDayModel> addSpecialDay({required String userId, required String personId, required SpecialDayModel model});
  Future<SpecialDayModel> updateSpecialDay({required String userId, required String personId, required SpecialDayModel model});
  Future<void> deleteSpecialDay({required String userId, required String personId, required String specialDayId});
}

/// Firestore tabanlı kişi veri kaynağı implementasyonu.
///
/// CLAUDE.md §Firebase Best Practices:
/// - Koleksiyon yolları FirestorePaths'tan gelir.
/// - Tüm işlemler try/catch dışında; hataları repository katmanı yakalar.
@LazySingleton(as: PersonRemoteDatasource)
class PersonRemoteDatasourceImpl implements PersonRemoteDatasource {
  PersonRemoteDatasourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  // ── Kişiler ───────────────────────────────────────────

  @override
  Future<List<PersonModel>> getPersons({required String userId}) async {
    try {
      final snap = await _firestore
          .collection(FirestorePaths.personsCol(userId))
          .get();
      final models = snap.docs.map((d) => PersonModel.fromDoc(d)).toList();
      models.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return models;
    } catch (e) {
      debugPrint('Firestore getPersons offline cache fallback: $e');
      final snap = await _firestore
          .collection(FirestorePaths.personsCol(userId))
          .get(const GetOptions(source: Source.cache));
      final models = snap.docs.map((d) => PersonModel.fromDoc(d)).toList();
      models.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return models;
    }
  }

  @override
  Future<PersonModel> getPersonById({
    required String userId,
    required String personId,
  }) async {
    try {
      final doc = await _firestore
          .doc(FirestorePaths.personDoc(userId, personId))
          .get();
      return PersonModel.fromDoc(doc);
    } catch (e) {
      debugPrint('Firestore getPersonById offline cache fallback: $e');
      final doc = await _firestore
          .doc(FirestorePaths.personDoc(userId, personId))
          .get(const GetOptions(source: Source.cache));
      return PersonModel.fromDoc(doc);
    }
  }

  @override
  Future<PersonModel> addPerson({
    required String userId,
    required PersonModel model,
  }) async {
    final batch = _firestore.batch();
    
    // 1. Yeni kişiyi ekle
    final personRef = _firestore.collection(FirestorePaths.personsCol(userId)).doc();
    batch.set(personRef, model.toMap());
    
    // 2. Varsayılan kategorileri ekle
    final detailsCol = _firestore.collection(FirestorePaths.detailsCol(userId, personRef.id));
    for (var item in DefaultCategories.items) {
      final detailRef = detailsCol.doc();
      final detailMap = {
        'key': item['label'],
        'value': '',
        'icon': item['icon'],
        'createdAt': FieldValue.serverTimestamp(),
      };
      batch.set(detailRef, detailMap);
    }
    
    // Fire-and-forget: do not block on network
    batch.commit().catchError((e) {
      debugPrint('Firestore addPerson background sync error: $e');
    });
    
    return PersonModel(
      id: personRef.id,
      name: model.name,
      relationshipType: model.relationshipType,
      startDate: model.startDate,
      createdAt: DateTime.now(),
      profileImageUrl: model.profileImageUrl,
    );
  }

  @override
  Future<PersonModel> updatePerson({
    required String userId,
    required PersonModel model,
  }) async {
    final ref = _firestore.doc(FirestorePaths.personDoc(userId, model.id));
    // Fire-and-forget: do not block on network
    ref.update(model.toUpdateMap()).catchError((e) {
      debugPrint('Firestore updatePerson background sync error: $e');
    });
    return model;
  }

  @override
  Future<void> deletePerson({
    required String userId,
    required String personId,
  }) async {
    // Run the deletion in the background without blocking the UI
    _deletePersonBackground(userId, personId).catchError((e) {
      debugPrint('Firestore deletePerson background sync error: $e');
    });
  }

  Future<void> _deletePersonBackground(String userId, String personId) async {
    final batch = _firestore.batch();

    // 1. Person doc
    final personRef = _firestore.doc(FirestorePaths.personDoc(userId, personId));
    batch.delete(personRef);

    // 2. Details subcollection
    final detailsSnap = await _firestore.collection(FirestorePaths.detailsCol(userId, personId)).get();
    for (var doc in detailsSnap.docs) {
      batch.delete(doc.reference);
    }

    // 3. SpecialDays subcollection
    final sdSnap = await _firestore.collection(FirestorePaths.specialDaysCol(userId, personId)).get();
    for (var doc in sdSnap.docs) {
      batch.delete(doc.reference);
    }

    // 4. Moments containing this personId
    final momentsSnap = await _firestore.collection(FirestorePaths.momentsCol(userId))
        .where('personId', isEqualTo: personId).get();
    for (var doc in momentsSnap.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // ── Kişi Detayları ────────────────────────────────────

  @override
  Future<List<PersonDetailModel>> getPersonDetails({
    required String userId,
    required String personId,
  }) async {
    try {
      final snap = await _firestore
          .collection(FirestorePaths.detailsCol(userId, personId))
          .get();
      final models = snap.docs.map((d) => PersonDetailModel.fromDoc(d, personId)).toList();
      models.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return models;
    } catch (e) {
      debugPrint('Firestore getPersonDetails offline cache fallback: $e');
      final snap = await _firestore
          .collection(FirestorePaths.detailsCol(userId, personId))
          .get(const GetOptions(source: Source.cache));
      final models = snap.docs.map((d) => PersonDetailModel.fromDoc(d, personId)).toList();
      models.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return models;
    }
  }

  @override
  Future<PersonDetailModel> addPersonDetail({
    required String userId,
    required String personId,
    required PersonDetailModel model,
  }) async {
    final col = _firestore.collection(FirestorePaths.detailsCol(userId, personId));
    final ref = col.doc();
    // Fire-and-forget: do not block on network
    ref.set(model.toMap()).catchError((e) {
      debugPrint('Firestore addPersonDetail background sync error: $e');
    });
    return PersonDetailModel(
      id: ref.id,
      personId: personId,
      key: model.key,
      value: model.value,
      icon: model.icon,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> deletePersonDetail({
    required String userId,
    required String personId,
    required String detailId,
  }) async {
    _firestore
        .collection(FirestorePaths.detailsCol(userId, personId))
        .doc(detailId)
        .delete()
        .catchError((e) {
      debugPrint('Firestore deletePersonDetail background sync error: $e');
    });
  }

  // ── Özel Günler ───────────────────────────────────────

  @override
  Future<List<SpecialDayModel>> getSpecialDays({
    required String userId,
    required String personId,
  }) async {
    try {
      final snap = await _firestore
          .collection(FirestorePaths.specialDaysCol(userId, personId))
          .get();
      return snap.docs.map((d) => SpecialDayModel.fromDoc(d, personId)).toList();
    } catch (e) {
      debugPrint('Firestore getSpecialDays offline cache fallback: $e');
      final snap = await _firestore
          .collection(FirestorePaths.specialDaysCol(userId, personId))
          .get(const GetOptions(source: Source.cache));
      return snap.docs.map((d) => SpecialDayModel.fromDoc(d, personId)).toList();
    }
  }

  @override
  Future<List<SpecialDayModel>> getAllSpecialDays({required String userId}) async {
    // Tüm kişilerin özel günlerini collectionGroup ile tek sorguda çeker.
    try {
      final snap = await _firestore
          .collectionGroup(FirestorePaths.specialDays)
          .where('userId', isEqualTo: userId)
          .get();
      return snap.docs.map((d) {
        final pathSegments = d.reference.path.split('/');
        final pid = pathSegments[pathSegments.indexOf(FirestorePaths.persons) + 1];
        return SpecialDayModel.fromDoc(d, pid);
      }).toList();
    } catch (e) {
      debugPrint('Firestore getAllSpecialDays offline cache fallback: $e');
      final snap = await _firestore
          .collectionGroup(FirestorePaths.specialDays)
          .where('userId', isEqualTo: userId)
          .get(const GetOptions(source: Source.cache));
      return snap.docs.map((d) {
        final pathSegments = d.reference.path.split('/');
        final pid = pathSegments[pathSegments.indexOf(FirestorePaths.persons) + 1];
        return SpecialDayModel.fromDoc(d, pid);
      }).toList();
    }
  }

  @override
  Future<SpecialDayModel> addSpecialDay({
    required String userId,
    required String personId,
    required SpecialDayModel model,
  }) async {
    final map = model.toMap()..['userId'] = userId; // collectionGroup için
    final ref = _firestore
        .collection(FirestorePaths.specialDaysCol(userId, personId))
        .doc();
    // Fire-and-forget: do not block on network
    ref.set(map).catchError((e) {
      debugPrint('Firestore addSpecialDay background sync error: $e');
    });
    return SpecialDayModel(
      id: ref.id,
      personId: personId,
      title: model.title,
      type: model.type,
      date: model.date,
      isRecurring: model.isRecurring,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<SpecialDayModel> updateSpecialDay({
    required String userId,
    required String personId,
    required SpecialDayModel model,
  }) async {
    final ref = _firestore
        .collection(FirestorePaths.specialDaysCol(userId, personId))
        .doc(model.id);
    // Fire-and-forget: do not block on network
    ref.update(model.toUpdateMap()).catchError((e) {
      debugPrint('Firestore updateSpecialDay background sync error: $e');
    });
    return model;
  }

  @override
  Future<void> deleteSpecialDay({
    required String userId,
    required String personId,
    required String specialDayId,
  }) async {
    _firestore
        .collection(FirestorePaths.specialDaysCol(userId, personId))
        .doc(specialDayId)
        .delete()
        .catchError((e) {
      debugPrint('Firestore deleteSpecialDay background sync error: $e');
    });
  }
}
