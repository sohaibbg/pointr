import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class GMapsApi {
  static const String hostUrl = 'https://maps.googleapis.com/maps/api';
  static const String apiKey = '';
  static const String originLatLng = '24.8607,67.0011';
  static const double radius = 200000;

  /// returns {"description":description, "place_id":placeId} or error String
  static Future<Object> autocomplete(String searchTerm) async {
    if (searchTerm.isEmpty) return <Map>[];
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
      return jsonDecode(await response.stream.bytesToString())['predictions']
          .map<Map>(
            (e) => {
              "title": e["description"],
              "place_id": e["place_id"],
            },
          )
          .toList();
    } else {
      return response.reasonPhrase ?? "Error";
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

  static Future<Iterable<Map>?> nearbyPlaces(LatLng latLng) async {
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
      return jsonDecode(await response.stream.bytesToString())['results']
          .map<Map>(
        (e) => {
          "title": e['name'],
          "latLng": LatLng(
            e['geometry']['location']['lat'],
            e['geometry']['location']['lng'],
          ),
          "subtitle": e["vicinity"]
        },
      );
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
