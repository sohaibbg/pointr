import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/coordinates_entity.dart';
import '../../domain/entities/searchable_place.dart';
import '../../domain/repositories/i_favorites_repo.dart';
import '../services/packages/database.dart';

extension LocatedPlaceConverter on Favorite {
  FavoriteEntity get toFavoriteEntity => FavoriteEntity(
        coordinates: CoordinatesEntity(lat, lng),
        name: name,
      );
}

extension CompanionConverter on FavoriteEntity {
  FavoritesCompanion get toFavoritesCompanion => FavoritesCompanion(
        name: Value(name),
        lat: Value(coordinates.latitude),
        lng: Value(coordinates.longitude),
      );
}

@dev
@prod
@Injectable(as: IFavoritesRepo)
class PFavoritesRepo implements IFavoritesRepo {
  /// emits when table updates
  @override
  Future<List<FavoriteEntity>> getAll() => AppDatabase.instance
      .select(
        AppDatabase.instance.favorites,
      )
      .get()
      .then(
        (value) => value
            .map(
              (updatedFavs) => updatedFavs.toFavoriteEntity,
            )
            .toList(),
      );

  @override
  Future<void> insert(
    FavoriteEntity newFav,
  ) =>
      AppDatabase.instance
          .into(
            AppDatabase.instance.favorites,
          )
          .insert(
            newFav.toFavoritesCompanion,
          );

  @override
  Future<void> delete(String name) async {
    final delStmnt = AppDatabase.instance.delete(
      AppDatabase.instance.favorites,
    )..where(
        (tbl) => tbl.name.isValue(name),
      );
    await delStmnt.go();
  }

  @override
  Future<void> update(
    String prevName, {
    required CoordinatesEntity coordinates,
  }) async {
    final delStmnt = AppDatabase.instance.update(
      AppDatabase.instance.favorites,
    )..where(
        (tbl) => tbl.name.isValue(prevName),
      );
    await delStmnt.write(
      FavoritesCompanion(
        lat: Value(coordinates.latitude),
        lng: Value(coordinates.longitude),
      ),
    );
  }

  @override
  Future<bool> doesTitleAlreadyExist(String name) async {
    final favs =
        await AppDatabase.instance.select(AppDatabase.instance.favorites).get();
    return favs.any(
      (fav) => fav.name == name,
    );
  }
}
