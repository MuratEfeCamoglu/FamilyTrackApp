import 'package:cloud_firestore/cloud_firestore.dart';
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
    final snap = await _firestore
        .collection(FirestorePaths.momentsCol(userId))
        .orderBy('date', descending: true)
        .get();
    return snap.docs.map(MomentModel.fromDoc).toList();
  }

  @override
  Future<List<MomentModel>> getMomentsByPerson({
    required String userId,
    required String personId,
  }) async {
    final snap = await _firestore
        .collection(FirestorePaths.momentsCol(userId))
        .where('personId', isEqualTo: personId)
        .orderBy('date', descending: true)
        .get();
    return snap.docs.map(MomentModel.fromDoc).toList();
  }

  @override
  Future<MomentModel> addMoment({
    required String userId,
    required MomentModel model,
  }) async {
    final ref = await _firestore
        .collection(FirestorePaths.momentsCol(userId))
        .add(model.toMap());
    final snap = await ref.get();
    return MomentModel.fromDoc(snap);
  }

  @override
  Future<MomentModel> updateMoment({
    required String userId,
    required MomentModel model,
  }) async {
    final ref = _firestore.doc(FirestorePaths.momentDoc(userId, model.id));
    await ref.update(model.toUpdateMap());
    final snap = await ref.get();
    return MomentModel.fromDoc(snap);
  }

  @override
  Future<void> deleteMoment({
    required String userId,
    required String momentId,
  }) async {
    await _firestore.doc(FirestorePaths.momentDoc(userId, momentId)).delete();
  }
}
