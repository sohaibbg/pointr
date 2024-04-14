import 'coordinates_entity.dart';

class FavoriteEntity {
  final CoordinatesEntity coordinates;
  final String name;

  const FavoriteEntity({
    required this.coordinates,
    required this.name,
  });

  @override
  bool operator ==(covariant FavoriteEntity other) => identical(this, other)
      ? true
      : other.coordinates == coordinates && other.name == name;

  @override
  int get hashCode => coordinates.hashCode ^ name.hashCode;
}
