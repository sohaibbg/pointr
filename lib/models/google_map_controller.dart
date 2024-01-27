import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'coordinates.dart';

extension CurrentLoc on GoogleMapController {
  Future<Coordinates> get centerLatLng async {
    final visibleRegion = await getVisibleRegion();
    final centerLatLng = Coordinates(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) /
          2,
    );
    return centerLatLng;
  }
}
