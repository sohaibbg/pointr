// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'from_to_stops.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentlyPickingDirectionTypeHash() =>
    r'7339d72208b0608f7a7e5c8989b6ab7ed78f04f9';

/// when a user lands on the route calculator page
/// the following logic determines which stop
/// they're currently picking. null means
/// currently none are being picked, so both must
/// have been picked
///
/// Copied from [currentlyPickingDirectionType].
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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
