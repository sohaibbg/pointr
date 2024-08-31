// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pointr/domain/repositories/i_favorites_repo.dart' as _i185;
import 'package:pointr/domain/repositories/i_initial_disclaimers_shown_repo.dart'
    as _i511;
import 'package:pointr/domain/repositories/i_local_routes_repo.dart' as _i846;
import 'package:pointr/domain/repositories/i_location_repo.dart' as _i788;
import 'package:pointr/domain/repositories/i_places_repo.dart' as _i482;
import 'package:pointr/domain/repositories/i_recents_repo.dart' as _i124;
import 'package:pointr/infrastructure/data/p_favorites_repo.dart' as _i406;
import 'package:pointr/infrastructure/data/p_initial_disclaimers_shown_repo.dart'
    as _i574;
import 'package:pointr/infrastructure/data/p_local_routes_repo.dart' as _i621;
import 'package:pointr/infrastructure/data/p_location_repo.dart' as _i489;
import 'package:pointr/infrastructure/data/p_places_repo.dart' as _i776;
import 'package:pointr/infrastructure/data/p_recents_repo.dart' as _i97;

const String _prod = 'prod';
const String _dev = 'dev';
const String _test = 'test';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i788.ILocationRepo>(
      () => _i489.PLocationRepo(),
      registerFor: {
        _prod,
        _dev,
      },
    );
    gh.factory<_i846.ILocalRoutesRepo>(
      () => _i621.PLocalRoutesRepo(),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i124.IRecentsRepo>(
      () => _i97.PRecentsRepo(),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i185.IFavoritesRepo>(
      () => _i406.PFavoritesRepo(),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i482.IPlacesRepo>(
      () => _i776.PPlacesRepo(),
      registerFor: {
        _prod,
        _dev,
      },
    );
    gh.factory<_i511.IInitialDisclaimersShownRepo>(
      () => _i574.PInitialDisclaimersShownRepo(),
      registerFor: {
        _dev,
        _prod,
      },
    );
    gh.factory<_i482.IPlacesRepo>(
      () => _i482.IPlacesRepo(),
      registerFor: {_test},
    );
    gh.factory<_i846.ILocalRoutesRepo>(
      () => _i846.ILocalRoutesRepo(),
      registerFor: {_test},
    );
    gh.factory<_i511.IInitialDisclaimersShownRepo>(
      () => _i511.IInitialDisclaimersShownRepo(),
      registerFor: {_test},
    );
    gh.factory<_i185.IFavoritesRepo>(
      () => _i185.IFavoritesRepo(),
      registerFor: {_test},
    );
    gh.factory<_i124.IRecentsRepo>(
      () => _i124.IRecentsRepo(),
      registerFor: {_test},
    );
    gh.factory<_i788.ILocationRepo>(
      () => _i788.ILocationRepo(),
      registerFor: {_test},
    );
    return this;
  }
}
