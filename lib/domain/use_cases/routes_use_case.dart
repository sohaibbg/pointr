import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/injector.dart';
import '../entities/route_entity.dart';
import '../repositories/i_local_routes_repo.dart';

part 'routes_use_case.g.dart';

@riverpod
class RoutesUseCase extends _$RoutesUseCase {
  final repo = getIt.call<ILocalRoutesRepo>();

  @override
  Future<IList<RouteEntity>> build() async {
    final hc = await repo.getHardcoded();
    final custom = await repo.getCustom();
    return [...hc, ...custom].toIList();
  }

  Future<void> addRoute(RouteEntity route) async {
    await repo.addRoute(route);
    state = AsyncData(
      state.value!.add(route),
    );
  }

  Future<void> deleteRoute(String routeName) async {
    await repo.deleteRoute(routeName);
    state = AsyncData(
      state.value!.removeWhere(
        (e) => e.name == routeName,
      ),
    );
  }
}
