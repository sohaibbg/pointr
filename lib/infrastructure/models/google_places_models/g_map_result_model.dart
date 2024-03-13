class GMapResultModel {
  final List<_AddressComponent> _addressComponents;
  final dynamic formattedAddress;
  final dynamic geometry;
  final String placeId;
  final dynamic types;

  const GMapResultModel._({
    required List<_AddressComponent> addressComponents,
    required this.formattedAddress,
    required this.geometry,
    required this.placeId,
    required this.types,
  }) : _addressComponents = addressComponents;

  factory GMapResultModel.fromMap(Map map) => GMapResultModel._(
        addressComponents: (map['address_components'] as List)
            .map(
              (e) => _AddressComponent.fromMap(e),
            )
            .toList(),
        formattedAddress: map['formatted_address'],
        geometry: map['geometry'],
        placeId: map['place_id'],
        types: map['types'],
      );

  String toShortAddress() {
    // these types are in the order of least
    // priority to be used in the name
    const typesToRemove = [
      'plus_code',
      'country',
      'administrative_area_level_1',
      'administrative_area_level_2',
      'administrative_area_level_3',
      'locality',
      'postal_code',
    ];
    // removes undesired components if they
    // are pushing component length over 3
    final addressComponentsSelection = _addressComponents.toList();
    while (addressComponentsSelection.length > 3 &&
        addressComponentsSelection.any(
          (acs) => acs.types.any(
            (t) => typesToRemove.contains(t),
          ),
        )) {
      for (final t in typesToRemove) {
        final lengthBefore = addressComponentsSelection.length;
        addressComponentsSelection.removeWhere(
          (ac) => ac.types.contains(t),
        );
        final didRemove = lengthBefore > addressComponentsSelection.length;
        if (didRemove) break;
      }
    }
    return addressComponentsSelection
        .map(
          (e) => e.shortName,
        )
        .join(', ');
  }
}

class _AddressComponent {
  final String longName;
  final String shortName;
  final List<String> types;

  const _AddressComponent({
    required this.longName,
    required this.shortName,
    required this.types,
  });

  factory _AddressComponent.fromMap(Map<String, dynamic> json) =>
      _AddressComponent(
        longName: json['long_name'],
        shortName: json['short_name'],
        types: List<String>.from(
          json['types'],
        ),
      );
}
