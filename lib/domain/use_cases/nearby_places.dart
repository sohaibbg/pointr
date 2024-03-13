import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/injector.dart';
import '../entities/autocomplete_suggestion_entity.dart';
import '../entities/coordinates_entity.dart';
import '../entities/named_address_entity.dart';
import '../repositories/i_places_repo.dart';

part 'nearby_places.g.dart';

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
) =>
    getIt.call<IPlacesRepo>().getAutocompleteSuggestions(
          term.trim(),
        );
