import 'coordinates_entity.dart';

class FavoriteEntity {
  final CoordinatesEntity coordinates;
  final String name;

  const FavoriteEntity({
    required this.coordinates,
    required this.name,
  });
}
