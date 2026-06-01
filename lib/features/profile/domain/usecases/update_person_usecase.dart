import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:familytrackapp/core/errors/failures.dart';
import 'package:familytrackapp/core/usecases/usecase.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_entity.dart';
import 'package:familytrackapp/features/profile/domain/repositories/person_repository.dart';

import 'package:injectable/injectable.dart';

@injectable
class UpdatePersonUseCase implements UseCase<Person, UpdatePersonParams> {
  UpdatePersonUseCase(this._repository);
  final PersonRepository _repository;

  @override
  Future<Either<Failure, Person>> call(UpdatePersonParams params) =>
      _repository.updatePerson(userId: params.userId, person: params.person);
}

class UpdatePersonParams extends Equatable {
  const UpdatePersonParams({required this.userId, required this.person});
  final String userId;
  final Person person;
  @override
  List<Object?> get props => [userId, person];
}
