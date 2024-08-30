import 'package:injectable/injectable.dart';

import '../../domain/entities/route_entity.dart';
import '../../domain/repositories/i_local_routes_repo.dart';
import '../services/packages/database.dart';
import '../services/tables/custom_routes.dart';
import 'hardcoded_routes.dart';

@dev
@prod
@Injectable(as: ILocalRoutesRepo)
class PLocalRoutesRepo implements ILocalRoutesRepo {
  @override
  List<RouteEntity> getHardcoded() => hardCodedRoutes;

  @override
  Future<List<RouteEntity>> getCustom() async {
    final records = await AppDatabase.instance
        .select(
          AppDatabase.instance.customRoutes,
        )
        .get();
    return records
        .map(
          (e) => RouteEntity(
            name: e.name,
            mode: e.routeMode,
            points: e.points,
          ),
        )
        .toList();
  }

  @override
  Future<void> addRoute(
    RouteEntity route,
  ) =>
      AppDatabase.instance
          .into(
            AppDatabase.instance.customRoutes,
          )
          .insert(
            route.toCustomRouteCompanion,
          );

  @override
  Future<void> deleteRoute(String routeName) async {
    final stmt = AppDatabase.instance.delete(
      AppDatabase.instance.customRoutes,
    )..where(
        (tbl) => tbl.name.equals(routeName),
      );
    await stmt.go();
  }
}
