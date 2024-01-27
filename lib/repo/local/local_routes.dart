import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/route.dart';

part 'local_routes.g.dart';

@riverpod
class LocalRoutes extends _$LocalRoutes {
  final routesFilePath = 'assets/allRoutes.json';

  @override
  Future<Set<Route>> build() async {
    final fileText = await rootBundle.loadString(routesFilePath);
    final fileObject = jsonDecode(fileText) as List;
    final routes = fileObject.map<Route>(
      (e) => Route.fromMap(e),
    );
    return routes.toSet();
  }

  Future<void> addRoute(Route path) async {}
  Future<void> deleteRoute(String routeName) async {}
}
