import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:familytrackapp/core/errors/failures.dart';

/// Tüm UseCase'lerin implement ettiği sözleşme.
///
/// CLAUDE.md §Async & Error Handling: Either pattern zorunlu.
/// [T] — başarı dönüş tipi, [Params] — parametre sınıfı.
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Parametre gerektirmeyen UseCase'ler için kullanılır.
class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object?> get props => [];
}
