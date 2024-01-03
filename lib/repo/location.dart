import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/coordinates.dart';

part 'location.g.dart';

const karachiLatLng = Coordinates(24.874694, 67.033639);

@riverpod
Future<Coordinates> currentLoc(CurrentLocRef ref) async {
  final permission = ref.watch(locPermissionProvider).value;
  if (![
    LocationPermission.always,
    LocationPermission.whileInUse,
  ].contains(permission)) throw 'location permission not initialized';
  // get loc
  final loc = await Geolocator.getCurrentPosition();
  return Coordinates.fromPosition(loc);
}

@riverpod
Future<LocationPermission> locPermission(LocPermissionRef ref) =>
    Geolocator.requestPermission();
