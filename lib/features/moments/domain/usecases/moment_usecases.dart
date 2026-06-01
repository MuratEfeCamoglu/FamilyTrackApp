import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:familytrackapp/core/errors/failures.dart';
import 'package:familytrackapp/core/usecases/usecase.dart';
import 'package:familytrackapp/features/moments/domain/entities/moment_entity.dart';
import 'package:familytrackapp/features/moments/domain/repositories/moments_repository.dart';

import 'package:injectable/injectable.dart';

@injectable
class GetMomentsUseCase implements UseCase<List<Moment>, GetMomentsParams> {
  GetMomentsUseCase(this._repository);
  final MomentsRepository _repository;

  @override
  Future<Either<Failure, List<Moment>>> call(GetMomentsParams params) =>
      _repository.getMoments(userId: params.userId);
}

class GetMomentsParams extends Equatable {
  const GetMomentsParams({required this.userId});
  final String userId;
  @override
  List<Object?> get props => [userId];
}

// ─────────────────────────────────────────────────────────

@injectable
class GetMomentsByPersonUseCase implements UseCase<List<Moment>, GetMomentsByPersonParams> {
  GetMomentsByPersonUseCase(this._repository);
  final MomentsRepository _repository;

  @override
  Future<Either<Failure, List<Moment>>> call(GetMomentsByPersonParams params) =>
      _repository.getMomentsByPerson(userId: params.userId, personId: params.personId);
}

class GetMomentsByPersonParams extends Equatable {
  const GetMomentsByPersonParams({required this.userId, required this.personId});
  final String userId;
  final String personId;
  @override
  List<Object?> get props => [userId, personId];
}

// ─────────────────────────────────────────────────────────

@injectable
class AddMomentUseCase implements UseCase<Moment, AddMomentParams> {
  AddMomentUseCase(this._repository);
  final MomentsRepository _repository;

  @override
  Future<Either<Failure, Moment>> call(AddMomentParams params) =>
      _repository.addMoment(userId: params.userId, moment: params.moment);
}

class AddMomentParams extends Equatable {
  const AddMomentParams({required this.userId, required this.moment});
  final String userId;
  final Moment moment;
  @override
  List<Object?> get props => [userId, moment];
}

// ─────────────────────────────────────────────────────────

@injectable
class DeleteMomentUseCase implements UseCase<Unit, DeleteMomentParams> {
  DeleteMomentUseCase(this._repository);
  final MomentsRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(DeleteMomentParams params) =>
      _repository.deleteMoment(
          userId: params.userId,
          momentId: params.momentId,
          imageUrl: params.imageUrl);
}

class DeleteMomentParams extends Equatable {
  const DeleteMomentParams({
    required this.userId,
    required this.momentId,
    this.imageUrl,
  });
  final String userId;
  final String momentId;
  final String? imageUrl;
  @override
  List<Object?> get props => [userId, momentId, imageUrl];
}
