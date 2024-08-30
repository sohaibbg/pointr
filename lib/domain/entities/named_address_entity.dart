part of 'searchable_place.dart';

class NamedAddressEntity extends AddressEntity {
  const NamedAddressEntity({
    required super.coordinates,
    required super.address,
    required this.name,
  });

  @override
  // ignore: overridden_fields
  final String name;
}
