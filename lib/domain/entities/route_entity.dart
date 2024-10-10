import 'dart:convert';

import 'package:dart_mappable/dart_mappable.dart';

import 'coordinates_entity.dart';

part 'route_entity.mapper.dart';

@MappableEnum()
enum RouteMode {
  acBus("AC Bus"),
  chinchi("Chinchi"),
  minibus("Minibus");

  final String name;

  const RouteMode(this.name);
}

@MappableClass()
class RouteEntity with RouteEntityMappable {
  final List<CoordinatesEntity> points;
  final String name;
  final RouteMode mode;
  final bool isHardcoded;

  const RouteEntity({
    required this.name,
    required this.mode,
    required this.points,
    this.isHardcoded = false,
  });

  String toBase64() {
    final list = {
      'name': name,
      'mode': mode.name,
      'points': points
          .map(
            (e) => [e.latitude, e.longitude],
          )
          .toList(),
    };
    final str = jsonEncode(list);
    final bytes = utf8.encode(str);
    return base64.encode(bytes);
  }

  factory RouteEntity.fromBase64(String bytes) {
    final decoded = base64.decode(bytes);
    final str = utf8.decode(decoded);
    final obj = jsonDecode(str);
    final list = (obj['points'] as List)
        .map(
          (e) => CoordinatesEntity(
            e.first,
            e.last,
          ),
        )
        .toList();
    final mode = RouteMode.values.firstWhere(
      (e) => e.name == obj['mode'],
    );
    return RouteEntity(
      name: obj['name'],
      mode: mode,
      points: list,
    );
  }

  /// [point1] and [point2] are considered to
  /// be located on this route
  List<CoordinatesEntity> subRoutePoints(
    CoordinatesEntity point1,
    CoordinatesEntity point2,
  ) {
    if (point1 == point2) throw 'points 1 and 2 are the same';
    final result = <CoordinatesEntity>[];
    double point1MinDist = double.infinity;
    double point2MinDist = double.infinity;
    int iWhere1Min = -1;
    int iWhere2Min = -1;
    for (int i = 0; i < points.length - 1; i++) {
      final segment = RouteEntity(
        name: '',
        mode: RouteMode.acBus,
        points: [points[i], points[i + 1]],
      );
      final point1Dist = segment
          .pointOfClosestApproachFrom(point1)
          .euclideanDistanceFrom(point1);
      if (point1Dist < point1MinDist) {
        point1MinDist = point1Dist;
        iWhere1Min = i;
      }
      final point2Dist = segment
          .pointOfClosestApproachFrom(point2)
          .euclideanDistanceFrom(point2);
      if (point2Dist < point2MinDist) {
        point2MinDist = point2Dist;
        iWhere2Min = i;
      }
    }
    if (iWhere1Min == iWhere2Min) {
      final first = points[iWhere1Min];
      final is1Closer = first.euclideanDistanceFrom(point1) <
          first.euclideanDistanceFrom(point2);
      if (is1Closer) return [point1, point2];
      return [point2, point1];
    }
    late final int iStart;
    late final int iEnd;
    late final CoordinatesEntity startPoint;
    late final CoordinatesEntity endPoint;
    if (iWhere1Min < iWhere2Min) {
      iStart = iWhere1Min + 1;
      iEnd = iWhere2Min;
      startPoint = point1;
      endPoint = point2;
    }
    if (iWhere1Min > iWhere2Min) {
      iStart = iWhere2Min + 1;
      iEnd = iWhere1Min;
      startPoint = point2;
      endPoint = point1;
    }
    final midPoints = points.sublist(iStart, iEnd + 1);
    // for debugging, this should be unreachable code
    if (midPoints.isEmpty) {
      throw {
        'iWhere1Min': iWhere1Min,
        'iWhere2Min': iWhere2Min,
        'iStart': iStart,
        'iEnd': iEnd,
        'startPoint': startPoint,
        'endPoint': endPoint,
      };
    }
    result.addAll(midPoints);
    if (startPoint != midPoints.first) result.insert(0, startPoint);
    if (endPoint != midPoints.last) result.insert(result.length, endPoint);
    return result;
  }

  bool isCoordinateOnRoute(CoordinatesEntity c) {
    if (points.contains(c)) return true;
    final distanceFromRoute =
        pointOfClosestApproachFrom(c).euclideanDistanceFrom(c);
    return distanceFromRoute == 0;
  }

  /// higher the score, lesser the distance
  /// to and from the departure and destination
  /// respectively, and the travel distance
  double distanceScore(
    CoordinatesEntity point1,
    CoordinatesEntity point2,
  ) {
    final point1POCA = pointOfClosestApproachFrom(point1);
    final point2POCA = pointOfClosestApproachFrom(point2);
    final point1Walk = point1.euclideanDistanceFrom(point1POCA);
    final point2Walk = point2.euclideanDistanceFrom(point2POCA);
    final subRoute = RouteEntity(
      name: '',
      mode: RouteMode.acBus,
      points: subRoutePoints(point1, point2),
    );
    final sum = -point1Walk - point2Walk - (0.1 * subRoute.totalDistance);
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
