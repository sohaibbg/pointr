import 'package:freezed_annotation/freezed_annotation.dart';

import 'coordinates.dart';
import 'place.dart';

part 'located_place.g.dart';

@JsonSerializable()
class LocatedPlace implements Place {
  @override
  final String title;
  final Coordinates coordinates;

  const LocatedPlace(this.title, this.coordinates);

  Map<String, dynamic> toJson() => {
        'title': title,
        'coordinates': coordinates.toJson(),
      };

  factory LocatedPlace.fromJson(Map<String, dynamic> map) => LocatedPlace(
        map['title'],
        Coordinates.fromJson(
          map['coordinates'],
        ),
      );
}
