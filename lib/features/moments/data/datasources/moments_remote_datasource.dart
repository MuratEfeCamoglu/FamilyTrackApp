import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:familytrackapp/core/constants/firestore_paths.dart';
import 'package:familytrackapp/features/moments/data/models/moment_model.dart';

/// Moment verileri için Firestore veri kaynağı sözleşmesi.
abstract class MomentsRemoteDatasource {
  Future<List<MomentModel>> getMoments({required String userId});
  Future<List<MomentModel>> getMomentsByPerson({required String userId, required String personId});
  Future<MomentModel> addMoment({required String userId, required MomentModel model});
  Future<MomentModel> updateMoment({required String userId, required MomentModel model});
  Future<void> deleteMoment({required String userId, required String momentId});
}

/// Firestore tabanlı moment veri kaynağı implementasyonu.
@LazySingleton(as: MomentsRemoteDatasource)
class MomentsRemoteDatasourceImpl implements MomentsRemoteDatasource {
  MomentsRemoteDatasourceImpl(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Future<List<MomentModel>> getMoments({required String userId}) async {
    try {
      final snap = await _firestore
          .collection(FirestorePaths.momentsCol(userId))
          .orderBy('date', descending: true)
          .get();
      return snap.docs.map(MomentModel.fromDoc).toList();
    } catch (e) {
      debugPrint('Firestore getMoments offline cache fallback: $e');
      final snap = await _firestore
          .collection(FirestorePaths.momentsCol(userId))
          .get(const GetOptions(source: Source.cache));
      final models = snap.docs.map(MomentModel.fromDoc).toList();
      models.sort((a, b) => b.date.compareTo(a.date));
      return models;
    }
  }

  @override
  Future<List<MomentModel>> getMomentsByPerson({
    required String userId,
    required String personId,
  }) async {
    try {
      final snap = await _firestore
          .collection(FirestorePaths.momentsCol(userId))
          .where('personId', isEqualTo: personId)
          .orderBy('date', descending: true)
          .get();
      return snap.docs.map(MomentModel.fromDoc).toList();
    } catch (e) {
      debugPrint('Firestore getMomentsByPerson offline cache fallback: $e');
      final snap = await _firestore
          .collection(FirestorePaths.momentsCol(userId))
          .where('personId', isEqualTo: personId)
          .get(const GetOptions(source: Source.cache));
      final models = snap.docs.map(MomentModel.fromDoc).toList();
      models.sort((a, b) => b.date.compareTo(a.date));
      return models;
    }
  }

  @override
  Future<MomentModel> addMoment({
    required String userId,
    required MomentModel model,
  }) async {
    final ref = _firestore
        .collection(FirestorePaths.momentsCol(userId))
        .doc();
    // Fire-and-forget: do not block on network
    ref.set(model.toMap()).catchError((e) {
      debugPrint('Firestore addMoment background sync error: $e');
    });
    return MomentModel(
      id: ref.id,
      personId: model.personId,
      title: model.title,
      type: model.type,
      date: model.date,
      imageUrl: model.imageUrl,
      description: model.description,
      badgeName: model.badgeName,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<MomentModel> updateMoment({
    required String userId,
    required MomentModel model,
  }) async {
    final ref = _firestore.doc(FirestorePaths.momentDoc(userId, model.id));
    // Fire-and-forget: do not block on network
    ref.update(model.toUpdateMap()).catchError((e) {
      debugPrint('Firestore updateMoment background sync error: $e');
    });
    return model;
  }

  @override
  Future<void> deleteMoment({
    required String userId,
    required String momentId,
  }) async {
    _firestore.doc(FirestorePaths.momentDoc(userId, momentId)).delete().catchError((e) {
      debugPrint('Firestore deleteMoment background sync error: $e');
    });
  }
}
