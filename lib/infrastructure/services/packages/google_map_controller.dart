import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../domain/entities/coordinates_entity.dart';

extension CurrentLoc on GoogleMapController {
  Future<CoordinatesEntity> get centerLatLng async {
    final visibleRegion = await getVisibleRegion();
    final centerLatLng = CoordinatesEntity(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) /
          2,
    );
    return centerLatLng;
  }
}
