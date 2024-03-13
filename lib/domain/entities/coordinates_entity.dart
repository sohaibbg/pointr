import 'dart:math';

class CoordinatesEntity {
  final double latitude;
  final double longitude;

  const CoordinatesEntity(this.latitude, this.longitude);

  List<double> toJson() => [latitude, longitude];

  factory CoordinatesEntity.fromJson(List<double> list) =>
      CoordinatesEntity(list.first, list.last);

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
