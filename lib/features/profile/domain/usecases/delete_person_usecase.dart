import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:familytrackapp/core/errors/failures.dart';
import 'package:familytrackapp/core/usecases/usecase.dart';
import 'package:familytrackapp/features/profile/domain/repositories/person_repository.dart';

import 'package:injectable/injectable.dart';

@injectable
class DeletePersonUseCase implements UseCase<Unit, DeletePersonParams> {
  DeletePersonUseCase(this._repository);
  final PersonRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(DeletePersonParams params) =>
      _repository.deletePerson(userId: params.userId, personId: params.personId);
}

class DeletePersonParams extends Equatable {
  const DeletePersonParams({required this.userId, required this.personId});
  final String userId;
  final String personId;
  @override
  List<Object?> get props => [userId, personId];
}
