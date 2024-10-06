import 'package:injectable/injectable.dart';

import '../../infrastructure/data/pedestrian_bridge_coordinates.dart';
import '../entities/coordinates_entity.dart';

@test
@injectable
class IPedestrianBridgeRepo {
  List<CoordinatesEntity> getPedestrianBridgeCoordinates() =>
      pedestrianBridgeCoordinates;
}
