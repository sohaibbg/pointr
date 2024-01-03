import '../misc/smart_api_client.dart';
import '../models/coordinates.dart';
import '../models/google_place.dart';
import '../models/located_google_place.dart';

class GooglePlacesApi {
  static final _apiClient = SmartApiClient(_hostUrl);
  static const _hostUrl = 'https://maps.googleapis.com/maps/api';
  static const _apiKey = 'AIzaSyB8_Cux99uxPKiE307aBUffTgrzKFRva4w';
  static const _originCoordinates = Coordinates(24.8607, 67.0011);
  static const _radius = 200000;

  static Future<Coordinates> latLngFromPlaceId(
    String placeId,
  ) async {
    final response = await _apiClient.get<Map>(
      '$_hostUrl/geocode/json',
      queryParams: {
        'place_id': placeId,
        'key': _apiKey,
      },
    );
    final m = response['results'].first['geometry']['location'];
    return Coordinates(m['lat'], m['lng']);
  }

  static Future<List<GooglePlace>> autocomplete(
    String searchTerm,
  ) async {
    if (searchTerm.isEmpty) return [];
    // {"description": description, "place_id": placeId}
    final response = await _apiClient.get<Map>(
      '$_hostUrl/place/autocomplete/json',
      queryParams: {
        'input': searchTerm,
        'strictbounds': 'true',
        'location': _originCoordinates.toJson().toString(),
        'radius': '$_radius',
        'region': 'pk',
        'key': _apiKey,
      },
    );
    final predictions = response['predictions'] as List;
    return predictions
        .map<GooglePlace>(
          (e) => GooglePlace.fromMap(e),
        )
        .toList();
  }

  static Future<String> nameFromCoordinates(Coordinates coordinates) async {
    final response = await _apiClient.get<Map>(
      '_hostUrl/geocode/json',
      queryParams: {
        'latlng': '${coordinates.toString()},${coordinates.longitude}',
        'key': _apiKey,
      },
    );
    return response['results'].first['formatted_address'];
  }

  static Future<List<LocatedGooglePlace>> nearbyPlaces(
    Coordinates coordinates,
  ) async {
    final response = await _apiClient.get<Map>(
      "$_hostUrl/place/nearbysearch/json",
      queryParams: {
        "rankby": "prominence",
        "location": "${coordinates.latitude},${coordinates.longitude}",
        "radius": "100",
        "key": _apiKey,
      },
    );
    final results = response['results'] as List;
    return results
        .map<LocatedGooglePlace>(
          (e) => LocatedGooglePlace.fromMap(e as Map),
        )
        .toList();
  }
}
