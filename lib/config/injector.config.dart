// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:pointr/domain/repositories/i_favorites_repo.dart' as _i3;
import 'package:pointr/domain/repositories/i_local_routes_repo.dart' as _i4;
import 'package:pointr/domain/repositories/i_location_repo.dart' as _i5;
import 'package:pointr/domain/repositories/i_places_repo.dart' as _i6;

const String _test = 'test';

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i3.IFavoritesRepo>(
      () => _i3.IFavoritesRepo(),
      registerFor: {_test},
    );
    gh.factory<_i4.ILocalRoutesRepo>(
      () => _i4.ILocalRoutesRepo(),
      registerFor: {_test},
    );
    gh.factory<_i5.ILocationRepo>(
      () => _i5.ILocationRepo(),
      registerFor: {_test},
    );
    gh.factory<_i6.IPlacesRepo>(
      () => _i6.IPlacesRepo(),
      registerFor: {_test},
    );
    return this;
  }
}
