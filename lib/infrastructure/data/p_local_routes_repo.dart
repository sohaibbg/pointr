import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/route_entity.dart';
import '../../domain/repositories/i_local_routes_repo.dart';
import '../services/packages/database.dart';
import '../services/tables/custom_routes.dart';

@prod
@Injectable(as: ILocalRoutesRepo)
class PLocalRoutesRepo implements ILocalRoutesRepo {
  @override
  Future<List<RouteEntity>> getHardcoded() async {
    const routesFilePath = 'assets/allRoutes.json';
    final fileText = await rootBundle.loadString(routesFilePath);
    final fileObject = jsonDecode(fileText) as List;
    final routes = fileObject
        .map<RouteEntity>(
          (e) => RouteEntityMapper.fromMap(e),
        )
        .toList();
    return routes;
  }

  @override
  Future<List<RouteEntity>> getCustom() async {
    final records = await AppDatabase.instance
        .select(
          AppDatabase.instance.customRoutes,
        )
        .get();
    return records
        .map(
          (e) => RouteEntity(
            name: e.name,
            mode: e.routeMode,
            points: e.points,
          ),
        )
        .toList();
  }

  @override
  Future<void> addRoute(
    RouteEntity route,
  ) =>
      AppDatabase.instance
          .into(
            AppDatabase.instance.customRoutes,
          )
          .insert(
            route.toCustomRouteCompanion,
          );

  @override
  Future<void> deleteRoute(String routeName) async {
    final stmt = AppDatabase.instance.delete(
      AppDatabase.instance.customRoutes,
    )..where(
        (tbl) => tbl.name.equals(routeName),
      );
    await stmt.go();
  }
}
