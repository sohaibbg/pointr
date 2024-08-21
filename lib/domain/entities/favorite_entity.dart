import 'package:dart_mappable/dart_mappable.dart';

import 'address_entity.dart';
import 'coordinates_entity.dart';

part 'favorite_entity.mapper.dart';

@MappableClass()
class FavoriteEntity extends AddressEntity with FavoriteEntityMappable {
  final String name;

  const FavoriteEntity({
    required super.coordinates,
    required this.name,
  }) : super(address: name);
}
