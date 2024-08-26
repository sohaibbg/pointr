import 'package:injectable/injectable.dart';

import '../entities/route_entity.dart';
import 'i_location_repo.dart';

@test
@injectable
class ILocalRoutesRepo {
  Future<List<RouteEntity>> getHardcoded() => Future(
        () => [
          const RouteEntity(
            name: 'name',
            mode: RouteMode.redBus,
            points: [
              karachiLatLng,
            ],
          ),
        ],
      );

  final _customState = [
    const RouteEntity(
      name: 'name',
      mode: RouteMode.minibus,
      points: [
        karachiLatLng,
      ],
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
