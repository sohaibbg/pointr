import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointr/classes/google_place.dart';

class LocatedGooglePlace implements GooglePlace {
  @override
  final String placeId;
  @override
  final String title;
  final LatLng latLng;
  final String subtitle;

  const LocatedGooglePlace({
    required this.placeId,
    required this.title,
    required this.latLng,
    required this.subtitle,
  });
}
