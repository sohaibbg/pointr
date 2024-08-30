// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestions_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchSuggestionsHash() => r'6ed2b98c0a779e4f9a45db3968bc36d97c61165e';

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

/// See also [searchSuggestions].
@ProviderFor(searchSuggestions)
const searchSuggestionsProvider = SearchSuggestionsFamily();

/// See also [searchSuggestions].
class SearchSuggestionsFamily
    extends Family<AsyncValue<List<SearchablePlace>>> {
  /// See also [searchSuggestions].
  const SearchSuggestionsFamily();

  /// See also [searchSuggestions].
  SearchSuggestionsProvider call(
    String term,
  ) {
    return SearchSuggestionsProvider(
      term,
    );
  }

  @override
  SearchSuggestionsProvider getProviderOverride(
    covariant SearchSuggestionsProvider provider,
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
  String? get name => r'searchSuggestionsProvider';
}

/// See also [searchSuggestions].
class SearchSuggestionsProvider
    extends AutoDisposeStreamProvider<List<SearchablePlace>> {
  /// See also [searchSuggestions].
  SearchSuggestionsProvider(
    String term,
  ) : this._internal(
          (ref) => searchSuggestions(
            ref as SearchSuggestionsRef,
            term,
          ),
          from: searchSuggestionsProvider,
          name: r'searchSuggestionsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchSuggestionsHash,
          dependencies: SearchSuggestionsFamily._dependencies,
          allTransitiveDependencies:
              SearchSuggestionsFamily._allTransitiveDependencies,
          term: term,
        );

  SearchSuggestionsProvider._internal(
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
    Stream<List<SearchablePlace>> Function(SearchSuggestionsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchSuggestionsProvider._internal(
        (ref) => create(ref as SearchSuggestionsRef),
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
  AutoDisposeStreamProviderElement<List<SearchablePlace>> createElement() {
    return _SearchSuggestionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchSuggestionsProvider && other.term == term;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, term.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchSuggestionsRef
    on AutoDisposeStreamProviderRef<List<SearchablePlace>> {
  /// The parameter `term` of this provider.
  String get term;
}

class _SearchSuggestionsProviderElement
    extends AutoDisposeStreamProviderElement<List<SearchablePlace>>
    with SearchSuggestionsRef {
  _SearchSuggestionsProviderElement(super.provider);

  @override
  String get term => (origin as SearchSuggestionsProvider).term;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
