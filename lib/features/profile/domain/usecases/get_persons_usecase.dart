import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:familytrackapp/core/errors/failures.dart';
import 'package:familytrackapp/core/usecases/usecase.dart';
import 'package:familytrackapp/features/profile/domain/entities/person_entity.dart';
import 'package:familytrackapp/features/profile/domain/repositories/person_repository.dart';

import 'package:injectable/injectable.dart';

@injectable
class GetPersonsUseCase implements UseCase<List<Person>, GetPersonsParams> {
  GetPersonsUseCase(this._repository);
  final PersonRepository _repository;

  @override
  Future<Either<Failure, List<Person>>> call(GetPersonsParams params) =>
      _repository.getPersons(userId: params.userId);
}

class GetPersonsParams extends Equatable {
  const GetPersonsParams({required this.userId});
  final String userId;
  @override
  List<Object?> get props => [userId];
}
