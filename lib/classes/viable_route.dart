import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointr/classes/lat_lng_extension.dart';

class ViableRoute {
  double score;
  Polyline polyline;
  LatLng onboard, offload;

  ViableRoute(this.score, this.polyline, this.onboard, this.offload);

  void recolor(Color color) => polyline = polyline.copyWith(colorParam: color);

  factory ViableRoute.between(
    LatLng departure,
    LatLng destination,
    Polyline route,
  ) {
    // generate onboard
    LatLng onboard = departure.pointNearestToRoute(route);
    // generate offload
    LatLng offload = destination.pointNearestToRoute(route);
    // calculate score
    double departDist = sqrt(departure.distanceFrom(onboard));
    double destDist = sqrt(destination.distanceFrom(offload));
    double travelDist = 0;
    // for (int i = 1; i < route.points.length - 1; i++) {
    //   travelDist += sqrt(distance(route.points[i], route.points[i - 1]));
    // }
    double score = departDist + destDist + travelDist;
    score = score * 1000;
    score = score.truncateToDouble();
    return ViableRoute(score, route, onboard, offload);
  }
}
