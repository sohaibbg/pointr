part of 'searchable_place.dart';

@MappableClass()
class RecentEntity extends AddressEntity with RecentEntityMappable {
  @override
  // ignore: overridden_fields
  final String name;

  const RecentEntity({
    required super.coordinates,
    required this.name,
  }) : super(address: name);
}
