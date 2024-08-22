import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/coordinates_entity.dart';
import '../../domain/repositories/i_location_repo.dart';

@prod
@Injectable(as: ILocationRepo)
class PLocationRepo implements ILocationRepo {
  @override
  Future<LocationPermission> checkPermission() async {
    final permission = await Geolocator.checkPermission();
    if (![
      LocationPermission.always,
      LocationPermission.whileInUse,
    ].contains(permission)) return permission;
    try {
      await Geolocator.getCurrentPosition();
    } on LocationServiceDisabledException {
      return LocationPermission.denied;
    }
    return permission;
  }

  @override
  Future<CoordinatesEntity> getLocation() =>
      Geolocator.getCurrentPosition().then(
        (value) => CoordinatesEntity(
          value.latitude,
          value.longitude,
        ),
      );

  @override
  Future<LocationPermission> requestPermission() =>
      Geolocator.requestPermission();

  @override
  Future<void> openLocationSettings() => Geolocator.openLocationSettings();
}
