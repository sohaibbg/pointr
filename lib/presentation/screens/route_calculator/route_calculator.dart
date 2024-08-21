import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../../../config/my_theme.dart';
import '../../../domain/entities/address_entity.dart';
import '../../../domain/entities/coordinates_entity.dart';
import '../../../domain/entities/route_entity.dart' as pointr;
import '../../../domain/repositories/i_location_repo.dart';
import '../../../domain/use_cases/location_use_case.dart';
import '../../../domain/use_cases/route_calculator/filter.dart';
import '../../../domain/use_cases/route_calculator/from_to_stops.dart';
import '../../../domain/use_cases/route_calculator/scored_route_groups.dart';
import '../../../infrastructure/services/packages/google_map_controller.dart';
import '../../../infrastructure/services/packages/hooks.dart';
import '../../../infrastructure/services/packages/iterable.dart';
import '../../../infrastructure/services/packages/view_model.dart';
import '../../components/dialogs.dart';
import '../../components/gmap_buttons.dart';
import '../../components/header_footer.dart';
import '../../components/loc_search_bar_with_overlay.dart';
import '../../components/map_with_pin_and_banner.dart';
import '../../components/space.dart';

part './stop_selection/_stop_selector_panel.dart';
part '_confirmed_stop_chips.dart';
part '_route_calculator_map.dart';
part 'route_calculator.g.dart';
part 'route_calculator_view_model.dart';
part 'route_selection/_route_mode_filter_btn.dart';
part 'route_selection/_route_selector_panel.dart';
part 'route_selection/_routes_legend_list_view.dart';

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
    final overlay = HeaderFooter(
      child: AnimatedSize(
        duration: kThemeAnimationDuration,
        alignment: Alignment.bottomCenter,
        child: switch (vm.numberOfStopsConfirmed) {
          0 || 1 => _StopSelectorPanel(vm),
          2 => _RouteSelectorPanel(vm: vm),
          _ => throw vm,
        },
      ),
    );
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _RouteCalculatorMap(
            initialPlace: initialPlace,
            mapCtlCompleter: mapCtlCompleter,
          ),
          Column(
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
              overlay,
            ],
          ),
        ],
      ),
    );
  }
}
