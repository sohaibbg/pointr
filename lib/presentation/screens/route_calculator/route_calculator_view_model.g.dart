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
String _$routeSegmentsHash() => r'bec4c09686e1b43146782cbd4d40cd458cbf041a';

/// See also [routeSegments].
@ProviderFor(routeSegments)
final routeSegmentsProvider =
    AutoDisposeProvider<List<Set<pointr.RouteEntity>>?>.internal(
  routeSegments,
  name: r'routeSegmentsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$routeSegmentsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RouteSegmentsRef
    = AutoDisposeProviderRef<List<Set<pointr.RouteEntity>>?>;
String _$scoredRoutesHash() => r'874e1298cbffa8999d0a3d5bbae5c3ab62e3964c';

/// See also [scoredRoutes].
@ProviderFor(scoredRoutes)
final scoredRoutesProvider =
    AutoDisposeFutureProvider<Map<pointr.RouteEntity, double>>.internal(
  scoredRoutes,
  name: r'scoredRoutesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$scoredRoutesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ScoredRoutesRef
    = AutoDisposeFutureProviderRef<Map<pointr.RouteEntity, double>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
