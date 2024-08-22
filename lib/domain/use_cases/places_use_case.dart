import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/injector.dart';
import '../entities/autocomplete_suggestion_entity.dart';
import '../entities/coordinates_entity.dart';
import '../entities/named_address_entity.dart';
import '../repositories/i_places_repo.dart';

part 'places_use_case.g.dart';

@riverpod
Future<List<NamedAddressEntity>> nearbyPlacesFromCoordinates(
  NearbyPlacesFromCoordinatesRef ref,
  CoordinatesEntity coordinates,
) =>
    getIt.call<IPlacesRepo>().getNearbyPlaces(coordinates);

@riverpod
Future<List<AutocompleteSuggestionEntity>> nearbyPlacesBySearchTerm(
  NearbyPlacesBySearchTermRef ref,
  String term,
) async {
  // We capture whether the provider is currently disposed or not.
  bool didDispose = false;
  ref.onDispose(() => didDispose = true);

  // We delay the request by 500ms, to wait for the user to stop typing
  await Future<void>.delayed(const Duration(milliseconds: 500));

  // If the provider was disposed during the delay, it means that the user
  // refreshed again. We throw an exception to cancel the request.
  // It is safe to use an exception here, as it will be caught by Riverpod.
  if (didDispose) throw Exception('Cancelled');

  return getIt.call<IPlacesRepo>().getAutocompleteSuggestions(term.trim());
}

@riverpod
Future<String> nameFromCoordinates(
  NameFromCoordinatesRef ref,
  CoordinatesEntity coordinatesEntity,
) =>
    getIt.call<IPlacesRepo>().getNameFrom(coordinatesEntity);
