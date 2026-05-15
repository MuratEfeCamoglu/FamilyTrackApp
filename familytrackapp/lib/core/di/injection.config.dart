// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:cloud_firestore/cloud_firestore.dart' as _i974;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:firebase_storage/firebase_storage.dart' as _i457;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/calendar/presentation/cubit/calendar_cubit.dart'
    as _i131;
import '../../features/moments/data/datasources/moments_remote_datasource.dart'
    as _i268;
import '../../features/moments/data/repositories/moments_repository_impl.dart'
    as _i1045;
import '../../features/moments/domain/repositories/moments_repository.dart'
    as _i285;
import '../../features/moments/domain/usecases/moment_usecases.dart' as _i861;
import '../../features/moments/presentation/cubit/moments_cubit.dart' as _i484;
import '../../features/profile/data/datasources/person_remote_datasource.dart'
    as _i282;
import '../../features/profile/data/repositories/person_repository_impl.dart'
    as _i653;
import '../../features/profile/domain/repositories/person_repository.dart'
    as _i685;
import '../../features/profile/domain/usecases/add_person_usecase.dart'
    as _i850;
import '../../features/profile/domain/usecases/delete_person_usecase.dart'
    as _i385;
import '../../features/profile/domain/usecases/get_persons_usecase.dart'
    as _i926;
import '../../features/profile/domain/usecases/person_detail_usecases.dart'
    as _i828;
import '../../features/profile/domain/usecases/special_day_usecases.dart'
    as _i770;
import '../../features/profile/domain/usecases/update_person_usecase.dart'
    as _i971;
import '../../features/profile/presentation/cubit/person_detail_cubit.dart'
    as _i231;
import '../../features/profile/presentation/cubit/profile_cubit.dart' as _i36;
import '../../features/today/presentation/cubit/today_cubit.dart' as _i424;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i974.FirebaseFirestore>(() => registerModule.firestore);
    gh.lazySingleton<_i457.FirebaseStorage>(() => registerModule.storage);
    gh.lazySingleton<_i268.MomentsRemoteDatasource>(
      () => _i268.MomentsRemoteDatasourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i282.PersonRemoteDatasource>(
      () => _i282.PersonRemoteDatasourceImpl(gh<_i974.FirebaseFirestore>()),
    );
    gh.lazySingleton<_i685.PersonRepository>(
      () => _i653.PersonRepositoryImpl(gh<_i282.PersonRemoteDatasource>()),
    );
    gh.factory<_i850.AddPersonUseCase>(
      () => _i850.AddPersonUseCase(gh<_i685.PersonRepository>()),
    );
    gh.factory<_i385.DeletePersonUseCase>(
      () => _i385.DeletePersonUseCase(gh<_i685.PersonRepository>()),
    );
    gh.factory<_i926.GetPersonsUseCase>(
      () => _i926.GetPersonsUseCase(gh<_i685.PersonRepository>()),
    );
    gh.factory<_i828.GetPersonDetailsUseCase>(
      () => _i828.GetPersonDetailsUseCase(gh<_i685.PersonRepository>()),
    );
    gh.factory<_i828.AddPersonDetailUseCase>(
      () => _i828.AddPersonDetailUseCase(gh<_i685.PersonRepository>()),
    );
    gh.factory<_i828.DeletePersonDetailUseCase>(
      () => _i828.DeletePersonDetailUseCase(gh<_i685.PersonRepository>()),
    );
    gh.factory<_i770.GetSpecialDaysUseCase>(
      () => _i770.GetSpecialDaysUseCase(gh<_i685.PersonRepository>()),
    );
    gh.factory<_i770.GetAllSpecialDaysUseCase>(
      () => _i770.GetAllSpecialDaysUseCase(gh<_i685.PersonRepository>()),
    );
    gh.factory<_i770.AddSpecialDayUseCase>(
      () => _i770.AddSpecialDayUseCase(gh<_i685.PersonRepository>()),
    );
    gh.factory<_i770.DeleteSpecialDayUseCase>(
      () => _i770.DeleteSpecialDayUseCase(gh<_i685.PersonRepository>()),
    );
    gh.factory<_i971.UpdatePersonUseCase>(
      () => _i971.UpdatePersonUseCase(gh<_i685.PersonRepository>()),
    );
    gh.lazySingleton<_i285.MomentsRepository>(
      () => _i1045.MomentsRepositoryImpl(
        gh<_i268.MomentsRemoteDatasource>(),
        gh<_i457.FirebaseStorage>(),
      ),
    );
    gh.factory<_i861.GetMomentsUseCase>(
      () => _i861.GetMomentsUseCase(gh<_i285.MomentsRepository>()),
    );
    gh.factory<_i861.GetMomentsByPersonUseCase>(
      () => _i861.GetMomentsByPersonUseCase(gh<_i285.MomentsRepository>()),
    );
    gh.factory<_i861.AddMomentUseCase>(
      () => _i861.AddMomentUseCase(gh<_i285.MomentsRepository>()),
    );
    gh.factory<_i861.DeleteMomentUseCase>(
      () => _i861.DeleteMomentUseCase(gh<_i285.MomentsRepository>()),
    );
    gh.factory<_i484.MomentsCubit>(
      () => _i484.MomentsCubit(
        getMomentsUseCase: gh<_i861.GetMomentsUseCase>(),
        getPersonsUseCase: gh<_i926.GetPersonsUseCase>(),
        addMomentUseCase: gh<_i861.AddMomentUseCase>(),
        deleteMomentUseCase: gh<_i861.DeleteMomentUseCase>(),
      ),
    );
    gh.factory<_i131.CalendarCubit>(
      () => _i131.CalendarCubit(
        getAllSpecialDaysUseCase: gh<_i770.GetAllSpecialDaysUseCase>(),
      ),
    );
    gh.factory<_i231.PersonDetailCubit>(
      () => _i231.PersonDetailCubit(
        getPersonDetailsUseCase: gh<_i828.GetPersonDetailsUseCase>(),
        addPersonDetailUseCase: gh<_i828.AddPersonDetailUseCase>(),
        deletePersonDetailUseCase: gh<_i828.DeletePersonDetailUseCase>(),
      ),
    );
    gh.factory<_i36.ProfileCubit>(
      () => _i36.ProfileCubit(
        getPersonsUseCase: gh<_i926.GetPersonsUseCase>(),
        addPersonUseCase: gh<_i850.AddPersonUseCase>(),
        updatePersonUseCase: gh<_i971.UpdatePersonUseCase>(),
        deletePersonUseCase: gh<_i385.DeletePersonUseCase>(),
      ),
    );
    gh.factory<_i424.TodayCubit>(
      () => _i424.TodayCubit(
        getPersonsUseCase: gh<_i926.GetPersonsUseCase>(),
        getSpecialDaysUseCase: gh<_i770.GetSpecialDaysUseCase>(),
        getMomentsByPersonUseCase: gh<_i861.GetMomentsByPersonUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
