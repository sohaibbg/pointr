// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'favorite_entity.dart';

class FavoriteEntityMapper extends ClassMapperBase<FavoriteEntity> {
  FavoriteEntityMapper._();

  static FavoriteEntityMapper? _instance;
  static FavoriteEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FavoriteEntityMapper._());
      CoordinatesEntityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FavoriteEntity';

  static CoordinatesEntity _$coordinates(FavoriteEntity v) => v.coordinates;
  static const Field<FavoriteEntity, CoordinatesEntity> _f$coordinates =
      Field('coordinates', _$coordinates);
  static String _$name(FavoriteEntity v) => v.name;
  static const Field<FavoriteEntity, String> _f$name = Field('name', _$name);

  @override
  final MappableFields<FavoriteEntity> fields = const {
    #coordinates: _f$coordinates,
    #name: _f$name,
  };

  static FavoriteEntity _instantiate(DecodingData data) {
    return FavoriteEntity(
        coordinates: data.dec(_f$coordinates), name: data.dec(_f$name));
  }

  @override
  final Function instantiate = _instantiate;

  static FavoriteEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FavoriteEntity>(map);
  }

  static FavoriteEntity fromJson(String json) {
    return ensureInitialized().decodeJson<FavoriteEntity>(json);
  }
}

mixin FavoriteEntityMappable {
  String toJson() {
    return FavoriteEntityMapper.ensureInitialized()
        .encodeJson<FavoriteEntity>(this as FavoriteEntity);
  }

  Map<String, dynamic> toMap() {
    return FavoriteEntityMapper.ensureInitialized()
        .encodeMap<FavoriteEntity>(this as FavoriteEntity);
  }

  FavoriteEntityCopyWith<FavoriteEntity, FavoriteEntity, FavoriteEntity>
      get copyWith => _FavoriteEntityCopyWithImpl(
          this as FavoriteEntity, $identity, $identity);
  @override
  String toString() {
    return FavoriteEntityMapper.ensureInitialized()
        .stringifyValue(this as FavoriteEntity);
  }

  @override
  bool operator ==(Object other) {
    return FavoriteEntityMapper.ensureInitialized()
        .equalsValue(this as FavoriteEntity, other);
  }

  @override
  int get hashCode {
    return FavoriteEntityMapper.ensureInitialized()
        .hashValue(this as FavoriteEntity);
  }
}

extension FavoriteEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FavoriteEntity, $Out> {
  FavoriteEntityCopyWith<$R, FavoriteEntity, $Out> get $asFavoriteEntity =>
      $base.as((v, t, t2) => _FavoriteEntityCopyWithImpl(v, t, t2));
}

abstract class FavoriteEntityCopyWith<$R, $In extends FavoriteEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  CoordinatesEntityCopyWith<$R, CoordinatesEntity, CoordinatesEntity>
      get coordinates;
  $R call({CoordinatesEntity? coordinates, String? name});
  FavoriteEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _FavoriteEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FavoriteEntity, $Out>
    implements FavoriteEntityCopyWith<$R, FavoriteEntity, $Out> {
  _FavoriteEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FavoriteEntity> $mapper =
      FavoriteEntityMapper.ensureInitialized();
  @override
  CoordinatesEntityCopyWith<$R, CoordinatesEntity, CoordinatesEntity>
      get coordinates =>
          $value.coordinates.copyWith.$chain((v) => call(coordinates: v));
  @override
  $R call({CoordinatesEntity? coordinates, String? name}) =>
      $apply(FieldCopyWithData({
        if (coordinates != null) #coordinates: coordinates,
        if (name != null) #name: name
      }));
  @override
  FavoriteEntity $make(CopyWithData data) => FavoriteEntity(
      coordinates: data.get(#coordinates, or: $value.coordinates),
      name: data.get(#name, or: $value.name));

  @override
  FavoriteEntityCopyWith<$R2, FavoriteEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _FavoriteEntityCopyWithImpl($value, $cast, t);
}
