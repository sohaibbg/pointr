import 'dart:convert';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/coordinates_entity.dart';
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
          (e) => _fromMap(e),
        )
        .toList();
    return routes;
  }

  static RouteEntity _fromMap(Map map) {
    final name = map['name'] as String;
    final mode = RouteMode.values.firstWhere(
      (element) => element.name == map['mode'],
    );
    final points = map['points'] as List;
    final parsedPoints = points
        .map(
          (e) => CoordinatesEntity.fromJson(List<double>.from(e)),
        )
        .toIList();
    return RouteEntity(name: name, mode: mode, points: parsedPoints);
  }

  @override
  Future<List<RouteEntity>> getCustom() => throw UnimplementedError();

  @override
  Future<void> addRoute(RouteEntity route) => throw UnimplementedError();

  @override
  Future<void> deleteRoute(String routeName) => throw UnimplementedError();
}
