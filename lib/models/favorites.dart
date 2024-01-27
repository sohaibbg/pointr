import 'package:drift/drift.dart';

import '../repo/local/database.dart';
import 'coordinates.dart';
import 'located_place.dart';

class Favorites extends Table {
  IntColumn get id => integer().autoIncrement()();
  // ignore: recursive_getters
  TextColumn get title => text().unique().check(title.isNotValue(''))();
  RealColumn get lat => real()();
  RealColumn get lng => real()();
}

extension LocatedPlaceConverter on Favorite {
  LocatedPlace get locatedPlace => LocatedPlace(
        title: title,
        coordinates: Coordinates(lat, lng),
      );
}

extension CompanionConverter on LocatedPlace {
  FavoritesCompanion get toFavoritesCompanion => FavoritesCompanion(
        title: Value(title),
        lat: Value(coordinates.latitude),
        lng: Value(coordinates.longitude),
      );
}
