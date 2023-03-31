import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointr/classes/lat_lng_extension.dart';
import 'package:pointr/classes/viable_route.dart';

extension PolylineExtension on Polyline {
  ViableRoute between(
    LatLng departure,
    LatLng destination,
  ) {
    // generate onboard
    LatLng onboard = departure.pointNearestToRoute(this);
    // generate offload
    LatLng offload = destination.pointNearestToRoute(this);
    // calculate score
    double departDist = sqrt(departure.distanceFrom(onboard));
    double destDist = sqrt(destination.distanceFrom(offload));
    double travelDist = 0;
    // for (int i = 1; i < route.points.length - 1; i++) {
    //   travelDist += sqrt(distance(route.points[i], route.points[i - 1]));
    // }
    double score = departDist + destDist + travelDist;
    return ViableRoute(score, this, onboard, offload);
  }
}
