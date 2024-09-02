// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recents_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchRecentsHash() => r'9b6aec05e66c29a7d568af052147a6e8cff607fa';

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

/// See also [searchRecents].
@ProviderFor(searchRecents)
const searchRecentsProvider = SearchRecentsFamily();

/// See also [searchRecents].
class SearchRecentsFamily extends Family<AsyncValue<List<RecentEntity>>> {
  /// See also [searchRecents].
  const SearchRecentsFamily();

  /// See also [searchRecents].
  SearchRecentsProvider call(
    String term,
  ) {
    return SearchRecentsProvider(
      term,
    );
  }

  @override
  SearchRecentsProvider getProviderOverride(
    covariant SearchRecentsProvider provider,
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
  String? get name => r'searchRecentsProvider';
}

/// See also [searchRecents].
class SearchRecentsProvider
    extends AutoDisposeFutureProvider<List<RecentEntity>> {
  /// See also [searchRecents].
  SearchRecentsProvider(
    String term,
  ) : this._internal(
          (ref) => searchRecents(
            ref as SearchRecentsRef,
            term,
          ),
          from: searchRecentsProvider,
          name: r'searchRecentsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchRecentsHash,
          dependencies: SearchRecentsFamily._dependencies,
          allTransitiveDependencies:
              SearchRecentsFamily._allTransitiveDependencies,
          term: term,
        );

  SearchRecentsProvider._internal(
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
    FutureOr<List<RecentEntity>> Function(SearchRecentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchRecentsProvider._internal(
        (ref) => create(ref as SearchRecentsRef),
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
  AutoDisposeFutureProviderElement<List<RecentEntity>> createElement() {
    return _SearchRecentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchRecentsProvider && other.term == term;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, term.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SearchRecentsRef on AutoDisposeFutureProviderRef<List<RecentEntity>> {
  /// The parameter `term` of this provider.
  String get term;
}

class _SearchRecentsProviderElement
    extends AutoDisposeFutureProviderElement<List<RecentEntity>>
    with SearchRecentsRef {
  _SearchRecentsProviderElement(super.provider);

  @override
  String get term => (origin as SearchRecentsProvider).term;
}

String _$recentsUseCaseHash() => r'581e16e623b11c6e6b842c13265640ea84a1509d';

/// See also [RecentsUseCase].
@ProviderFor(RecentsUseCase)
final recentsUseCaseProvider =
    AsyncNotifierProvider<RecentsUseCase, List<RecentEntity>>.internal(
  RecentsUseCase.new,
  name: r'recentsUseCaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recentsUseCaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RecentsUseCase = AsyncNotifier<List<RecentEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
