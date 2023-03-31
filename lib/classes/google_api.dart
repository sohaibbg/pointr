import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pointr/classes/google_place.dart';
import 'package:pointr/classes/located_google_place.dart';

class GoogleApi {
  static const String hostUrl = 'https://maps.googleapis.com/maps/api';
  static const String apiKey = 'AIzaSyB8_Cux99uxPKiE307aBUffTgrzKFRva4w';
  static const String originLatLng = '24.8607,67.0011';
  static const double radius = 200000;

  /// returns {"description":description, "place_id":placeId} or error String
  static Future<List<GooglePlace>> autocomplete(String searchTerm) async {
    if (searchTerm.isEmpty) return [];
    var headers = {'Accept': 'application/json'};
    var request = http.Request(
      'GET',
      Uri.parse(
        '$hostUrl/place/autocomplete/json?input=$searchTerm&strictbounds=true&location=$originLatLng&radius=$radius&region=pk&key=$apiKey',
      ),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var predictions =
          jsonDecode(await response.stream.bytesToString())['predictions'];
      return predictions
          .map<GooglePlace>(
            (e) => GooglePlace(
              title: e["description"],
              placeId: e["place_id"],
            ),
          )
          .toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  /// returns LatLng or error String from GMaps placeId
  static Future<LatLng> latLngFromPlaceId(String placeId) async {
    var headers = {'Accept': 'application/json'};
    var request = http.Request(
      'GET',
      Uri.parse(
        '$hostUrl/geocode/json?place_id=$placeId&key=$apiKey',
      ),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      Map m = jsonDecode(await response.stream.bytesToString())['results']
          .first['geometry']['location'];
      return LatLng(m['lat'], m['lng']);
    } else {
      throw Exception(
          response.reasonPhrase ?? "Error in fetching LatLng from placeId");
    }
  }

  /// returns LatLng or error String from GMaps placeId
  static Future<String> nameFromLatLng(LatLng latLng) async {
    var headers = {'Accept': 'application/json'};
    var request = http.Request(
      'GET',
      Uri.parse(
        '$hostUrl/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=$apiKey',
      ),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return jsonDecode(await response.stream.bytesToString())['results']
          .first['formatted_address'];
    } else {
      return '${latLng.latitude},${latLng.longitude}';
    }
  }

  static Future<List<LocatedGooglePlace>?> nearbyPlaces(LatLng latLng) async {
    var headers = {
      'Accept': 'application/json',
    };
    var request = http.Request(
      'GET',
      Uri.parse(
        "$hostUrl/place/nearbysearch/json?rankby=prominence&location=${latLng.latitude},${latLng.longitude}&radius=100&key=$apiKey",
      ),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var results = jsonDecode(
        await response.stream.bytesToString(),
      )['results'];
      return results
          .map<LocatedGooglePlace>(
            (e) => LocatedGooglePlace(
              placeId: e['place_id'],
              title: e['name'],
              latLng: LatLng(
                e['geometry']['location']['lat'],
                e['geometry']['location']['lng'],
              ),
              subtitle: e["vicinity"],
            ),
          )
          .toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
