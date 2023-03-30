import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointr/classes/place.dart';

class Star implements Place {
  int id;
  @override
  String title;
  LatLng latLng;

  Star(this.id, this.title, this.latLng);

  @override
  String toString() => title;

  Map<String, Object?> toMap() => {
        'id': id,
        'name': title,
        'lat': latLng.latitude,
        'lng': latLng.longitude,
      };
}
