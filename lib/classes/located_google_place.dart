import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointr/classes/google_place.dart';

class LocatedGooglePlace extends GooglePlace {
  final LatLng latLng;
  final String subtitle;

  const LocatedGooglePlace({
    required super.placeId,
    required super.title,
    required this.latLng,
    required this.subtitle,
  });
}
