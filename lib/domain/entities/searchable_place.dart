import 'package:dart_mappable/dart_mappable.dart';

import 'coordinates_entity.dart';

part 'address_entity.dart';
part 'autocomplete_suggestion_entity.dart';
part 'favorite_entity.dart';
part 'named_address_entity.dart';
part 'recents_entity.dart';
part 'searchable_place.mapper.dart';

sealed class SearchablePlace {
  final String name;

  const SearchablePlace({required this.name});
}
