import 'package:pointr/domain/entities/coordinates_entity.dart';
import 'package:test/test.dart';

void main() {
  test(
    'euclidean distance is accurately calculated',
    () {
      // init
      const parisCoord = CoordinatesEntity(1.2, -1);
      const karachiCoord = CoordinatesEntity(4.2, 3);
      // execute
      final distance = parisCoord.euclideanDistanceFrom(karachiCoord);
      // assert
      expect(distance, 5);
    },
  );
  test(
    'point of closest approach is accurately calculated',
    () {
      // init
      const karachiCoord = CoordinatesEntity(1, 1);
      const linePoint1 = CoordinatesEntity(1, 6);
      const linePoint2 = CoordinatesEntity(6, 1);
      // execute
      final distance = karachiCoord.pointOfClosestApproach(
        linePoint1,
        linePoint2,
      );
      // assert
      expect(distance, const CoordinatesEntity(3.5, 3.5));
    },
  );
}
