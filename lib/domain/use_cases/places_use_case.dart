import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/injector.dart';
import '../entities/coordinates_entity.dart';
import '../entities/searchable_place.dart';
import '../repositories/i_places_repo.dart';

part 'places_use_case.g.dart';

@Riverpod(keepAlive: true)
Future<List<NamedAddressEntity>> nearbyPlacesFromCoordinates(
  NearbyPlacesFromCoordinatesRef ref,
  CoordinatesEntity coordinates,
) =>
    getIt.call<IPlacesRepo>().getNearbyPlaces(coordinates);

@riverpod
Future<String> nameFromCoordinates(
  NameFromCoordinatesRef ref,
  CoordinatesEntity coordinatesEntity,
) =>
    getIt.call<IPlacesRepo>().getNameFrom(coordinatesEntity);
