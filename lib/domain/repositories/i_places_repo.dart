import 'package:injectable/injectable.dart';

import '../entities/autocomplete_suggestion_entity.dart';
import '../entities/coordinates_entity.dart';
import '../entities/named_address_entity.dart';
import 'i_location_repo.dart';

@test
@injectable
class IPlacesRepo {
  Future<String> getNameFrom(
    CoordinatesEntity coordinatesEntity,
  ) =>
      Future(
        () => 'the name the name the name the name the name the name the name ',
      );

  Future<List<NamedAddressEntity>> getNearbyPlaces(
    CoordinatesEntity coordinatesEntity,
  ) =>
      Future(
        () => [
          const NamedAddressEntity(
            coordinates: karachiLatLng,
            address:
                'address address address address address address address address address address address address ',
            name:
                'name name name name name name name name name name name name name name name name ',
          ),
          const NamedAddressEntity(
            coordinates: karachiLatLng,
            address:
                'address2 address address address address address address address address address address address ',
            name:
                'name2 name name name name name name name name name name name name name name name ',
          ),
          const NamedAddressEntity(
            coordinates: karachiLatLng,
            address:
                'address3 address address address address address address address address address address address ',
            name:
                'name3 name name name name name name name name name name name name name name name ',
          ),
          const NamedAddressEntity(
            coordinates: karachiLatLng,
            address:
                'address3 address address address address address address address address address address address ',
            name:
                'name3 name name name name name name name name name name name name name name name ',
          ),
        ],
      );

  Future<List<AutocompleteSuggestionEntity>> getAutocompleteSuggestions(
    String searchTerm,
  ) =>
      Future(
        () => const [
          AutocompleteSuggestionEntity(
            id: 'some id',
            address:
                'address address address address address address address address address address address address address address address address address address address address address address address address address ',
            name:
                'name name name name name name name name name name name name name name name name name name name name name name name name name ',
          ),
          AutocompleteSuggestionEntity(
            id: 'some id',
            address:
                'address2 address address address address address address address address address address address address address address address address address address address address address address address address ',
            name:
                'name2 name name name name name name name name name name name name name name name name name name name name name name name name ',
          ),
          AutocompleteSuggestionEntity(
            id: 'some id',
            address:
                'address3 address address address address address address address address address address address address address address address address address address address address address address address address ',
            name:
                'name3 name name name name name name name name name name name name name name name name name name name name name name name name ',
          ),
          AutocompleteSuggestionEntity(
            id: 'some id',
            address:
                'address4 address address address address address address address address address address address address address address address address address address address address address address address address ',
            name:
                'name4 name name name name name name name name name name name name name name name name name name name name name name name name ',
          ),
        ],
      );

  Future<CoordinatesEntity> getCoordinatesFor(String placeId) =>
      Future(() => karachiLatLng);
}
