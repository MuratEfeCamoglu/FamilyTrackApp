import 'package:dartz/dartz.dart';
import 'package:familytrackapp/core/errors/failures.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_entity.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_detail_entity.dart';
import 'package:familytrackapp/features/profile/domain/entities/special_day_entity.dart';

/// Kişi yönetimi repository sözleşmesi (domain katmanı).
///
/// CLAUDE.md: Önce interface/contract yaz, sonra implementasyon.
/// Tüm metodlar `Either<Failure, T>` döndürür.
abstract class PersonRepository {
  // ── Kişiler ───────────────────────────────────────────

  /// Kullanıcının tüm kişilerini listeler.
  Future<Either<Failure, List<Person>>> getPersons({
    required String userId,
  });

  /// Tek bir kişiyi ID ile getirir.
  Future<Either<Failure, Person>> getPersonById({
    required String userId,
    required String personId,
  });

  /// Yeni kişi ekler ve eklenen entity'yi döndürür.
  Future<Either<Failure, Person>> addPerson({
    required String userId,
    required Person person,
  });

  /// Mevcut kişiyi günceller.
  Future<Either<Failure, Person>> updatePerson({
    required String userId,
    required Person person,
  });

  /// Kişiyi tüm alt dökümanlarıyla siler.
  Future<Either<Failure, Unit>> deletePerson({
    required String userId,
    required String personId,
  });

  // ── Kişi Detayları ────────────────────────────────────

  /// Kişiye ait tüm detay bilgilerini listeler.
  Future<Either<Failure, List<PersonDetail>>> getPersonDetails({
    required String userId,
    required String personId,
  });

  /// Yeni detay bilgisi ekler.
  Future<Either<Failure, PersonDetail>> addPersonDetail({
    required String userId,
    required String personId,
    required PersonDetail detail,
  });

  /// Detay bilgisini siler.
  Future<Either<Failure, Unit>> deletePersonDetail({
    required String userId,
    required String personId,
    required String detailId,
  });

  // ── Özel Günler ───────────────────────────────────────

  /// Kişiye ait tüm özel günleri listeler.
  Future<Either<Failure, List<SpecialDay>>> getSpecialDays({
    required String userId,
    required String personId,
  });

  /// Tüm kişilerin özel günlerini listeler (Takvim sayfası için).
  Future<Either<Failure, List<SpecialDay>>> getAllSpecialDays({
    required String userId,
  });

  /// Yeni özel gün ekler.
  Future<Either<Failure, SpecialDay>> addSpecialDay({
    required String userId,
    required String personId,
    required SpecialDay specialDay,
  });

  /// Özel günü günceller.
  Future<Either<Failure, SpecialDay>> updateSpecialDay({
    required String userId,
    required String personId,
    required SpecialDay specialDay,
  });

  /// Özel günü siler.
  Future<Either<Failure, Unit>> deleteSpecialDay({
    required String userId,
    required String personId,
    required String specialDayId,
  });
}
