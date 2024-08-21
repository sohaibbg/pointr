import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../../../domain/entities/coordinates_entity.dart';
import '../../../domain/entities/route_entity.dart';
import '../tables/custom_routes.dart';
import '../tables/favorites.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Favorites, CustomRoutes])
class AppDatabase extends _$AppDatabase {
  @override
  final int schemaVersion = 1;

  static final instance = AppDatabase._();

  AppDatabase._() : super(_openConnection());

  static QueryExecutor _openConnection() => driftDatabase(name: 'my_database');
}
