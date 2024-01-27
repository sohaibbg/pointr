// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_calculator_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentlyPickingDirectionTypeHash() =>
    r'7339d72208b0608f7a7e5c8989b6ab7ed78f04f9';

/// See also [currentlyPickingDirectionType].
@ProviderFor(currentlyPickingDirectionType)
final currentlyPickingDirectionTypeProvider =
    AutoDisposeProvider<DirectionType?>.internal(
  currentlyPickingDirectionType,
  name: r'currentlyPickingDirectionTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentlyPickingDirectionTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentlyPickingDirectionTypeRef
    = AutoDisposeProviderRef<DirectionType?>;
String _$routeSegmentsHash() => r'd58a2553f52defef214a224c4152fd2ba1b3f8f6';

/// See also [routeSegments].
@ProviderFor(routeSegments)
final routeSegmentsProvider =
    AutoDisposeProvider<List<Set<pointr.Route>>?>.internal(
  routeSegments,
  name: r'routeSegmentsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$routeSegmentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RouteSegmentsRef = AutoDisposeProviderRef<List<Set<pointr.Route>>?>;
String _$scoredRoutesHash() => r'84193915bad87cb4456586d275f81508e11fe33e';

/// See also [scoredRoutes].
@ProviderFor(scoredRoutes)
final scoredRoutesProvider =
    AutoDisposeFutureProvider<Map<pointr.Route, double>>.internal(
  scoredRoutes,
  name: r'scoredRoutesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$scoredRoutesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ScoredRoutesRef
    = AutoDisposeFutureProviderRef<Map<pointr.Route, double>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
