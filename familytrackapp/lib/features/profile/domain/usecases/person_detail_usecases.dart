import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:familytrackapp/core/errors/failures.dart';
import 'package:familytrackapp/core/usecases/usecase.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_detail_entity.dart';
import 'package:familytrackapp/features/profile/domain/repositories/person_repository.dart';

import 'package:injectable/injectable.dart';

@injectable
class GetPersonDetailsUseCase implements UseCase<List<PersonDetail>, GetPersonDetailsParams> {
  GetPersonDetailsUseCase(this._repository);
  final PersonRepository _repository;

  @override
  Future<Either<Failure, List<PersonDetail>>> call(GetPersonDetailsParams params) =>
      _repository.getPersonDetails(userId: params.userId, personId: params.personId);
}

class GetPersonDetailsParams extends Equatable {
  const GetPersonDetailsParams({required this.userId, required this.personId});
  final String userId;
  final String personId;
  @override
  List<Object?> get props => [userId, personId];
}

// ─────────────────────────────────────────────────────────

@injectable
class AddPersonDetailUseCase implements UseCase<PersonDetail, AddPersonDetailParams> {
  AddPersonDetailUseCase(this._repository);
  final PersonRepository _repository;

  @override
  Future<Either<Failure, PersonDetail>> call(AddPersonDetailParams params) =>
      _repository.addPersonDetail(
          userId: params.userId, personId: params.personId, detail: params.detail);
}

class AddPersonDetailParams extends Equatable {
  const AddPersonDetailParams({
    required this.userId,
    required this.personId,
    required this.detail,
  });
  final String userId;
  final String personId;
  final PersonDetail detail;
  @override
  List<Object?> get props => [userId, personId, detail];
}

// ─────────────────────────────────────────────────────────

@injectable
class DeletePersonDetailUseCase implements UseCase<Unit, DeletePersonDetailParams> {
  DeletePersonDetailUseCase(this._repository);
  final PersonRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(DeletePersonDetailParams params) =>
      _repository.deletePersonDetail(
          userId: params.userId, personId: params.personId, detailId: params.detailId);
}

class DeletePersonDetailParams extends Equatable {
  const DeletePersonDetailParams({
    required this.userId,
    required this.personId,
    required this.detailId,
  });
  final String userId;
  final String personId;
  final String detailId;
  @override
  List<Object?> get props => [userId, personId, detailId];
}
