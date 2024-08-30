import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../entities/coordinates_entity.dart';
import '../../entities/searchable_place.dart';
import '../places_use_case.dart';

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

Future<void> updateStopProvider(
  WidgetRef ref,
  CoordinatesEntity mapLatLng,
) async {
  final directionType = ref.read(
    currentlyPickingDirectionTypeProvider,
  );
  final stopProvider = switch (directionType!) {
    DirectionType.from => fromStopProvider,
    DirectionType.to => toStopProvider,
  };
  final temporaryAddress = AddressEntity(
    coordinates: mapLatLng,
    address: '',
  );
  ref.read(stopProvider.notifier).state = temporaryAddress;
  final address = await ref.read(
    NameFromCoordinatesProvider(mapLatLng).future,
  );
  final newStop = AddressEntity(
    address: address,
    coordinates: mapLatLng,
  );
  ref.read(stopProvider.notifier).state = newStop;
}
