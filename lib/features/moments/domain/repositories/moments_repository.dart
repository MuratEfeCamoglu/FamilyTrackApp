import 'package:dartz/dartz.dart';
import 'package:familytrackapp/core/errors/failures.dart';
import 'package:familytrackapp/features/moments/domain/entities/moment_entity.dart';

/// An yönetimi repository sözleşmesi (domain katmanı).
abstract class MomentsRepository {
  /// Kullanıcının tüm anlarını tarihe göre azalan sırada listeler.
  Future<Either<Failure, List<Moment>>> getMoments({
    required String userId,
  });

  /// Belirli bir kişiye ait anları listeler.
  Future<Either<Failure, List<Moment>>> getMomentsByPerson({
    required String userId,
    required String personId,
  });

  /// Yeni an ekler.
  Future<Either<Failure, Moment>> addMoment({
    required String userId,
    required Moment moment,
  });

  /// Mevcut anı günceller.
  Future<Either<Failure, Moment>> updateMoment({
    required String userId,
    required Moment moment,
  });

  /// Anı siler (fotoğraf varsa Storage'dan da kaldırır).
  Future<Either<Failure, Unit>> deleteMoment({
    required String userId,
    required String momentId,
    String? imageUrl,
  });
}
