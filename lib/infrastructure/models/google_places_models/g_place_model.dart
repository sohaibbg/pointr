import '../../../domain/entities/coordinates_entity.dart';
import '../../../domain/entities/named_address_entity.dart';

class GPlaceModel {
  final Map displayName;
  final String shortFormattedAddress;
  final Map location;

  const GPlaceModel._({
    required this.displayName,
    required this.shortFormattedAddress,
    required this.location,
  });

  factory GPlaceModel.fromMap(Map m) => GPlaceModel._(
        displayName: m['displayName'],
        shortFormattedAddress: m['shortFormattedAddress'],
        location: m['location'],
      );

  NamedAddressEntity toNamedAddressEntity() => NamedAddressEntity(
        coordinates: CoordinatesEntity(
          location['latitude'],
          location['longitude'],
        ),
        name: displayName['text'],
        address: shortFormattedAddress,
      );
}
