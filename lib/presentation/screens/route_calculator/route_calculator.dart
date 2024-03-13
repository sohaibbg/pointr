import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../../../domain/entities/address_entity.dart';
import '../../../domain/entities/route_entity.dart' as pointr;
import '../../../infrastructure/services/packages/focus_node.dart';
import '../../components/loc_search_bar.dart';
import '../../components/map_with_pin_and_banner.dart';
import '../../components/space.dart';
import 'route_calculator_view_model.dart';

part '_confirmed_stop_chips.dart';
part '_route_mode_filter_btn.dart';
part '_routes_legend_list_view.dart';

class RouteCalculator extends HookConsumerWidget {
  final bool focusSearch;
  final AddressEntity? initialPlace;

  const RouteCalculator({
    super.key,
    required this.focusSearch,
    required this.initialPlace,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchBarFocusNode = useFocusNode();
    final mapCtlCompleter = useMemoized(
      () => Completer<GoogleMapController>(),
      [context],
    );
    final vm = RouteCalculatorViewModel(
      context,
      ref,
      focusNode: searchBarFocusNode,
      gmapCtlCompleter: mapCtlCompleter,
    );
    final locSearchBar = AnimatedSize(
      duration: kThemeAnimationDuration,
      child: vm.areBothStopsConfirmed
          ? const SizedBox(
              width: double.infinity,
            )
          : LocSearchBar(
              focusNode: searchBarFocusNode,
              autofocus: focusSearch,
              onPlaceSelected: vm.onPlaceSelected,
            ),
    );
    final routeSelectionPanel = _RouteSelectionPanel(vm: vm);
    final map = MapWithPinAndBanner(
      initialCameraPosition: CameraPosition(
        target: vm.initialLatLng,
        zoom: 15,
      ),
      hidePin: vm.areBothStopsConfirmed,
      markers: vm.markers,
      polylines: vm.polylines,
      onMapCreated: mapCtlCompleter.complete,
      padding: const EdgeInsets.symmetric(
        vertical: 350,
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            map,
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                locSearchBar,
                routeSelectionPanel,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteSelectionPanel extends HookConsumerWidget {
  const _RouteSelectionPanel({
    required this.vm,
  });

  final RouteCalculatorViewModel vm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confirmLocBtn = ElevatedButton.icon(
      icon: const Icon(Icons.navigate_next_sharp),
      label: Text(vm.selectLocBtnLabel),
      onPressed: vm.onPlaceConfirmed,
      style: const ButtonStyle(
        padding: MaterialStatePropertyAll(
          EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        ),
        textStyle: MaterialStatePropertyAll(
          TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        iconSize: MaterialStatePropertyAll(48),
      ),
    );
    final routeSelectorListView = ref
        .watch(
          scoredRoutesProvider,
        )
        .when(
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) => const Text('error'),
          data: (_) => const Column(
            children: [
              _RouteModeFilterBtn(),
              _RoutesLegendListView(),
            ],
          ),
        );
    final locBtnOrListViewCrossFaded = AnimatedCrossFade(
      firstChild: confirmLocBtn,
      secondChild: routeSelectorListView,
      crossFadeState: ref.watch(
                currentlyPickingDirectionTypeProvider,
              ) !=
              null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: kThemeAnimationDuration,
    );
    final isSearchFocused = useIsFocused(vm.focusNode);
    final body = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: locBtnOrListViewCrossFaded,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: _ConfirmedStopChips(
            searchBarFocusNode: vm.focusNode,
          ),
        ),
      ],
    );
    final animatedBody = AnimatedSize(
      duration: kThemeAnimationDuration,
      alignment: Alignment.bottomCenter,
      child: isSearchFocused ? double.infinity.horizontalSpace : body,
    );
    return PopScope(
      onPopInvoked: vm.onPopInvoked,
      child: animatedBody,
    );
  }
}
