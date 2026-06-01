import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:familytrackapp/core/errors/failures.dart';
import 'package:familytrackapp/core/usecases/usecase.dart';
import 'package:familytrackapp/features/profile/domain/entities/special_day_entity.dart';
import 'package:familytrackapp/features/profile/domain/repositories/person_repository.dart';

import 'package:injectable/injectable.dart';

@injectable
class GetSpecialDaysUseCase implements UseCase<List<SpecialDay>, GetSpecialDaysParams> {
  GetSpecialDaysUseCase(this._repository);
  final PersonRepository _repository;

  @override
  Future<Either<Failure, List<SpecialDay>>> call(GetSpecialDaysParams params) =>
      _repository.getSpecialDays(userId: params.userId, personId: params.personId);
}

class GetSpecialDaysParams extends Equatable {
  const GetSpecialDaysParams({required this.userId, required this.personId});
  final String userId;
  final String personId;
  @override
  List<Object?> get props => [userId, personId];
}

// ─────────────────────────────────────────────────────────

@injectable
class GetAllSpecialDaysUseCase implements UseCase<List<SpecialDay>, GetAllSpecialDaysParams> {
  GetAllSpecialDaysUseCase(this._repository);
  final PersonRepository _repository;

  @override
  Future<Either<Failure, List<SpecialDay>>> call(GetAllSpecialDaysParams params) =>
      _repository.getAllSpecialDays(userId: params.userId);
}

class GetAllSpecialDaysParams extends Equatable {
  const GetAllSpecialDaysParams({required this.userId});
  final String userId;
  @override
  List<Object?> get props => [userId];
}

// ─────────────────────────────────────────────────────────

@injectable
class AddSpecialDayUseCase implements UseCase<SpecialDay, AddSpecialDayParams> {
  AddSpecialDayUseCase(this._repository);
  final PersonRepository _repository;

  @override
  Future<Either<Failure, SpecialDay>> call(AddSpecialDayParams params) =>
      _repository.addSpecialDay(
          userId: params.userId, personId: params.personId, specialDay: params.specialDay);
}

class AddSpecialDayParams extends Equatable {
  const AddSpecialDayParams({
    required this.userId,
    required this.personId,
    required this.specialDay,
  });
  final String userId;
  final String personId;
  final SpecialDay specialDay;
  @override
  List<Object?> get props => [userId, personId, specialDay];
}

// ─────────────────────────────────────────────────────────

@injectable
class DeleteSpecialDayUseCase implements UseCase<Unit, DeleteSpecialDayParams> {
  DeleteSpecialDayUseCase(this._repository);
  final PersonRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(DeleteSpecialDayParams params) =>
      _repository.deleteSpecialDay(
          userId: params.userId,
          personId: params.personId,
          specialDayId: params.specialDayId);
}

class DeleteSpecialDayParams extends Equatable {
  const DeleteSpecialDayParams({
    required this.userId,
    required this.personId,
    required this.specialDayId,
  });
  final String userId;
  final String personId;
  final String specialDayId;
  @override
  List<Object?> get props => [userId, personId, specialDayId];
}
