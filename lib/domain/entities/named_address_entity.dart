import 'address_entity.dart';

class NamedAddressEntity extends AddressEntity {
  const NamedAddressEntity({
    required super.coordinates,
    required super.address,
    required this.name,
  });

  final String name;
}
