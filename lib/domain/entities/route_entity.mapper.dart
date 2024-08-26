// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'route_entity.dart';

class RouteModeMapper extends EnumMapper<RouteMode> {
  RouteModeMapper._();

  static RouteModeMapper? _instance;
  static RouteModeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RouteModeMapper._());
    }
    return _instance!;
  }

  static RouteMode fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  RouteMode decode(dynamic value) {
    switch (value) {
      case 'minibus':
        return RouteMode.minibus;
      case 'redBus':
        return RouteMode.redBus;
      case 'pinkBus':
        return RouteMode.pinkBus;
      case 'chinchi':
        return RouteMode.chinchi;
      case 'greenLine':
        return RouteMode.greenLine;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(RouteMode self) {
    switch (self) {
      case RouteMode.minibus:
        return 'minibus';
      case RouteMode.redBus:
        return 'redBus';
      case RouteMode.pinkBus:
        return 'pinkBus';
      case RouteMode.chinchi:
        return 'chinchi';
      case RouteMode.greenLine:
        return 'greenLine';
    }
  }
}

extension RouteModeMapperExtension on RouteMode {
  String toValue() {
    RouteModeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<RouteMode>(this) as String;
  }
}

class RouteEntityMapper extends ClassMapperBase<RouteEntity> {
  RouteEntityMapper._();

  static RouteEntityMapper? _instance;
  static RouteEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RouteEntityMapper._());
      RouteModeMapper.ensureInitialized();
      CoordinatesEntityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'RouteEntity';

  static String _$name(RouteEntity v) => v.name;
  static const Field<RouteEntity, String> _f$name = Field('name', _$name);
  static RouteMode _$mode(RouteEntity v) => v.mode;
  static const Field<RouteEntity, RouteMode> _f$mode = Field('mode', _$mode);
  static List<CoordinatesEntity> _$points(RouteEntity v) => v.points;
  static const Field<RouteEntity, List<CoordinatesEntity>> _f$points =
      Field('points', _$points);

  @override
  final MappableFields<RouteEntity> fields = const {
    #name: _f$name,
    #mode: _f$mode,
    #points: _f$points,
  };

  static RouteEntity _instantiate(DecodingData data) {
    return RouteEntity(
        name: data.dec(_f$name),
        mode: data.dec(_f$mode),
        points: data.dec(_f$points));
  }

  @override
  final Function instantiate = _instantiate;

  static RouteEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RouteEntity>(map);
  }

  static RouteEntity fromJson(String json) {
    return ensureInitialized().decodeJson<RouteEntity>(json);
  }
}

mixin RouteEntityMappable {
  String toJson() {
    return RouteEntityMapper.ensureInitialized()
        .encodeJson<RouteEntity>(this as RouteEntity);
  }

  Map<String, dynamic> toMap() {
    return RouteEntityMapper.ensureInitialized()
        .encodeMap<RouteEntity>(this as RouteEntity);
  }

  RouteEntityCopyWith<RouteEntity, RouteEntity, RouteEntity> get copyWith =>
      _RouteEntityCopyWithImpl(this as RouteEntity, $identity, $identity);
  @override
  String toString() {
    return RouteEntityMapper.ensureInitialized()
        .stringifyValue(this as RouteEntity);
  }

  @override
  bool operator ==(Object other) {
    return RouteEntityMapper.ensureInitialized()
        .equalsValue(this as RouteEntity, other);
  }

  @override
  int get hashCode {
    return RouteEntityMapper.ensureInitialized().hashValue(this as RouteEntity);
  }
}

extension RouteEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RouteEntity, $Out> {
  RouteEntityCopyWith<$R, RouteEntity, $Out> get $asRouteEntity =>
      $base.as((v, t, t2) => _RouteEntityCopyWithImpl(v, t, t2));
}

abstract class RouteEntityCopyWith<$R, $In extends RouteEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, CoordinatesEntity,
          CoordinatesEntityCopyWith<$R, CoordinatesEntity, CoordinatesEntity>>
      get points;
  $R call({String? name, RouteMode? mode, List<CoordinatesEntity>? points});
  RouteEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _RouteEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RouteEntity, $Out>
    implements RouteEntityCopyWith<$R, RouteEntity, $Out> {
  _RouteEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RouteEntity> $mapper =
      RouteEntityMapper.ensureInitialized();
  @override
  ListCopyWith<$R, CoordinatesEntity,
          CoordinatesEntityCopyWith<$R, CoordinatesEntity, CoordinatesEntity>>
      get points => ListCopyWith($value.points, (v, t) => v.copyWith.$chain(t),
          (v) => call(points: v));
  @override
  $R call({String? name, RouteMode? mode, List<CoordinatesEntity>? points}) =>
      $apply(FieldCopyWithData({
        if (name != null) #name: name,
        if (mode != null) #mode: mode,
        if (points != null) #points: points
      }));
  @override
  RouteEntity $make(CopyWithData data) => RouteEntity(
      name: data.get(#name, or: $value.name),
      mode: data.get(#mode, or: $value.mode),
      points: data.get(#points, or: $value.points));

  @override
  RouteEntityCopyWith<$R2, RouteEntity, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _RouteEntityCopyWithImpl($value, $cast, t);
}
