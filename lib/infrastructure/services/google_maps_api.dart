import 'dart:async';

import '../../config/env.dart';
import '../../domain/entities/coordinates_entity.dart';
import '../models/google_places_models/g_map_result_model.dart';
import 'packages/smart_api_client.dart';

abstract class GoogleMapsApi {
  static const _apiKey = ENV.gmapKey;
  static final _mapsApiClient = SmartApiClient('maps.googleapis.com');

  static Future<List<GMapResultModel>> reverseGeocode(
    CoordinatesEntity coordinates,
  ) async {
    final response = await _mapsApiClient.get<Map>(
      'maps/api/geocode/json',
      queryParams: {
        'latlng': '${coordinates.latitude},${coordinates.longitude}',
        'key': _apiKey,
      },
    );
    final objectList = response['results'] as List;
    return objectList
        .map(
          (e) => GMapResultModel.fromMap(e),
        )
        .toList();
  }
}
