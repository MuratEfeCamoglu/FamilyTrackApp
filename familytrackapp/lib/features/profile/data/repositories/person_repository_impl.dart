import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:familytrackapp/core/errors/failures.dart';
import 'package:familytrackapp/features/profile/data/datasources/person_remote_datasource.dart';
import 'package:familytrackapp/features/profile/data/models/person_detail_model.dart';
import 'package:familytrackapp/features/profile/data/models/person_model.dart';
import 'package:familytrackapp/features/profile/data/models/special_day_model.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_detail_entity.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_entity.dart';
import 'package:familytrackapp/features/profile/domain/entities/special_day_entity.dart';
import 'package:familytrackapp/features/profile/domain/repositories/person_repository.dart';

/// [PersonRepository] Firestore implementasyonu.
///
/// CLAUDE.md: Tüm Firestore işlemleri try/catch içinde, hata Failure'a dönüşür.
@LazySingleton(as: PersonRepository)
class PersonRepositoryImpl implements PersonRepository {
  PersonRepositoryImpl(this._datasource);

  final PersonRemoteDatasource _datasource;

  // ── Helper ───────────────────────────────────────────
  Either<Failure, T> _handleException<T>(Object e) {
    if (e is FirebaseException) {
      return Left(FirebaseFailure(e.message ?? 'Firebase hatası'));
    }
    return const Left(UnknownFailure());
  }

  // ── Kişiler ───────────────────────────────────────────

  @override
  Future<Either<Failure, List<Person>>> getPersons({required String userId}) async {
    try {
      final models = await _datasource.getPersons(userId: userId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, Person>> getPersonById({
    required String userId,
    required String personId,
  }) async {
    try {
      final model = await _datasource.getPersonById(userId: userId, personId: personId);
      return Right(model.toEntity());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, Person>> addPerson({
    required String userId,
    required Person person,
  }) async {
    try {
      final model = await _datasource.addPerson(
        userId: userId,
        model: PersonModel.fromEntity(person),
      );
      return Right(model.toEntity());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, Person>> updatePerson({
    required String userId,
    required Person person,
  }) async {
    try {
      final model = await _datasource.updatePerson(
        userId: userId,
        model: PersonModel.fromEntity(person),
      );
      return Right(model.toEntity());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePerson({
    required String userId,
    required String personId,
  }) async {
    try {
      await _datasource.deletePerson(userId: userId, personId: personId);
      return const Right(unit);
    } catch (e) {
      return _handleException(e);
    }
  }

  // ── Kişi Detayları ────────────────────────────────────

  @override
  Future<Either<Failure, List<PersonDetail>>> getPersonDetails({
    required String userId,
    required String personId,
  }) async {
    try {
      final models = await _datasource.getPersonDetails(userId: userId, personId: personId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, PersonDetail>> addPersonDetail({
    required String userId,
    required String personId,
    required PersonDetail detail,
  }) async {
    try {
      final model = await _datasource.addPersonDetail(
        userId: userId,
        personId: personId,
        model: PersonDetailModel.fromEntity(detail),
      );
      return Right(model.toEntity());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePersonDetail({
    required String userId,
    required String personId,
    required String detailId,
  }) async {
    try {
      await _datasource.deletePersonDetail(
          userId: userId, personId: personId, detailId: detailId);
      return const Right(unit);
    } catch (e) {
      return _handleException(e);
    }
  }

  // ── Özel Günler ───────────────────────────────────────

  @override
  Future<Either<Failure, List<SpecialDay>>> getSpecialDays({
    required String userId,
    required String personId,
  }) async {
    try {
      final models = await _datasource.getSpecialDays(userId: userId, personId: personId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, List<SpecialDay>>> getAllSpecialDays({required String userId}) async {
    try {
      final models = await _datasource.getAllSpecialDays(userId: userId);
      return Right(models.map((m) => m.toEntity()).toList());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, SpecialDay>> addSpecialDay({
    required String userId,
    required String personId,
    required SpecialDay specialDay,
  }) async {
    try {
      final model = await _datasource.addSpecialDay(
        userId: userId,
        personId: personId,
        model: SpecialDayModel.fromEntity(specialDay),
      );
      return Right(model.toEntity());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, SpecialDay>> updateSpecialDay({
    required String userId,
    required String personId,
    required SpecialDay specialDay,
  }) async {
    try {
      final model = await _datasource.updateSpecialDay(
        userId: userId,
        personId: personId,
        model: SpecialDayModel.fromEntity(specialDay),
      );
      return Right(model.toEntity());
    } catch (e) {
      return _handleException(e);
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSpecialDay({
    required String userId,
    required String personId,
    required String specialDayId,
  }) async {
    try {
      await _datasource.deleteSpecialDay(
          userId: userId, personId: personId, specialDayId: specialDayId);
      return const Right(unit);
    } catch (e) {
      return _handleException(e);
    }
  }
}
