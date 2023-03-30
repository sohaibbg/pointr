import 'package:pointr/classes/place.dart';

class GooglePlace implements Place {
  @override
  final String title;
  final String placeId;
  const GooglePlace({required this.placeId, required this.title});
}
