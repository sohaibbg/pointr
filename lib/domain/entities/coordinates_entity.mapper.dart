// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'coordinates_entity.dart';

class CoordinatesEntityMapper extends ClassMapperBase<CoordinatesEntity> {
  CoordinatesEntityMapper._();

  static CoordinatesEntityMapper? _instance;
  static CoordinatesEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CoordinatesEntityMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CoordinatesEntity';

  static double _$latitude(CoordinatesEntity v) => v.latitude;
  static const Field<CoordinatesEntity, double> _f$latitude =
      Field('latitude', _$latitude);
  static double _$longitude(CoordinatesEntity v) => v.longitude;
  static const Field<CoordinatesEntity, double> _f$longitude =
      Field('longitude', _$longitude);

  @override
  final MappableFields<CoordinatesEntity> fields = const {
    #latitude: _f$latitude,
    #longitude: _f$longitude,
  };

  @override
  final MappingHook hook = const _JsonEncoderHook();
  static CoordinatesEntity _instantiate(DecodingData data) {
    return CoordinatesEntity(data.dec(_f$latitude), data.dec(_f$longitude));
  }

  @override
  final Function instantiate = _instantiate;

  static CoordinatesEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CoordinatesEntity>(map);
  }

  static CoordinatesEntity fromJson(String json) {
    return ensureInitialized().decodeJson<CoordinatesEntity>(json);
  }
}

mixin CoordinatesEntityMappable {
  String toJson() {
    return CoordinatesEntityMapper.ensureInitialized()
        .encodeJson<CoordinatesEntity>(this as CoordinatesEntity);
  }

  Map<String, dynamic> toMap() {
    return CoordinatesEntityMapper.ensureInitialized()
        .encodeMap<CoordinatesEntity>(this as CoordinatesEntity);
  }

  CoordinatesEntityCopyWith<CoordinatesEntity, CoordinatesEntity,
          CoordinatesEntity>
      get copyWith => _CoordinatesEntityCopyWithImpl(
          this as CoordinatesEntity, $identity, $identity);
  @override
  String toString() {
    return CoordinatesEntityMapper.ensureInitialized()
        .stringifyValue(this as CoordinatesEntity);
  }

  @override
  bool operator ==(Object other) {
    return CoordinatesEntityMapper.ensureInitialized()
        .equalsValue(this as CoordinatesEntity, other);
  }

  @override
  int get hashCode {
    return CoordinatesEntityMapper.ensureInitialized()
        .hashValue(this as CoordinatesEntity);
  }
}

extension CoordinatesEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CoordinatesEntity, $Out> {
  CoordinatesEntityCopyWith<$R, CoordinatesEntity, $Out>
      get $asCoordinatesEntity =>
          $base.as((v, t, t2) => _CoordinatesEntityCopyWithImpl(v, t, t2));
}

abstract class CoordinatesEntityCopyWith<$R, $In extends CoordinatesEntity,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({double? latitude, double? longitude});
  CoordinatesEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _CoordinatesEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CoordinatesEntity, $Out>
    implements CoordinatesEntityCopyWith<$R, CoordinatesEntity, $Out> {
  _CoordinatesEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CoordinatesEntity> $mapper =
      CoordinatesEntityMapper.ensureInitialized();
  @override
  $R call({double? latitude, double? longitude}) => $apply(FieldCopyWithData({
        if (latitude != null) #latitude: latitude,
        if (longitude != null) #longitude: longitude
      }));
  @override
  CoordinatesEntity $make(CopyWithData data) => CoordinatesEntity(
      data.get(#latitude, or: $value.latitude),
      data.get(#longitude, or: $value.longitude));

  @override
  CoordinatesEntityCopyWith<$R2, CoordinatesEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _CoordinatesEntityCopyWithImpl($value, $cast, t);
}
