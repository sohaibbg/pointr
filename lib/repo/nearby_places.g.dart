// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_places.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nearbyPlacesBySearchTermHash() =>
    r'e99482b1900a37f9aa177fc4167bb7a7d73761a5';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [nearbyPlacesBySearchTerm].
@ProviderFor(nearbyPlacesBySearchTerm)
const nearbyPlacesBySearchTermProvider = NearbyPlacesBySearchTermFamily();

/// See also [nearbyPlacesBySearchTerm].
class NearbyPlacesBySearchTermFamily
    extends Family<AsyncValue<List<GooglePlace>>> {
  /// See also [nearbyPlacesBySearchTerm].
  const NearbyPlacesBySearchTermFamily();

  /// See also [nearbyPlacesBySearchTerm].
  NearbyPlacesBySearchTermProvider call(
    String term,
  ) {
    return NearbyPlacesBySearchTermProvider(
      term,
    );
  }

  @override
  NearbyPlacesBySearchTermProvider getProviderOverride(
    covariant NearbyPlacesBySearchTermProvider provider,
  ) {
    return call(
      provider.term,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'nearbyPlacesBySearchTermProvider';
}

/// See also [nearbyPlacesBySearchTerm].
class NearbyPlacesBySearchTermProvider
    extends AutoDisposeFutureProvider<List<GooglePlace>> {
  /// See also [nearbyPlacesBySearchTerm].
  NearbyPlacesBySearchTermProvider(
    String term,
  ) : this._internal(
          (ref) => nearbyPlacesBySearchTerm(
            ref as NearbyPlacesBySearchTermRef,
            term,
          ),
          from: nearbyPlacesBySearchTermProvider,
          name: r'nearbyPlacesBySearchTermProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$nearbyPlacesBySearchTermHash,
          dependencies: NearbyPlacesBySearchTermFamily._dependencies,
          allTransitiveDependencies:
              NearbyPlacesBySearchTermFamily._allTransitiveDependencies,
          term: term,
        );

  NearbyPlacesBySearchTermProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.term,
  }) : super.internal();

  final String term;

  @override
  Override overrideWith(
    FutureOr<List<GooglePlace>> Function(NearbyPlacesBySearchTermRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NearbyPlacesBySearchTermProvider._internal(
        (ref) => create(ref as NearbyPlacesBySearchTermRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        term: term,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<GooglePlace>> createElement() {
    return _NearbyPlacesBySearchTermProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NearbyPlacesBySearchTermProvider && other.term == term;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, term.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NearbyPlacesBySearchTermRef
    on AutoDisposeFutureProviderRef<List<GooglePlace>> {
  /// The parameter `term` of this provider.
  String get term;
}

class _NearbyPlacesBySearchTermProviderElement
    extends AutoDisposeFutureProviderElement<List<GooglePlace>>
    with NearbyPlacesBySearchTermRef {
  _NearbyPlacesBySearchTermProviderElement(super.provider);

  @override
  String get term => (origin as NearbyPlacesBySearchTermProvider).term;
}

String _$nearbyPlacesFromCoordinatesHash() =>
    r'6b9877354477679f3f5f181b725f52e29d268bb3';

/// See also [nearbyPlacesFromCoordinates].
@ProviderFor(nearbyPlacesFromCoordinates)
const nearbyPlacesFromCoordinatesProvider = NearbyPlacesFromCoordinatesFamily();

/// See also [nearbyPlacesFromCoordinates].
class NearbyPlacesFromCoordinatesFamily
    extends Family<AsyncValue<List<GooglePlace>>> {
  /// See also [nearbyPlacesFromCoordinates].
  const NearbyPlacesFromCoordinatesFamily();

  /// See also [nearbyPlacesFromCoordinates].
  NearbyPlacesFromCoordinatesProvider call(
    Coordinates coordinates,
  ) {
    return NearbyPlacesFromCoordinatesProvider(
      coordinates,
    );
  }

  @override
  NearbyPlacesFromCoordinatesProvider getProviderOverride(
    covariant NearbyPlacesFromCoordinatesProvider provider,
  ) {
    return call(
      provider.coordinates,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'nearbyPlacesFromCoordinatesProvider';
}

/// See also [nearbyPlacesFromCoordinates].
class NearbyPlacesFromCoordinatesProvider
    extends AutoDisposeFutureProvider<List<GooglePlace>> {
  /// See also [nearbyPlacesFromCoordinates].
  NearbyPlacesFromCoordinatesProvider(
    Coordinates coordinates,
  ) : this._internal(
          (ref) => nearbyPlacesFromCoordinates(
            ref as NearbyPlacesFromCoordinatesRef,
            coordinates,
          ),
          from: nearbyPlacesFromCoordinatesProvider,
          name: r'nearbyPlacesFromCoordinatesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$nearbyPlacesFromCoordinatesHash,
          dependencies: NearbyPlacesFromCoordinatesFamily._dependencies,
          allTransitiveDependencies:
              NearbyPlacesFromCoordinatesFamily._allTransitiveDependencies,
          coordinates: coordinates,
        );

  NearbyPlacesFromCoordinatesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.coordinates,
  }) : super.internal();

  final Coordinates coordinates;

  @override
  Override overrideWith(
    FutureOr<List<GooglePlace>> Function(
            NearbyPlacesFromCoordinatesRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NearbyPlacesFromCoordinatesProvider._internal(
        (ref) => create(ref as NearbyPlacesFromCoordinatesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        coordinates: coordinates,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<GooglePlace>> createElement() {
    return _NearbyPlacesFromCoordinatesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NearbyPlacesFromCoordinatesProvider &&
        other.coordinates == coordinates;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, coordinates.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NearbyPlacesFromCoordinatesRef
    on AutoDisposeFutureProviderRef<List<GooglePlace>> {
  /// The parameter `coordinates` of this provider.
  Coordinates get coordinates;
}

class _NearbyPlacesFromCoordinatesProviderElement
    extends AutoDisposeFutureProviderElement<List<GooglePlace>>
    with NearbyPlacesFromCoordinatesRef {
  _NearbyPlacesFromCoordinatesProviderElement(super.provider);

  @override
  Coordinates get coordinates =>
      (origin as NearbyPlacesFromCoordinatesProvider).coordinates;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
