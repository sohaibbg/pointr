import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointr/classes/google_api.dart';

extension LatLngExtension on LatLng {
  Future<String> getName() async => await GoogleApi.nameFromLatLng(this);
  double distanceFrom(LatLng latLng) {
    double dy = latitude - latLng.latitude;
    double dx = longitude - latLng.longitude;
    return dx * dx + dy * dy;
  }

  /// https://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment
  /// credit to Joshua, https://stackoverflow.com/users/368954
  LatLng pointNearestToRoute(Polyline route) {
    List<LatLng> points = route.points;
    double minDistance = double.infinity;
    late LatLng nearest;
    for (int i = 0; i < points.length - 1; i++) {
      // s1-s2 makes line segment
      LatLng s1 = points[0];
      LatLng s2 = points[1];

      double a = latitude - s1.latitude;
      double b = longitude - s1.longitude;
      double c = s2.latitude - s1.latitude;
      double d = s2.longitude - s1.longitude;

      double dot = a * c + b * d;
      double lenSq = c * c + d * d;
      double param = -1;

      //in case of 0 length line
      if (lenSq != 0) param = dot / lenSq;

      double latOnSegment, lonOnSegment;

      if (param < 0) {
        latOnSegment = s1.latitude;
        lonOnSegment = s1.longitude;
      } else if (param > 1) {
        latOnSegment = s2.latitude;
        lonOnSegment = s2.longitude;
      } else {
        latOnSegment = s1.latitude + param * c;
        lonOnSegment = s1.longitude + param * d;
      }

      double dx = latitude - latOnSegment;
      double dy = longitude - lonOnSegment;
      double distanceFromSegment = dx * dx + dy * dy;
      if (distanceFromSegment < minDistance) {
        minDistance = distanceFromSegment;
        nearest = LatLng(latOnSegment, lonOnSegment);
      }
    }
    return nearest;
  }
}
