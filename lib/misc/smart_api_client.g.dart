// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_api_client.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$smartApiClientHash() => r'11ec826d14a931876e8996c63f1ae79731494c41';

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

/// See also [smartApiClient].
@ProviderFor(smartApiClient)
const smartApiClientProvider = SmartApiClientFamily();

/// See also [smartApiClient].
class SmartApiClientFamily extends Family<SmartApiClient> {
  /// See also [smartApiClient].
  const SmartApiClientFamily();

  /// See also [smartApiClient].
  SmartApiClientProvider call(
    String host,
  ) {
    return SmartApiClientProvider(
      host,
    );
  }

  @override
  SmartApiClientProvider getProviderOverride(
    covariant SmartApiClientProvider provider,
  ) {
    return call(
      provider.host,
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
  String? get name => r'smartApiClientProvider';
}

/// See also [smartApiClient].
class SmartApiClientProvider extends Provider<SmartApiClient> {
  /// See also [smartApiClient].
  SmartApiClientProvider(
    String host,
  ) : this._internal(
          (ref) => smartApiClient(
            ref as SmartApiClientRef,
            host,
          ),
          from: smartApiClientProvider,
          name: r'smartApiClientProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$smartApiClientHash,
          dependencies: SmartApiClientFamily._dependencies,
          allTransitiveDependencies:
              SmartApiClientFamily._allTransitiveDependencies,
          host: host,
        );

  SmartApiClientProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.host,
  }) : super.internal();

  final String host;

  @override
  Override overrideWith(
    SmartApiClient Function(SmartApiClientRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SmartApiClientProvider._internal(
        (ref) => create(ref as SmartApiClientRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        host: host,
      ),
    );
  }

  @override
  ProviderElement<SmartApiClient> createElement() {
    return _SmartApiClientProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SmartApiClientProvider && other.host == host;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, host.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SmartApiClientRef on ProviderRef<SmartApiClient> {
  /// The parameter `host` of this provider.
  String get host;
}

class _SmartApiClientProviderElement extends ProviderElement<SmartApiClient>
    with SmartApiClientRef {
  _SmartApiClientProviderElement(super.provider);

  @override
  String get host => (origin as SmartApiClientProvider).host;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
