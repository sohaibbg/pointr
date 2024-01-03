import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../models/located_place.dart';
import '../../../../models/route.dart';
import '../../../../repo/local_routes.dart';

part 'route_calculator_view_model.g.dart';

final fromToStopsProvider = StateProvider<IList<LocatedPlace?>>(
  (ref) => IList<LocatedPlace?>(),
);

@riverpod
int activeStopIndex(ActiveStopIndexRef ref) =>
    ref.watch(fromToStopsProvider).indexWhere(
          (stop) => stop == null,
        );

@riverpod
class SelectedRoutes extends _$SelectedRoutes {
  @override
  ISet<Route> build() {
    final selectedRouteModes = ref.watch(selectedRouteModesProvider);
    final routes = ref.watch(scoredRoutesProvider).requireValue;
    return routes.entries
        .where(
          (route) => selectedRouteModes.contains(
            route.key.mode,
          ),
        )
        .map((e) => e.key)
        .toISet();
  }

  void toggleRoute(Route route, bool isChecked) =>
      isChecked ? state.add(route) : state.remove(route);
}

final selectedRouteModesProvider = StateProvider<ISet<RouteMode>>(
  (ref) => ISet<RouteMode>(RouteMode.values),
);

@riverpod
Future<Map<Route, double>> scoredRoutes(ScoredRoutesRef ref) async {
  final storedRoutes = await ref.watch(localRoutesProvider.future);
  final onboard = ref.watch(fromToStopsProvider).first!.coordinates;
  final offload = ref.watch(fromToStopsProvider).first!.coordinates;
  final scoredRoutes = <Route, double>{};
  for (int i = 0; i < storedRoutes.length; i++) {
    final route = storedRoutes.elementAt(i);
    final score = route.distanceScore(onboard, offload);
    scoredRoutes[route] = score;
  }
  final sortedResult = Map.fromEntries(
    scoredRoutes.entries.toList()
      ..sort(
        (e1, e2) => e1.value.compareTo(e2.value),
      ),
  );
  return sortedResult;
}
