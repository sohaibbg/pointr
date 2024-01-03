// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_element

part of 'located_place.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocatedPlace _$LocatedPlaceFromJson(Map<String, dynamic> json) => LocatedPlace(
      json['title'] as String,
      Coordinates.fromJson(
        (json['coordinates'] as List<dynamic>)
            .map((e) => (e as num).toDouble())
            .toList(),
      ),
    );

Map<String, dynamic> _$LocatedPlaceToJson(LocatedPlace instance) =>
    <String, dynamic>{
      'title': instance.title,
      'coordinates': instance.coordinates,
    };
