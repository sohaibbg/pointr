import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../config/injector.dart';
import '../../../config/my_theme.dart';
import '../../../domain/entities/coordinates_entity.dart';
import '../../../domain/entities/route_entity.dart' as pointr;
import '../../../domain/entities/route_entity.dart';
import '../../../domain/entities/searchable_place.dart';
import '../../../domain/repositories/i_initial_disclaimers_shown_repo.dart';
import '../../../domain/repositories/i_location_repo.dart';
import '../../../domain/use_cases/location_use_case.dart';
import '../../../domain/use_cases/route_calculator/filter.dart';
import '../../../domain/use_cases/route_calculator/from_to_stops.dart';
import '../../../domain/use_cases/route_calculator/scored_route_groups.dart';
import '../../../infrastructure/services/packages/google_map_controller.dart';
import '../../../infrastructure/services/packages/hooks.dart';
import '../../../infrastructure/services/packages/iterable.dart';
import '../../../infrastructure/services/packages/view_model.dart';
import '../../components/aligned_dialog_pusher_box.dart';
import '../../components/dialogs.dart';
import '../../components/header_footer.dart';
import '../../components/map/gmap_buttons.dart';
import '../../components/map/loc_search_bar_with_overlay.dart';
import '../../components/map/map_with_pin_and_banner.dart';
import '../../components/map/routes_legend_list_view.dart';
import '../../components/slide_transition_helper.dart';
import '../../components/space.dart';

part '_view_model.dart';
part 'components/_confirmed_stops_card.dart';
part 'components/_go_map.dart';
part 'components/_route_mode_filter_btn.dart';
part 'components/_routes_legend_list_view.dart';
part 'go_screen.g.dart';

@riverpod
({bool hasFrom, bool hasTo}) bothStops(BothStopsRef ref) => (
      hasFrom: ref.watch(
        fromStopProvider.select((e) => e != null),
      ),
      hasTo: ref.watch(
        toStopProvider.select((e) => e != null),
      ),
    );

class GoScreen extends HookConsumerWidget {
  const GoScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapCtlCompleter = useRef(Completer<GoogleMapController>()).value;
    final vm = _GoViewModel(
      context,
      ref,
      gmapCtlCompleter: mapCtlCompleter,
    );
    useEffect(vm.useEffectHook);
    final backBtn = SlideTransitionHelper(
      axis: Axis.horizontal,
      axisAlignment: 1,
      doShow: ref.watch(
        bothStopsProvider.select(
          (stops) => stops.hasFrom || stops.hasTo,
        ),
      ),
      child: ElevatedButton(
        onPressed: vm.onBackBtnPressed,
        style: MyTheme.secondaryButtonStyle,
        child: const Icon(
          Icons.arrow_back_ios_new_outlined,
        ),
      ),
    );
    final menuBtn = ElevatedButton(
      style: MyTheme.secondaryButtonStyle,
      onPressed: Scaffold.of(context).openDrawer,
      child: const Icon(Icons.menu),
    );
    final locSearchBarOrRouteLegend = Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        SlideTransitionHelper(
          doShow: vm.areBothStopsSet,
          axis: Axis.vertical,
          axisAlignment: -1,
          child: const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: _RoutesLegendListView(),
          ),
        ),
        SlideTransitionHelper(
          doShow: !vm.areBothStopsSet,
          axis: Axis.vertical,
          axisAlignment: -1,
          child: LocSearchBarWithOverlay(
            onPlaceSelected: vm.onSuggestionSelected,
          ),
        ),
      ],
    );
    final confirmLocBtn = ElevatedButton.icon(
      icon: const Icon(Icons.navigate_next_sharp),
      label: Text(vm.selectLocBtnLabel),
      onPressed: () => context.loaderWithErrorDialog(
        vm.onStopSet,
      ),
      style: MyTheme.primaryElevatedButtonStyle,
    );
    final actionsPanel = ListenableBuilder(
      listenable: LocSearchBarWithOverlay.searchFocusNode,
      child: Column(
        children: [
          10.verticalSpace,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                backBtn,
                menuBtn,
                6.horizontalSpace,
                // 12.horizontalSpace,
                Expanded(
                  child: vm.areBothStopsSet
                      ? const _RouteModeFilterBtn()
                      : confirmLocBtn,
                ),
              ],
            ),
          ),
          const _ConfirmedStopsCard(),
          kBottomNavigationBarHeight.verticalSpace,
        ],
      ),
      builder: (context, child) => SlideTransitionHelper(
        doShow: !LocSearchBarWithOverlay.searchFocusNode.hasFocus,
        axis: Axis.vertical,
        axisAlignment: -1,
        child: child!,
      ),
    );
    final inFooterContent = Footer(
      child: Column(
        children: [
          locSearchBarOrRouteLegend,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: actionsPanel,
          ),
        ],
      ),
    );
    final overlay = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 12),
          child: Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: GmapButtons(vm.gmapCtlCompleter),
          ),
        ),
        24.verticalSpace,
        inFooterContent,
      ],
    );
    final scaffold = Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _GoMap(
            mapCtlCompleter: mapCtlCompleter,
          ),
          overlay,
        ],
      ),
    );
    return ListenableBuilder(
      listenable: LocSearchBarWithOverlay.searchFocusNode,
      builder: (context, child) {
        final canPop = !LocSearchBarWithOverlay.searchFocusNode.hasFocus &&
            ref.watch(fromStopProvider.select((e) => e == null)) &&
            ref.watch(toStopProvider.select((e) => e == null));
        return PopScope(
          canPop: canPop,
          onPopInvokedWithResult: (didPop, result) => vm.onBackBtnPressed(),
          child: scaffold,
        );
      },
    );
  }
}
