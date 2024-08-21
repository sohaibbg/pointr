import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../infrastructure/services/packages/iterable.dart';
import '../../entities/route_entity.dart' as pointr;
import '../routes_use_case.dart';
import 'filter.dart';
import 'from_to_stops.dart';

part 'scored_route_groups.g.dart';

final selectedRouteGroupIndexProvider = StateProvider<int>(
  (ref) => 0,
);

@riverpod
class ScoredRouteGroups extends _$ScoredRouteGroups {
  @override
  Future<List<Set<pointr.RouteEntity>>> build() async {
    final scoredRoutes = await _calculateScoredRoutes();
    final selectedRouteModes = ref.watch(selectedRouteModesProvider);
    return scoredRoutes
        // filter
        .where(
          (route) => selectedRouteModes.contains(route.mode),
        )
        // split into groups
        .splitByLength(4)
        .map((e) => e.toSet())
        .toList();
  }

  Future<List<pointr.RouteEntity>> _calculateScoredRoutes() async {
    final from = ref.watch(
      fromStopProvider.select((e) => e!.coordinates),
    );
    final to = ref.watch(
      toStopProvider.select((e) => e!.coordinates),
    );
    final routes = await ref.watch(routesUseCaseProvider.future);
    return routes
      ..sort(
        (a, b) {
          final bScore = b.distanceScore(from, to);
          final aScore = a.distanceScore(from, to);
          return aScore.compareTo(bScore);
        },
      );
  }
}
