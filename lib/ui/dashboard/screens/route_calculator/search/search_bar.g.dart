// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_bar.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchBarFocusNodeHash() =>
    r'f52ba75f4154ea1d010105f1bcdcf9ef1c077589';

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

/// See also [searchBarFocusNode].
@ProviderFor(searchBarFocusNode)
const searchBarFocusNodeProvider = SearchBarFocusNodeFamily();

/// See also [searchBarFocusNode].
class SearchBarFocusNodeFamily extends Family<FocusNode> {
  /// See also [searchBarFocusNode].
  const SearchBarFocusNodeFamily();

  /// See also [searchBarFocusNode].
  SearchBarFocusNodeProvider call(
    int i,
  ) {
    return SearchBarFocusNodeProvider(
      i,
    );
  }

  @override
  SearchBarFocusNodeProvider getProviderOverride(
    covariant SearchBarFocusNodeProvider provider,
  ) {
    return call(
      provider.i,
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
  String? get name => r'searchBarFocusNodeProvider';
}

/// See also [searchBarFocusNode].
class SearchBarFocusNodeProvider extends AutoDisposeProvider<FocusNode> {
  /// See also [searchBarFocusNode].
  SearchBarFocusNodeProvider(
    int i,
  ) : this._internal(
          (ref) => searchBarFocusNode(
            ref as SearchBarFocusNodeRef,
            i,
          ),
          from: searchBarFocusNodeProvider,
          name: r'searchBarFocusNodeProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchBarFocusNodeHash,
          dependencies: SearchBarFocusNodeFamily._dependencies,
          allTransitiveDependencies:
              SearchBarFocusNodeFamily._allTransitiveDependencies,
          i: i,
        );

  SearchBarFocusNodeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.i,
  }) : super.internal();

  final int i;

  @override
  Override overrideWith(
    FocusNode Function(SearchBarFocusNodeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchBarFocusNodeProvider._internal(
        (ref) => create(ref as SearchBarFocusNodeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        i: i,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<FocusNode> createElement() {
    return _SearchBarFocusNodeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchBarFocusNodeProvider && other.i == i;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, i.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchBarFocusNodeRef on AutoDisposeProviderRef<FocusNode> {
  /// The parameter `i` of this provider.
  int get i;
}

class _SearchBarFocusNodeProviderElement
    extends AutoDisposeProviderElement<FocusNode> with SearchBarFocusNodeRef {
  _SearchBarFocusNodeProviderElement(super.provider);

  @override
  int get i => (origin as SearchBarFocusNodeProvider).i;
}

String _$searchBarTextEditingControllerHash() =>
    r'65bde64794143ea531e49cfc53fd2905c834818d';

/// See also [searchBarTextEditingController].
@ProviderFor(searchBarTextEditingController)
const searchBarTextEditingControllerProvider =
    SearchBarTextEditingControllerFamily();

/// See also [searchBarTextEditingController].
class SearchBarTextEditingControllerFamily
    extends Family<TextEditingController> {
  /// See also [searchBarTextEditingController].
  const SearchBarTextEditingControllerFamily();

  /// See also [searchBarTextEditingController].
  SearchBarTextEditingControllerProvider call(
    int i,
  ) {
    return SearchBarTextEditingControllerProvider(
      i,
    );
  }

  @override
  SearchBarTextEditingControllerProvider getProviderOverride(
    covariant SearchBarTextEditingControllerProvider provider,
  ) {
    return call(
      provider.i,
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
  String? get name => r'searchBarTextEditingControllerProvider';
}

/// See also [searchBarTextEditingController].
class SearchBarTextEditingControllerProvider
    extends AutoDisposeProvider<TextEditingController> {
  /// See also [searchBarTextEditingController].
  SearchBarTextEditingControllerProvider(
    int i,
  ) : this._internal(
          (ref) => searchBarTextEditingController(
            ref as SearchBarTextEditingControllerRef,
            i,
          ),
          from: searchBarTextEditingControllerProvider,
          name: r'searchBarTextEditingControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchBarTextEditingControllerHash,
          dependencies: SearchBarTextEditingControllerFamily._dependencies,
          allTransitiveDependencies:
              SearchBarTextEditingControllerFamily._allTransitiveDependencies,
          i: i,
        );

  SearchBarTextEditingControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.i,
  }) : super.internal();

  final int i;

  @override
  Override overrideWith(
    TextEditingController Function(SearchBarTextEditingControllerRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchBarTextEditingControllerProvider._internal(
        (ref) => create(ref as SearchBarTextEditingControllerRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        i: i,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<TextEditingController> createElement() {
    return _SearchBarTextEditingControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchBarTextEditingControllerProvider && other.i == i;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, i.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchBarTextEditingControllerRef
    on AutoDisposeProviderRef<TextEditingController> {
  /// The parameter `i` of this provider.
  int get i;
}

class _SearchBarTextEditingControllerProviderElement
    extends AutoDisposeProviderElement<TextEditingController>
    with SearchBarTextEditingControllerRef {
  _SearchBarTextEditingControllerProviderElement(super.provider);

  @override
  int get i => (origin as SearchBarTextEditingControllerProvider).i;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
