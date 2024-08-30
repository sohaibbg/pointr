import 'package:pointr/domain/entities/coordinates_entity.dart';
import 'package:pointr/domain/entities/route_entity.dart';
import 'package:test/test.dart';

void main() {
  test(
    'total distance is accurately calculated',
    () {
      // init
      const route = RouteEntity(
        name: 'test',
        mode: RouteMode.acBus,
        points: [
          CoordinatesEntity(0, 0),
          CoordinatesEntity(3, 4),
          CoordinatesEntity(3, 10),
        ],
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
      const route = RouteEntity(
        name: 'test',
        mode: RouteMode.acBus,
        points: [
          CoordinatesEntity(-15, -15),
          CoordinatesEntity(-5, -5),
          CoordinatesEntity(-5, 5),
          CoordinatesEntity(10, 5),
          CoordinatesEntity(20, 15),
        ],
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
