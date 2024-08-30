part of 'searchable_place.dart';

class AddressEntity extends SearchablePlace {
  final CoordinatesEntity coordinates;
  final String address;

  const AddressEntity({
    required this.coordinates,
    required this.address,
  }) : super(name: address);

  AddressEntity toAddressEntity() => AddressEntity(
        coordinates: coordinates,
        address: address,
      );
}
