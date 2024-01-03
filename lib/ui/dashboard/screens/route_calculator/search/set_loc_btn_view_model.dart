import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../models/coordinates.dart';
import '../../../../../models/located_place.dart';
import '../../../../components/dialogs.dart';
import '../display/map_display.dart';
import '../route_calculator_view_model.dart';
import 'search_bar.dart';

class SetLocBtnViewModel {
  final BuildContext context;
  final WidgetRef ref;

  const SetLocBtnViewModel(this.context, this.ref);

  String get buttonLabel {
    final i = ref.watch(activeStopIndexProvider);
    if (i == 0) return 'Set FROM Location';
    assert(i == 1);
    return 'Set TO Location';
  }

  Future<void> confirmLoc() => context.loaderWithErrorDialog(
        () async {
          final mapLatLng = await _mapCenter;
          final name = await mapLatLng.getNameSuggestionFromGoogle();
          final newStop = LocatedPlace(name, mapLatLng);
          ref
              .read(
                fromToStopsProvider.notifier,
              )
              .update(
                (list) => list.replace(
                  ref.read(activeStopIndexProvider),
                  newStop,
                ),
              );
        },
      );

  Future<Coordinates> get _mapCenter async {
    final mapCtl = await ref.read(gmapCtlProvider).future;
    final visibleRegion = await mapCtl.getVisibleRegion();
    final centerLatLng = Coordinates(
      (visibleRegion.northeast.latitude + visibleRegion.southwest.latitude) / 2,
      (visibleRegion.northeast.longitude + visibleRegion.southwest.longitude) /
          2,
    );
    return centerLatLng;
  }

  bool get showSetStopButton {
    final activeStopIndex = ref.watch(activeStopIndexProvider);
    final isSearchBarFocused = ref
        .watch(
          SearchBarFocusNodeProvider(
            activeStopIndex,
          ),
        )
        .hasFocus;
    if (isSearchBarFocused) return false;
    final areAnyStopsPendingAssignment = ref
        .watch(
          fromToStopsProvider,
        )
        .any(
          (stop) => stop == null,
        );
    return areAnyStopsPendingAssignment;
  }
}
