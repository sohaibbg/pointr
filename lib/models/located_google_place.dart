import 'coordinates.dart';
import 'google_place.dart';
import 'located_place.dart';

class LocatedGooglePlace implements GooglePlace, LocatedPlace {
  @override
  final String googlePlaceId;
  @override
  final String title;
  final String subtitle;
  @override
  final Coordinates coordinates;

  const LocatedGooglePlace({
    required this.googlePlaceId,
    required this.title,
    required this.coordinates,
    required this.subtitle,
  });

  @override
  Coordinates getCoordinate() => coordinates;

  @override
  factory LocatedGooglePlace.fromMap(Map map) => LocatedGooglePlace(
        googlePlaceId: map['place_id'],
        title: map['name'],
        coordinates: Coordinates(
          map['geometry']['location']['lat'],
          map['geometry']['location']['lng'],
        ),
        subtitle: map["vicinity"],
      );

  @override
  Map<String, Object?> toJson() => {
        'place_id': googlePlaceId,
        'name': title,
        'geometry': {
          'location': {
            'lat': coordinates.latitude,
            'lng': coordinates.longitude,
          },
        },
        'vicinity': subtitle,
      };
}
