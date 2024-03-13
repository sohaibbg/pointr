import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:injectable/injectable.dart';

import '../entities/route_entity.dart';
import 'i_location_repo.dart';

@test
@injectable
class ILocalRoutesRepo {
  Future<List<RouteEntity>> getHardcoded() => Future(
        () => [
          RouteEntity(
            name: 'name',
            mode: RouteMode.acBus,
            points: [
              karachiLatLng,
            ].toIList(),
          ),
        ],
      );

  final _customState = [
    RouteEntity(
      name: 'name',
      mode: RouteMode.bus,
      points: [
        karachiLatLng,
      ].toIList(),
    ),
  ];

  Future<List<RouteEntity>> getCustom() => Future(
        () => _customState,
      );

  Future<void> addRoute(RouteEntity route) => Future(
        () => _customState.add(route),
      );

  Future<void> deleteRoute(String routeName) => Future(
        () => _customState.removeWhere(
          (e) => e.name == routeName,
        ),
      );
}
