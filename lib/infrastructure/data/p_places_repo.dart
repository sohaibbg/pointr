import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/coordinates_entity.dart';
import '../../domain/entities/searchable_place.dart';
import '../../domain/repositories/i_places_repo.dart';
import '../services/google_maps_api.dart';
import '../services/google_places_api.dart';

@prod
@dev
@Injectable(as: IPlacesRepo)
class PPlacesRepo implements IPlacesRepo {
  // config for searching places
  static const _originCoordinates = CoordinatesEntity(24.8607, 67.0011);
  // state for autocomplete sessions
  static const _uuid = Uuid();
  static String? _sessionToken;
  static Timer? _sessionTimer;

  @override
  Future<List<AutocompleteSuggestionEntity>> getAutocompleteSuggestions(
    String searchTerm,
  ) {
    if (searchTerm.isEmpty) return Future(() => []);
    // set session token if was previously null
    _sessionToken ??= _uuid.v4();
    // extend timer to eventually expire said token
    _sessionTimer?.cancel();
    _sessionTimer = Timer(
      const Duration(seconds: 90),
      () => _sessionToken = null,
    );
    return GooglePlacesApi.autocomplete(
      searchTerm,
      radius: 50000,
      coordinates: _originCoordinates,
      sessionToken: _sessionToken!,
    ).then(
      (value) => value
          .map(
            (e) => e.toAutocompleteSuggestionEntity(),
          )
          .toList(),
    );
  }

  @override
  Future<CoordinatesEntity> getCoordinatesFor(String placeId) =>
      GooglePlacesApi.latLngFrom(
        placeId,
        sessionToken: _sessionToken,
      );

  @override
  Future<String> getNameFrom(CoordinatesEntity coordinatesEntity) =>
      GoogleMapsApi.reverseGeocode(coordinatesEntity).then(
        (value) => value.first.toShortAddress(),
      );

  @override
  Future<List<NamedAddressEntity>> getNearbyPlaces(
    CoordinatesEntity coordinatesEntity,
  ) =>
      GooglePlacesApi.searchNearby(
        coordinatesEntity,
        radius: 1000,
      ).then(
        (value) => value
            .map(
              (e) => e.toNamedAddressEntity(),
            )
            .toList(),
      );
}
