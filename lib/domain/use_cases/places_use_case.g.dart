// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'places_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$nearbyPlacesFromCoordinatesHash() =>
    r'5a9d3bf74a10a717428d4bbe14663548acdd0127';

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

/// See also [nearbyPlacesFromCoordinates].
@ProviderFor(nearbyPlacesFromCoordinates)
const nearbyPlacesFromCoordinatesProvider = NearbyPlacesFromCoordinatesFamily();

/// See also [nearbyPlacesFromCoordinates].
class NearbyPlacesFromCoordinatesFamily
    extends Family<AsyncValue<List<NamedAddressEntity>>> {
  /// See also [nearbyPlacesFromCoordinates].
  const NearbyPlacesFromCoordinatesFamily();

  /// See also [nearbyPlacesFromCoordinates].
  NearbyPlacesFromCoordinatesProvider call(
    CoordinatesEntity coordinates,
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
    extends FutureProvider<List<NamedAddressEntity>> {
  /// See also [nearbyPlacesFromCoordinates].
  NearbyPlacesFromCoordinatesProvider(
    CoordinatesEntity coordinates,
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

  final CoordinatesEntity coordinates;

  @override
  Override overrideWith(
    FutureOr<List<NamedAddressEntity>> Function(
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
  FutureProviderElement<List<NamedAddressEntity>> createElement() {
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
    on FutureProviderRef<List<NamedAddressEntity>> {
  /// The parameter `coordinates` of this provider.
  CoordinatesEntity get coordinates;
}

class _NearbyPlacesFromCoordinatesProviderElement
    extends FutureProviderElement<List<NamedAddressEntity>>
    with NearbyPlacesFromCoordinatesRef {
  _NearbyPlacesFromCoordinatesProviderElement(super.provider);

  @override
  CoordinatesEntity get coordinates =>
      (origin as NearbyPlacesFromCoordinatesProvider).coordinates;
}

String _$nameFromCoordinatesHash() =>
    r'026e664f5dbc6d4fdc74d91f0cc8ce751b6a5f4a';

/// See also [nameFromCoordinates].
@ProviderFor(nameFromCoordinates)
const nameFromCoordinatesProvider = NameFromCoordinatesFamily();

/// See also [nameFromCoordinates].
class NameFromCoordinatesFamily extends Family<AsyncValue<String>> {
  /// See also [nameFromCoordinates].
  const NameFromCoordinatesFamily();

  /// See also [nameFromCoordinates].
  NameFromCoordinatesProvider call(
    CoordinatesEntity coordinatesEntity,
  ) {
    return NameFromCoordinatesProvider(
      coordinatesEntity,
    );
  }

  @override
  NameFromCoordinatesProvider getProviderOverride(
    covariant NameFromCoordinatesProvider provider,
  ) {
    return call(
      provider.coordinatesEntity,
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
  String? get name => r'nameFromCoordinatesProvider';
}

/// See also [nameFromCoordinates].
class NameFromCoordinatesProvider extends AutoDisposeFutureProvider<String> {
  /// See also [nameFromCoordinates].
  NameFromCoordinatesProvider(
    CoordinatesEntity coordinatesEntity,
  ) : this._internal(
          (ref) => nameFromCoordinates(
            ref as NameFromCoordinatesRef,
            coordinatesEntity,
          ),
          from: nameFromCoordinatesProvider,
          name: r'nameFromCoordinatesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$nameFromCoordinatesHash,
          dependencies: NameFromCoordinatesFamily._dependencies,
          allTransitiveDependencies:
              NameFromCoordinatesFamily._allTransitiveDependencies,
          coordinatesEntity: coordinatesEntity,
        );

  NameFromCoordinatesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.coordinatesEntity,
  }) : super.internal();

  final CoordinatesEntity coordinatesEntity;

  @override
  Override overrideWith(
    FutureOr<String> Function(NameFromCoordinatesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: NameFromCoordinatesProvider._internal(
        (ref) => create(ref as NameFromCoordinatesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        coordinatesEntity: coordinatesEntity,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _NameFromCoordinatesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is NameFromCoordinatesProvider &&
        other.coordinatesEntity == coordinatesEntity;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, coordinatesEntity.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin NameFromCoordinatesRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `coordinatesEntity` of this provider.
  CoordinatesEntity get coordinatesEntity;
}

class _NameFromCoordinatesProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with NameFromCoordinatesRef {
  _NameFromCoordinatesProviderElement(super.provider);

  @override
  CoordinatesEntity get coordinatesEntity =>
      (origin as NameFromCoordinatesProvider).coordinatesEntity;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
