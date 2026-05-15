import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

import 'package:familytrackapp/core/constants/app_strings.dart';
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

  static const int _maxPhotoSizeBytes = 5 * 1024 * 1024;

  Either<Failure, T> _handleException<T>(Object e) {
    if (e is Failure) return Left(e);
    if (e is FirebaseException) {
      return Left(FirebaseFailure(e.message ?? 'Firebase hatasi'));
    }
    return const Left(UnknownFailure());
  }

  Future<String?> _resolveImageUrl({
    required String userId,
    required Moment moment,
  }) async {
    final imageRef = moment.imageUrl;
    if (imageRef == null || imageRef.isEmpty) return null;

    final isRemote =
        imageRef.startsWith('http://') ||
        imageRef.startsWith('https://') ||
        imageRef.startsWith('gs://');
    if (isRemote) return imageRef;

    final imageFile = File(imageRef);
    if (!await imageFile.exists()) return null;

    final bytes = await imageFile.readAsBytes();
    if (bytes.length > _maxPhotoSizeBytes) {
      throw const FileSizeFailure(AppStrings.errorPhotoSize);
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final ref = _storage.ref(
      'users/$userId/moments/$now-${moment.personId}.jpg',
    );
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }

  @override
  Future<Either<Failure, List<Moment>>> getMoments({
    required String userId,
  }) async {
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
        userId: userId,
        personId: personId,
      );
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
      final imageUrl = await _resolveImageUrl(userId: userId, moment: moment);
      final model = await _datasource.addMoment(
        userId: userId,
        model: MomentModel.fromEntity(moment.copyWith(imageUrl: imageUrl)),
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
      if (imageUrl != null && imageUrl.isNotEmpty) {
        try {
          await _storage.refFromURL(imageUrl).delete();
        } catch (_) {
          // Storage silme basarisiz olsa da Firestore kaydi silinir.
        }
      }
      await _datasource.deleteMoment(userId: userId, momentId: momentId);
      return const Right(unit);
    } catch (e) {
      return _handleException(e);
    }
  }
}
