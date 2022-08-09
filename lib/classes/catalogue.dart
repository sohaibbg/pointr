import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils.dart';

class Catalogue {
  static Set<Polyline>? routes;
  static Future<void> loadRoutes() async {
    // initialize catalogue
    routes = {};
    // read routes
    var routesAsString = jsonDecode(
      await loadAsset('assets/allRoutes.json'),
    );
    // feed routes into catalogue
    routesAsString.forEach(
      (routeName, routeStops) {
        List<LatLng> points = [];
        routeStops.forEach(
          (stopMap) => points.add(
            LatLng(
              stopMap.values.first.first,
              stopMap.values.first.last,
            ),
          ),
        );
        routes!.add(
          Polyline(
            polylineId: PolylineId(routeName),
            points: points,
            width: 4,
          ),
        );
      },
    );
  }
}
