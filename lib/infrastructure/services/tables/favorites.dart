import 'package:drift/drift.dart';

import '../../../domain/entities/address_entity.dart';
import '../packages/database.dart';

class Favorites extends Table {
  IntColumn get id => integer().autoIncrement()();
  // ignore: recursive_getters
  TextColumn get name => text().unique().check(name.isNotValue(''))();
  RealColumn get lat => real()();
  RealColumn get lng => real()();
}

extension CompanionConverter on AddressEntity {
  FavoritesCompanion get toFavoritesCompanion => FavoritesCompanion(
        name: Value(address),
        lat: Value(coordinates.latitude),
        lng: Value(coordinates.longitude),
      );
}
