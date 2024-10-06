import 'package:injectable/injectable.dart';

import '../../domain/entities/coordinates_entity.dart';
import '../../domain/repositories/i_pedestrian_bridge_repo.dart';
import 'pedestrian_bridge_coordinates.dart';

@dev
@prod
@Injectable(as: IPedestrianBridgeRepo)
class PPedestrianBridgeRepo implements IPedestrianBridgeRepo {
  @override
  List<CoordinatesEntity> getPedestrianBridgeCoordinates() =>
      pedestrianBridgeCoordinates;
}
