import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../models/coordinates.dart';
import 'display/assigned_loc_chips.dart';
import 'display/map_display.dart';
import 'search/search_bar.dart';
import 'search/search_suggestions.dart';
import 'search/set_loc_btn.dart';

class RouteCalculator extends ConsumerWidget {
  final bool focusSearch;
  final Coordinates? initialCoordinates;

  const RouteCalculator({
    super.key,
    required this.focusSearch,
    required this.initialCoordinates,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                MapDisplay(initialCoordinates: initialCoordinates),
                const SearchSuggestions(),
              ],
            ),
          ),
          Column(
            children: [
              LocSearchBar(autofocus: focusSearch),
              const SetLocBtn(),
              const AssignedLocChips(),
            ],
          ),
        ],
      ),
    );
  }
}
