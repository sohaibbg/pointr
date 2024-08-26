import 'dart:math';

import 'package:dart_mappable/dart_mappable.dart';

import 'coordinates_entity.dart';

part 'route_entity.mapper.dart';

@MappableEnum()
enum RouteMode {
  minibus("Minibus"),
  redBus("Red Bus"),
  pinkBus("Pink Bus"),
  chinchi("Chinchi"),
  greenLine("Green Line");

  final String name;

  const RouteMode(this.name);
}

@MappableClass()
class RouteEntity with RouteEntityMappable {
  final List<CoordinatesEntity> points;
  final String name;
  final RouteMode mode;

  const RouteEntity({
    required this.name,
    required this.mode,
    required this.points,
  });

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

  ({
    CoordinatesEntity northEast,
    CoordinatesEntity southWest,
  }) getBounds() {
    double north = double.negativeInfinity;
    double east = double.negativeInfinity;
    double south = double.infinity;
    double west = double.infinity;
    for (final c in points) {
      if (c.latitude > north) north = c.latitude;
      if (c.longitude > east) east = c.longitude;
      if (c.latitude < south) south = c.latitude;
      if (c.longitude < west) west = c.longitude;
    }
    return (
      northEast: CoordinatesEntity(north, east),
      southWest: CoordinatesEntity(south, west),
    );
  }

  /// does not use standard area units, just latitude diff * longitude diff
  double getAreaCoveredByBounds() {
    final bounds = getBounds();
    final height = bounds.northEast.latitude - bounds.southWest.latitude;
    final width = bounds.northEast.longitude - bounds.southWest.longitude;
    return height * width;
  }
}
