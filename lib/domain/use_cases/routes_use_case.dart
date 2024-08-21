import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/injector.dart';
import '../entities/route_entity.dart';
import '../repositories/i_local_routes_repo.dart';

part 'routes_use_case.g.dart';

@riverpod
class RoutesUseCase extends _$RoutesUseCase {
  final repo = getIt.call<ILocalRoutesRepo>();

  @override
  Future<List<RouteEntity>> build() async {
    final hc = await repo.getHardcoded();
    final custom = await repo.getCustom();
    return [...hc, ...custom];
  }

  Future<void> addRoute(RouteEntity route) async {
    await repo.addRoute(route);
    state = AsyncData([
      ...state.value!,
      route,
    ]);
  }

  Future<void> deleteRoute(String routeName) async {
    await repo.deleteRoute(routeName);
    state = AsyncData(
      state.value!
          .where(
            (e) => e.name != routeName,
          )
          .toList(),
    );
  }
}
