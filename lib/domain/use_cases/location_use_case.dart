import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/injector.dart';
import '../entities/coordinates_entity.dart';
import '../repositories/i_location_repo.dart';

part 'location_use_case.g.dart';

@riverpod
Future<CoordinatesEntity> currentLoc(CurrentLocRef ref) =>
    getIt.call<ILocationRepo>().getLocation();

@riverpod
class LocPermission extends _$LocPermission {
  @override
  Future<LocationPermission> build() =>
      getIt.call<ILocationRepo>().checkPermission();

  Future<LocationPermission> askAgain() async {
    final repeated = await getIt.call<ILocationRepo>().requestPermission();
    state = AsyncData(repeated);
    return repeated;
  }

  Future<void> openSettings() => Geolocator.openAppSettings();
}
