import 'dart:async';

import '../repo/google_places_api.dart';
import 'coordinates.dart';
import 'place.dart';

class GooglePlace extends Place {
  final String googlePlaceId;

  const GooglePlace({
    required this.googlePlaceId,
    required super.title,
  });

  FutureOr<Coordinates> getCoordinate() =>
      GooglePlacesApi.latLngFromPlaceId(googlePlaceId);

  factory GooglePlace.fromMap(Map map) => GooglePlace(
        title: map["description"],
        googlePlaceId: map["place_id"],
      );
}
