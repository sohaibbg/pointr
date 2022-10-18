import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils.dart';

class ViableRoute {
  double score;
  Polyline polyline;
  LatLng onboard, offload;

  ViableRoute(this.score, this.polyline, this.onboard, this.offload);

  void recolor(Color color) => polyline = polyline.copyWith(colorParam: color);

  static ViableRoute between(
    LatLng departure,
    LatLng destination,
    Polyline route,
  ) {
    // generate onboard
    LatLng onboard = routeIntercept(route, departure);
    // generate offload
    LatLng offload = routeIntercept(route, destination);
    // calculate score
    double departDist = sqrt(distance(departure, onboard));
    double destDist = sqrt(distance(destination, offload));
    double travelDist = 0;
    // for (int i = 1; i < route.points.length - 1; i++) {
    //   travelDist += sqrt(distance(route.points[i], route.points[i - 1]));
    // }
    double score = departDist + destDist + travelDist;
    return ViableRoute(score, route, onboard, offload);
  }
}
