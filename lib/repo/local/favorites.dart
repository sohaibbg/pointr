import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/coordinates.dart';
import '../../models/favorites.dart';
import '../../models/located_place.dart';
import 'database.dart';

part 'favorites.g.dart';

@riverpod
Stream<List<LocatedPlace>> favorites(
  FavoritesRef ref,
) =>
    FavoritesCRUD.tableStream();

abstract class FavoritesCRUD {
  /// emits when table updates
  static Stream<List<LocatedPlace>> tableStream() => database
      .select(
        database.favorites,
      )
      .watch()
      .map(
        (updatedFavs) => updatedFavs
            .map(
              (e) => e.locatedPlace,
            )
            .toList(),
      );

  /// returns the generated id
  static Future insert(
    LocatedPlace lp,
  ) =>
      database
          .into(
            database.favorites,
          )
          .insert(
            lp.toFavoritesCompanion,
          );

  static Future<void> delete(String title) async {
    final delStmnt = database.delete(
      database.favorites,
    )..where(
        (tbl) => tbl.title.isValue(title),
      );
    await delStmnt.go();
  }

  static Future<void> update(
    String title, {
    required Coordinates coordinates,
  }) async {
    final delStmnt = database.update(
      database.favorites,
    )..where(
        (tbl) => tbl.title.isValue(title),
      );
    await delStmnt.write(
      FavoritesCompanion(
        lat: Value(coordinates.latitude),
        lng: Value(coordinates.longitude),
      ),
    );
  }

  static Future<bool> checkIfTitleAlreadyExists(String title) async {
    final favs = await database.select(database.favorites).get();
    return favs.any(
      (fav) => fav.title == title,
    );
  }
}
