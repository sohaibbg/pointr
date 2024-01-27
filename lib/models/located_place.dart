import 'coordinates.dart';
import 'place.dart';

class LocatedPlace implements Place {
  @override
  final String title;
  final Coordinates coordinates;

  const LocatedPlace({
    required this.title,
    required this.coordinates,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'coordinates': coordinates.toJson(),
      };

  factory LocatedPlace.fromJson(Map<String, dynamic> map) => LocatedPlace(
        title: map['title'],
        coordinates: Coordinates.fromJson(
          List<double>.from(map['coordinates']),
        ),
      );
}
