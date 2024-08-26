import 'dart:math';

import 'package:dart_mappable/dart_mappable.dart';

part 'coordinates_entity.mapper.dart';

@MappableClass(hook: _E())
class CoordinatesEntity with CoordinatesEntityMappable {
  final double latitude;
  final double longitude;

  const CoordinatesEntity(this.latitude, this.longitude);

  factory CoordinatesEntity.centerOf(
    CoordinatesEntity first,
    CoordinatesEntity second,
  ) =>
      CoordinatesEntity(
        (first.latitude + second.latitude) / 2,
        (first.longitude + second.longitude) / 2,
      );

  double euclideanDistanceFrom(CoordinatesEntity latLng) {
    final dy = latitude - latLng.latitude;
    final dx = longitude - latLng.longitude;
    return sqrt(dx * dx + dy * dy);
  }

  /// https://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment
  /// credit to Joshua, https://stackoverflow.com/users/368954
  CoordinatesEntity pointOfClosestApproach(
    CoordinatesEntity linePointA,
    CoordinatesEntity linePointB,
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
    return CoordinatesEntity(
      linePointA.latitude + param * c,
      linePointA.longitude + param * d,
    );
  }
}

class _E extends MappingHook {
  const _E();

  @override
  Object? afterEncode(Object? value) => [
        (value as Map)['latitude'],
        value['longitude'],
      ];

  @override
  Object? beforeDecode(Object? value) => {
        'latitude': (value as Iterable).first,
        'longitude': value.last,
      };
}
