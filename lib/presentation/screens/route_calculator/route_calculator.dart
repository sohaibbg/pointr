import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../config/my_theme.dart';
import '../../../domain/entities/address_entity.dart';
import '../../../domain/entities/coordinates_entity.dart';
import '../../../domain/entities/route_entity.dart' as pointr;
import '../../../domain/entities/route_entity.dart';
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
import '../../components/gmap_buttons.dart';
import '../../components/header_footer.dart';
import '../../components/loc_search_bar_with_overlay.dart';
import '../../components/map_with_pin_and_banner.dart';
import '../../components/routes_legend_list_view.dart';
import '../../components/slide_transition_helper.dart';
import '../../components/space.dart';

part 'components/_confirmed_stops_card.dart';
part 'components/_route_calculator_map.dart';
part 'components/_route_mode_filter_btn.dart';
part 'components/_routes_legend_list_view.dart';
part 'route_calculator.g.dart';
part 'route_calculator_view_model.dart';

@riverpod
({bool hasFrom, bool hasTo}) bothStops(BothStopsRef ref) => (
      hasFrom: ref.watch(
        fromStopProvider.select((e) => e != null),
      ),
      hasTo: ref.watch(
        toStopProvider.select((e) => e != null),
      ),
    );

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
    final mapCtlCompleter = useMemoized(
      () => Completer<GoogleMapController>(),
      [context],
    );
    final vm = RouteCalculatorViewModel(
      context,
      ref,
      gmapCtlCompleter: mapCtlCompleter,
    );
    final backBtn = ElevatedButton(
      onPressed: vm.onBackBtnPressed,
      style: MyTheme.secondaryButtonStyle,
      child: const Icon(
        Icons.arrow_back_ios_new_outlined,
      ),
    );
    final locSearchBarOrRouteLegend = Stack(
      clipBehavior: Clip.hardEdge,
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
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: LocSearchBarWithOverlay(
              onPlaceSelected: vm.onPlaceSelected,
            ),
          ),
        ),
      ],
    );
    final confirmLocBtn = ElevatedButton.icon(
      icon: const Icon(Icons.navigate_next_sharp),
      label: Text(vm.selectLocBtnLabel),
      onPressed: () => context.loaderWithErrorDialog(
        vm.onPlaceConfirmed,
      ),
      style: MyTheme.primaryElevatedButtonStyle,
    );
    final actionsPanel = ListenableBuilder(
      listenable: LocSearchBarWithOverlay.searchFocusNode,
      child: Column(
        children: [
          10.verticalSpace,
          Row(
            children: [
              backBtn,
              12.horizontalSpace,
              Expanded(
                child: vm.areBothStopsSet
                    ? const _RouteModeFilterBtn()
                    : confirmLocBtn,
              ),
            ],
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
    final inFooterContent = HeaderFooter(
      child: Column(
        children: [
          locSearchBarOrRouteLegend,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
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
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _RouteCalculatorMap(
            initialPlace: initialPlace,
            mapCtlCompleter: mapCtlCompleter,
          ),
          overlay,
        ],
      ),
    );
  }
}
