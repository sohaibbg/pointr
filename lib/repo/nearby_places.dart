import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/coordinates.dart';
import '../models/google_place.dart';
import 'google_places_api.dart';

part 'nearby_places.g.dart';

@riverpod
Future<List<GooglePlace>> nearbyPlacesBySearchTerm(
  NearbyPlacesBySearchTermRef ref,
  String term,
) async =>
    term.trim().isEmpty
        ? <GooglePlace>[]
        : await GooglePlacesApi.autocomplete(
            term.trim(),
          );

@riverpod
Future<List<GooglePlace>> nearbyPlacesFromCoordinates(
  NearbyPlacesFromCoordinatesRef ref,
  Coordinates coordinates,
) =>
    GooglePlacesApi.nearbyPlaces(coordinates);
