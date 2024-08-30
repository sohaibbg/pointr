part of 'searchable_place.dart';

@MappableClass()
class FavoriteEntity extends AddressEntity with FavoriteEntityMappable {
  @override
  // ignore: overridden_fields
  final String name;

  const FavoriteEntity({
    required super.coordinates,
    required this.name,
  }) : super(address: name);
}
