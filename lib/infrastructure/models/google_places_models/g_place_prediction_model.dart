import 'package:flutter/cupertino.dart';

import '../../../domain/entities/autocomplete_suggestion_entity.dart';

class GPlacePredictionModel {
  final dynamic place;
  final dynamic placeId;
  final Map text;
  final Map structuredFormat;
  final dynamic types;

  const GPlacePredictionModel._({
    required this.place,
    required this.placeId,
    required this.text,
    required this.structuredFormat,
    required this.types,
  });

  factory GPlacePredictionModel.fromMap(Map m) => GPlacePredictionModel._(
        place: m['place'],
        placeId: m['placeId'],
        text: m['text'],
        structuredFormat: m['structuredFormat'],
        types: m['types'],
      );

  AutocompleteSuggestionEntity toAutocompleteSuggestionEntity() {
    final name = structuredFormat['mainText']['text'];
    final address = (text['text'] as String).replaceFirst('$name, ', '');
    return AutocompleteSuggestionEntity(
      id: placeId,
      name: AutofillHints.telephoneNumberLocalPrefix,
      address: address,
    );
  }
}
