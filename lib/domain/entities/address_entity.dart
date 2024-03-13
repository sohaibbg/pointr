import 'coordinates_entity.dart';

class AddressEntity {
  final CoordinatesEntity coordinates;
  final String address;

  const AddressEntity({
    required this.coordinates,
    required this.address,
  });
}
