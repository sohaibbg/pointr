import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../infrastructure/services/packages/iterable.dart';
import '../../entities/route_entity.dart' as pointr;

part 'filter.g.dart';

/// shows which [pointr.RouteMode]s have been selected,
/// such as [pinkBus, chinchi, greenLine] for
/// filtering routes shown
@riverpod
class SelectedRouteModes extends _$SelectedRouteModes {
  @override
  Set<pointr.RouteMode> build() => pointr.RouteMode.values.toSet();

  bool canToggle(pointr.RouteMode e) {
    final isOnlyItem = state.length == 1 && state.contains(e);
    if (isOnlyItem) return false;
    return true;
  }

  void toggle(pointr.RouteMode e) => state = state.toggle(e).toSet();
}
