import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/route_entity.dart';
import '../../domain/repositories/i_local_routes_repo.dart';

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
          (e) => RouteEntity.fromMap(e),
        )
        .toList();
    return routes;
  }

  @override
  Future<List<RouteEntity>> getCustom() => throw UnimplementedError();

  @override
  Future<void> addRoute(RouteEntity route) => throw UnimplementedError();

  @override
  Future<void> deleteRoute(String routeName) => throw UnimplementedError();
}
