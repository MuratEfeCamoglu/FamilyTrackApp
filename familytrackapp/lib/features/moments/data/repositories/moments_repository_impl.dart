import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:familytrackapp/core/errors/failures.dart';
import 'package:familytrackapp/features/moments/data/datasources/moments_remote_datasource.dart';
import 'package:familytrackapp/features/moments/data/models/moment_model.dart';
import 'package:familytrackapp/features/moments/domain/entities/moment_entity.dart';
import 'package:familytrackapp/features/moments/domain/repositories/moments_repository.dart';

/// [MomentsRepository] Firestore implementasyonu.
@LazySingleton(as: MomentsRepository)
class MomentsRepositoryImpl implements MomentsRepository {
  MomentsRepositoryImpl(this._datasource, this._storage);

  final MomentsRemoteDatasource _datasource;
  final FirebaseStorage _storage;

  Either<Failure, T> _handleException<T>(Object e) {
    if (e is FirebaseException) {
      return Left(FirebaseFailure(e.message ?? 'Firebase hatası'));
    }
    return const Left(UnknownFailure());
  }

  @override
  Future<Either<Failure, List<Moment>>> getMoments({required String userId}) async {
    try {
      final models = await _datasource.getMoments(userId: userId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, List<Moment>>> getMomentsByPerson({
    required String userId,
    required String personId,
  }) async {
    try {
      final models = await _datasource.getMomentsByPerson(
          userId: userId, personId: personId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, Moment>> addMoment({
    required String userId,
    required Moment moment,
  }) async {
    try {
      final model = await _datasource.addMoment(
        userId: userId,
        model: MomentModel.fromEntity(moment),
      );
      return Right(model.toEntity());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, Moment>> updateMoment({
    required String userId,
    required Moment moment,
  }) async {
    try {
      final model = await _datasource.updateMoment(
        userId: userId,
        model: MomentModel.fromEntity(moment),
      );
      return Right(model.toEntity());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteMoment({
    required String userId,
    required String momentId,
    String? imageUrl,
  }) async {
    try {
      // Fotoğraf varsa Storage'dan da sil
      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          await _storage.refFromURL(imageUrl).delete();
        } catch (_) {
          // Storage silme başarısız olsa da Firestore kaydı silinir
        }
      }
      await _datasource.deleteMoment(userId: userId, momentId: momentId);
      return const Right(unit);
    } catch (e) {
      return _handleException(e);
    }
  }
}
