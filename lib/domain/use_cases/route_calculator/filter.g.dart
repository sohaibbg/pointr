// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedRouteModesHash() =>
    r'91b006c22e521ab5d43bb513d62288aad3aa1051';

/// shows which [pointr.RouteMode]s have been selected,
/// such as [pinkBus, chinchi, greenLine] for
/// filtering routes shown
///
/// Copied from [SelectedRouteModes].
@ProviderFor(SelectedRouteModes)
final selectedRouteModesProvider = AutoDisposeNotifierProvider<
    SelectedRouteModes, Set<pointr.RouteMode>>.internal(
  SelectedRouteModes.new,
  name: r'selectedRouteModesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedRouteModesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedRouteModes = AutoDisposeNotifier<Set<pointr.RouteMode>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
