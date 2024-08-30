import 'dart:async';

import '../../config/env.dart';
import '../../domain/entities/coordinates_entity.dart';
import '../models/google_places_models/g_place_model.dart';
import '../models/google_places_models/g_place_prediction_model.dart';
import 'packages/smart_api_client.dart';

abstract class GooglePlacesApi {
  static const _apiKey = ENV.gmapKey;
  // http clients keep connections with their hosts
  static final _placesApiClient = SmartApiClient('places.googleapis.com');

  static Future<CoordinatesEntity> latLngFrom(
    String placeId, {
    required String? sessionToken,
  }) async {
    final response = await _placesApiClient.get<Map>(
      'v1/places/$placeId',
      queryParams: sessionToken == null
          ? null
          : {
              'sessionToken': sessionToken,
            },
      headers: {
        'X-Goog-Api-Key': _apiKey,
        'X-Goog-FieldMask': 'location',
      },
    );
    return CoordinatesEntity(
      response['location']['latitude'],
      response['location']['longitude'],
    );
  }

  static Future<List<GPlacePredictionModel>> autocomplete(
    String input, {
    required int radius,
    required CoordinatesEntity coordinates,
    required String sessionToken,
  }) async {
    // api policy
    assert(radius <= 50000);
    final body = {
      "input": input,
      'sessionToken': sessionToken,
      "locationRestriction": {
        "circle": {
          "center": {
            "latitude": coordinates.latitude,
            "longitude": coordinates.longitude,
          },
          "radius": radius,
        },
      },
    };
    final response = await _placesApiClient.post<Map>(
      'v1/places:autocomplete',
      body: body,
      headers: {
        'X-Goog-Api-Key': _apiKey,
      },
    );
    final objectList = response['suggestions'] as List;
    final result = objectList
        .map<GPlacePredictionModel>(
          (e) => GPlacePredictionModel.fromMap(
            e['placePrediction'],
          ),
        )
        .toList();
    return result;
  }

  static Future<List<GPlaceModel>> searchNearby(
    CoordinatesEntity coordinates, {
    required int radius,
    int length = 5,
  }) async {
    final headers = {
      'X-Goog-Api-Key': _apiKey,
      'X-Goog-FieldMask': [
        'places.displayName',
        'places.location',
        'places.shortFormattedAddress',
      ].join(','),
      'Content-Type': 'application/json',
    };
    final body = {
      "maxResultCount": length,
      "locationRestriction": {
        "circle": {
          "center": {
            "latitude": coordinates.latitude,
            "longitude": coordinates.longitude,
          },
          "radius": radius,
        },
      },
    };
    final response = await _placesApiClient.post<Map>(
      "v1/places:searchNearby",
      body: body,
      headers: headers,
    );
    final objectList = response['places'] as List;
    return objectList
        .map(
          (e) => GPlaceModel.fromMap(e),
        )
        .toList();
  }
}
