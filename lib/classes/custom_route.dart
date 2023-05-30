import 'package:google_maps_flutter/google_maps_flutter.dart';

/// usage: CustomRoute.addRouteToDb()
class CustomRoute {
  static Future<void> addRouteToDb(String name, List<LatLng> coordinates) async =>
      throw UnimplementedError();

  /// [{"name": "a3", "coordinates": [LatLng, LatLng]}]
  static Future<List<Map<String, dynamic>>> fetchRoutesFromDb() async =>
      throw UnimplementedError();
  CustomRoute();
}
