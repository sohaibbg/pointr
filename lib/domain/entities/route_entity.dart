import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'coordinates_entity.dart';

enum RouteMode { bus, acBus, pinkBus, chinchi, greenLine }

class RouteEntity {
  final IList<CoordinatesEntity> points;
  final String name;
  final RouteMode mode;

  const RouteEntity({
    required this.name,
    required this.mode,
    required this.points,
  });

  factory RouteEntity.fromMap(Map map) {
    final name = map['name'] as String;
    final mode = RouteMode.values.firstWhere(
      (element) => element.name == map['mode'],
    );
    final points = map['points'] as List;
    final parsedPoints = points
        .map(
          (e) => CoordinatesEntity.fromJson(List<double>.from(e)),
        )
        .toIList();
    return RouteEntity(name: name, mode: mode, points: parsedPoints);
  }

  /// higher the score, lesser the distance
  /// to and from the departure and destination
  /// respectively, and the travel distance
  double distanceScore(
    CoordinatesEntity departure,
    CoordinatesEntity destination,
  ) {
    final onboard = pointOfClosestApproachFrom(departure);
    final offload = pointOfClosestApproachFrom(destination);
    final departDist = departure.euclideanDistanceFrom(onboard);
    final destDist = destination.euclideanDistanceFrom(offload);
    final sum = departDist + destDist + sqrt(totalDistance);
    return 1 / sum;
  }

  double get totalDistance {
    assert(points.isNotEmpty);
    if (points.length == 1) return 0;
    double sumDistance = 0;
    for (int i = 0; i < points.length - 1; i++) {
      final lineSegmentPointA = points[i];
      final lineSegmentPointB = points[i + 1];
      sumDistance += lineSegmentPointA.euclideanDistanceFrom(
        lineSegmentPointB,
      );
    }
    return sumDistance;
  }

  /// calculates distance between each component
  /// line segment and the point and returns the
  /// one with the smallest distance
  CoordinatesEntity pointOfClosestApproachFrom(CoordinatesEntity coordinates) {
    // must have at least two points to create
    // at least one line segment to be compared
    assert(points.length > 1);
    // euclidean distance will be the metric of
    // comparison
    double minDistance = double.infinity;
    late CoordinatesEntity nearest;
    for (int i = 0; i < points.length - 1; i++) {
      final lineSegmentPointA = points[i];
      final lineSegmentPointB = points[i + 1];

      final pointOfClosestApproachForThisLineSegment =
          coordinates.pointOfClosestApproach(
        lineSegmentPointA,
        lineSegmentPointB,
      );
      final shortestDistanceBetweenPointAndLineSegment =
          coordinates.euclideanDistanceFrom(
        pointOfClosestApproachForThisLineSegment,
      );

      if (shortestDistanceBetweenPointAndLineSegment >= minDistance) continue;
      minDistance = shortestDistanceBetweenPointAndLineSegment;
      nearest = pointOfClosestApproachForThisLineSegment;
    }
    return nearest;
  }
}
