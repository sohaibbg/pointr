import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/injector.dart';
import '../entities/coordinates_entity.dart';
import '../repositories/i_location_repo.dart';

part 'location_use_case.g.dart';

@riverpod
Future<CoordinatesEntity> currentLoc(CurrentLocRef ref) async {
  final permission = ref.watch(locPermissionProvider).value;
  // this should throw because the UI
  // should not leave the possibility
  // open that location was requested
  // without first ensuring that the
  // user had crossed a permission grant flow
  if (![
    LocationPermission.always,
    LocationPermission.whileInUse,
  ].contains(permission)) throw 'location permission not initialized';
  // get loc
  return getIt.call<ILocationRepo>().getLocation();
}

@riverpod
Future<LocationPermission> locPermission(LocPermissionRef ref) =>
    getIt.call<ILocationRepo>().checkPermission();
