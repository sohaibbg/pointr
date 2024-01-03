// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_calculator_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeStopIndexHash() => r'b55242e0813ef4da3db49ed7342cbc7673e327b3';

/// See also [activeStopIndex].
@ProviderFor(activeStopIndex)
final activeStopIndexProvider = AutoDisposeProvider<int>.internal(
  activeStopIndex,
  name: r'activeStopIndexProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeStopIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ActiveStopIndexRef = AutoDisposeProviderRef<int>;
String _$scoredRoutesHash() => r'c47c9b2e99eb3eed8adb95a35c4ff75acf0525b3';

/// See also [scoredRoutes].
@ProviderFor(scoredRoutes)
final scoredRoutesProvider =
    AutoDisposeFutureProvider<Map<Route, double>>.internal(
  scoredRoutes,
  name: r'scoredRoutesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$scoredRoutesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ScoredRoutesRef = AutoDisposeFutureProviderRef<Map<Route, double>>;
String _$selectedRoutesHash() => r'882cf1df1a800b932f495b42c5055be8604fb523';

/// See also [SelectedRoutes].
@ProviderFor(SelectedRoutes)
final selectedRoutesProvider =
    AutoDisposeNotifierProvider<SelectedRoutes, ISet<Route>>.internal(
  SelectedRoutes.new,
  name: r'selectedRoutesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedRoutesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedRoutes = AutoDisposeNotifier<ISet<Route>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
