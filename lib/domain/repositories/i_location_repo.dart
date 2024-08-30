import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../entities/coordinates_entity.dart';

const karachiLatLng = CoordinatesEntity(24.874694, 67.033639);

@test
@injectable
class ILocationRepo {
  Future<LocationPermission> checkPermission() async =>
      LocationPermission.always;
  Future<LocationPermission> requestPermission() async =>
      LocationPermission.always;
  Future<CoordinatesEntity> getLocation() async => karachiLatLng;

  Future<void> openLocationSettings() async {}
}
