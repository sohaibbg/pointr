import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../domain/entities/coordinates_entity.dart';
import '../../../domain/entities/route_entity.dart';
import '../packages/database.dart';

class CoordinatesListConverter
    extends TypeConverter<List<CoordinatesEntity>, String> {
  const CoordinatesListConverter();

  @override
  List<CoordinatesEntity> fromSql(String fromDb) =>
      List<CoordinatesEntity>.from(
        jsonDecode(fromDb).map(
          CoordinatesEntityMapper.fromJson,
        ),
      );

  @override
  String toSql(List<CoordinatesEntity> value) => jsonEncode(value);
}

class CustomRoutes extends Table {
  IntColumn get id => integer().autoIncrement()();
  // ignore: recursive_getters
  TextColumn get name => text().unique().check(name.isNotValue(''))();
  IntColumn get routeMode => intEnum<RouteMode>()();
  TextColumn get points => text().map(const CoordinatesListConverter())();
}

extension CompanionConverter on RouteEntity {
  CustomRoutesCompanion get toCustomRouteCompanion => CustomRoutesCompanion(
        name: Value(name),
        routeMode: Value(mode),
        points: Value(points.toList()),
      );
}
