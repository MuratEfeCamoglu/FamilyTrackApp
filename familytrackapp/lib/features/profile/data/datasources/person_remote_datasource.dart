import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:familytrackapp/core/constants/firestore_paths.dart';
import 'package:familytrackapp/features/profile/data/models/person_model.dart';
import 'package:familytrackapp/features/profile/data/models/person_detail_model.dart';
import 'package:familytrackapp/features/profile/data/models/special_day_model.dart';

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
    final snap = await _firestore
        .collection(FirestorePaths.personsCol(userId))
        .orderBy('createdAt', descending: false)
        .get();
    return snap.docs.map((d) => PersonModel.fromDoc(d)).toList();
  }

  @override
  Future<PersonModel> getPersonById({
    required String userId,
    required String personId,
  }) async {
    final doc = await _firestore
        .doc(FirestorePaths.personDoc(userId, personId))
        .get();
    return PersonModel.fromDoc(doc);
  }

  @override
  Future<PersonModel> addPerson({
    required String userId,
    required PersonModel model,
  }) async {
    final col = _firestore.collection(FirestorePaths.personsCol(userId));
    final ref = await col.add(model.toMap());
    final snap = await ref.get();
    return PersonModel.fromDoc(snap);
  }

  @override
  Future<PersonModel> updatePerson({
    required String userId,
    required PersonModel model,
  }) async {
    final ref = _firestore.doc(FirestorePaths.personDoc(userId, model.id));
    await ref.update(model.toUpdateMap());
    final snap = await ref.get();
    return PersonModel.fromDoc(snap);
  }

  @override
  Future<void> deletePerson({
    required String userId,
    required String personId,
  }) async {
    await _firestore
        .doc(FirestorePaths.personDoc(userId, personId))
        .delete();
  }

  // ── Kişi Detayları ────────────────────────────────────

  @override
  Future<List<PersonDetailModel>> getPersonDetails({
    required String userId,
    required String personId,
  }) async {
    final snap = await _firestore
        .collection(FirestorePaths.detailsCol(userId, personId))
        .orderBy('createdAt')
        .get();
    return snap.docs.map((d) => PersonDetailModel.fromDoc(d, personId)).toList();
  }

  @override
  Future<PersonDetailModel> addPersonDetail({
    required String userId,
    required String personId,
    required PersonDetailModel model,
  }) async {
    final col = _firestore.collection(FirestorePaths.detailsCol(userId, personId));
    final ref = await col.add(model.toMap());
    final snap = await ref.get();
    return PersonDetailModel.fromDoc(snap, personId);
  }

  @override
  Future<void> deletePersonDetail({
    required String userId,
    required String personId,
    required String detailId,
  }) async {
    await _firestore
        .collection(FirestorePaths.detailsCol(userId, personId))
        .doc(detailId)
        .delete();
  }

  // ── Özel Günler ───────────────────────────────────────

  @override
  Future<List<SpecialDayModel>> getSpecialDays({
    required String userId,
    required String personId,
  }) async {
    final snap = await _firestore
        .collection(FirestorePaths.specialDaysCol(userId, personId))
        .get();
    return snap.docs.map((d) => SpecialDayModel.fromDoc(d, personId)).toList();
  }

  @override
  Future<List<SpecialDayModel>> getAllSpecialDays({required String userId}) async {
    // Tüm kişilerin özel günlerini collectionGroup ile tek sorguda çeker.
    final snap = await _firestore
        .collectionGroup(FirestorePaths.specialDays)
        .where('userId', isEqualTo: userId)
        .get();
    // personId'yi path'ten çıkar
    return snap.docs.map((d) {
      final pathSegments = d.reference.path.split('/');
      final pid = pathSegments[pathSegments.indexOf(FirestorePaths.persons) + 1];
      return SpecialDayModel.fromDoc(d, pid);
    }).toList();
  }

  @override
  Future<SpecialDayModel> addSpecialDay({
    required String userId,
    required String personId,
    required SpecialDayModel model,
  }) async {
    final map = model.toMap()..['userId'] = userId; // collectionGroup için
    final ref = await _firestore
        .collection(FirestorePaths.specialDaysCol(userId, personId))
        .add(map);
    final snap = await ref.get();
    return SpecialDayModel.fromDoc(snap, personId);
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
    await ref.update(model.toUpdateMap());
    final snap = await ref.get();
    return SpecialDayModel.fromDoc(snap, personId);
  }

  @override
  Future<void> deleteSpecialDay({
    required String userId,
    required String personId,
    required String specialDayId,
  }) async {
    await _firestore
        .collection(FirestorePaths.specialDaysCol(userId, personId))
        .doc(specialDayId)
        .delete();
  }
}
