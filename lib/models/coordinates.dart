import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../repo/google_places_api.dart';

@JsonSerializable()
class Coordinates {
  final double latitude;
  final double longitude;

  const Coordinates(this.latitude, this.longitude);

  factory Coordinates.fromLatLng(LatLng latLng) => Coordinates(
        latLng.latitude,
        latLng.longitude,
      );
  factory Coordinates.fromPosition(Position position) => Coordinates(
        position.latitude,
        position.longitude,
      );
  LatLng get latLng => LatLng(latitude, longitude);

  List<double> toJson() => [latitude, longitude];
  factory Coordinates.fromJson(List<double> list) =>
      Coordinates(list.first, list.last);

  Future<String> getNameSuggestionFromGoogle() =>
      GooglePlacesApi.nameFromCoordinates(this);

  double euclideanDistanceFrom(Coordinates latLng) {
    final dy = latitude - latLng.latitude;
    final dx = longitude - latLng.longitude;
    return sqrt(dx * dx + dy * dy);
  }

  /// https://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment
  /// credit to Joshua, https://stackoverflow.com/users/368954
  Coordinates pointOfClosestApproach(
    Coordinates linePointA,
    Coordinates linePointB,
  ) {
    final a = latitude - linePointA.latitude;
    final b = longitude - linePointA.longitude;
    final c = linePointB.latitude - linePointA.latitude;
    final d = linePointB.longitude - linePointA.longitude;

    final dot = a * c + b * d;
    final lenSq = c * c + d * d;
    final param = lenSq == 0 ? -1 : dot / lenSq;

    if (param < 0) return linePointA;
    if (param > 1) return linePointB;
    return Coordinates(
      linePointA.latitude + param * c,
      linePointA.longitude + param * d,
    );
  }
}
