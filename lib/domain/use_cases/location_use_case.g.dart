// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_use_case.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentLocHash() => r'61ac31a37816a413ddfc294109f0541a643b8bfd';

/// See also [currentLoc].
@ProviderFor(currentLoc)
final currentLocProvider =
    AutoDisposeFutureProvider<CoordinatesEntity>.internal(
  currentLoc,
  name: r'currentLocProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentLocHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentLocRef = AutoDisposeFutureProviderRef<CoordinatesEntity>;
String _$locPermissionHash() => r'2f2e1274d04562b4bc912229b79f0c558f44897f';

/// See also [LocPermission].
@ProviderFor(LocPermission)
final locPermissionProvider = AutoDisposeAsyncNotifierProvider<LocPermission,
    LocationPermission>.internal(
  LocPermission.new,
  name: r'locPermissionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$locPermissionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LocPermission = AutoDisposeAsyncNotifier<LocationPermission>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
