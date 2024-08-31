import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../entities/searchable_place.dart';
import '../recents_use_case.dart';

part 'from_to_stops.g.dart';

enum DirectionType { from, to }

final fromStopProvider = StateProvider<AddressEntity?>((ref) => null);
final toStopProvider = StateProvider<AddressEntity?>((ref) => null);

/// when a user lands on the route calculator page
/// the following logic determines which stop
/// they're currently picking. null means
/// currently none are being picked, so both must
/// have been picked
@riverpod
DirectionType? currentlyPickingDirectionType(
  CurrentlyPickingDirectionTypeRef ref,
) {
  final from = ref.watch(fromStopProvider);
  if (from == null) return DirectionType.from;
  final to = ref.watch(toStopProvider);
  if (to == null) return DirectionType.to;
  return null;
}

DirectionType updateStopProvider(
  WidgetRef ref,
  AddressEntity address, {
  DirectionType? directionType,
}) {
  directionType ??= ref.read(
    currentlyPickingDirectionTypeProvider,
  );
  final thisStopProvider = switch (directionType!) {
    DirectionType.from => fromStopProvider,
    DirectionType.to => toStopProvider,
  };
  ref.read(thisStopProvider.notifier).state = address;
  if (address.name.isNotEmpty) {
    ref.read(recentsUseCaseProvider.notifier).record(address);
  }
  return directionType;
}
