import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:pointr/domain/entities/coordinates_entity.dart';
import 'package:pointr/domain/entities/route_entity.dart';
import 'package:test/test.dart';

void main() {
  test(
    'total distance is accurately calculated',
    () {
      // init
      final route = RouteEntity(
        name: 'test',
        mode: RouteMode.acBus,
        points: [
          const CoordinatesEntity(0, 0),
          const CoordinatesEntity(3, 4),
          const CoordinatesEntity(3, 10),
        ].toIList(),
      );
      // execute
      final distance = route.totalDistance;
      // assert
      expect(distance, 11);
    },
  );
  test(
    'distance score compares effectively',
    () {
      // init
      final route = RouteEntity(
        name: 'test',
        mode: RouteMode.acBus,
        points: [
          const CoordinatesEntity(-15, -15),
          const CoordinatesEntity(-5, -5),
          const CoordinatesEntity(-5, 5),
          const CoordinatesEntity(10, 5),
          const CoordinatesEntity(20, 15),
        ].toIList(),
      );
      const depNearest = CoordinatesEntity(-10, -5);
      const destNearest = CoordinatesEntity(20, 5);
      const depMedium = CoordinatesEntity(-25, -5);
      const destMedium = CoordinatesEntity(40, 15);
      const depFurthest = CoordinatesEntity(-50, -50);
      const destFurthest = CoordinatesEntity(50, 50);
      // execute
      final scoreNearest = route.distanceScore(depNearest, destNearest);
      final scoreMedium = route.distanceScore(depMedium, destMedium);
      final scoreFurthest = route.distanceScore(depFurthest, destFurthest);
      // assert
      expect(
        scoreNearest > scoreMedium && scoreMedium > scoreFurthest,
        true,
      );
    },
  );
}
