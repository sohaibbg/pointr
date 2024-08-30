part of 'searchable_place.dart';

class AutocompleteSuggestionEntity implements SearchablePlace {
  const AutocompleteSuggestionEntity({
    required this.id,
    required this.name,
    required this.address,
  });

  final String id;
  @override
  final String name;
  final String address;
}
