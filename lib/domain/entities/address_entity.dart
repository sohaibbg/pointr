// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  @override
  String toString() =>
      'AddressEntity(coordinates: $coordinates, address: $address)';
}
