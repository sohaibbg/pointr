// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, Favorite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      check: () => name.isNotValue(''),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
      'lat', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
      'lng', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, lat, lng];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites';
  @override
  VerificationContext validateIntegrity(Insertable<Favorite> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
          _latMeta, lat.isAcceptableOrUnknown(data['lat']!, _latMeta));
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lng')) {
      context.handle(
          _lngMeta, lng.isAcceptableOrUnknown(data['lng']!, _lngMeta));
    } else if (isInserting) {
      context.missing(_lngMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Favorite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Favorite(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      lat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lat'])!,
      lng: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lng'])!,
    );
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(attachedDatabase, alias);
  }
}

class Favorite extends DataClass implements Insertable<Favorite> {
  final int id;
  final String name;
  final double lat;
  final double lng;
  const Favorite(
      {required this.id,
      required this.name,
      required this.lat,
      required this.lng});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['lat'] = Variable<double>(lat);
    map['lng'] = Variable<double>(lng);
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      id: Value(id),
      name: Value(name),
      lat: Value(lat),
      lng: Value(lng),
    );
  }

  factory Favorite.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Favorite(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      lat: serializer.fromJson<double>(json['lat']),
      lng: serializer.fromJson<double>(json['lng']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'lat': serializer.toJson<double>(lat),
      'lng': serializer.toJson<double>(lng),
    };
  }

  Favorite copyWith({int? id, String? name, double? lat, double? lng}) =>
      Favorite(
        id: id ?? this.id,
        name: name ?? this.name,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );
  Favorite copyWithCompanion(FavoritesCompanion data) {
    return Favorite(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Favorite(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, lat, lng);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favorite &&
          other.id == this.id &&
          other.name == this.name &&
          other.lat == this.lat &&
          other.lng == this.lng);
}

class FavoritesCompanion extends UpdateCompanion<Favorite> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> lat;
  final Value<double> lng;
  const FavoritesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
  });
  FavoritesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double lat,
    required double lng,
  })  : name = Value(name),
        lat = Value(lat),
        lng = Value(lng);
  static Insertable<Favorite> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? lat,
    Expression<double>? lng,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    });
  }

  FavoritesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? lat,
      Value<double>? lng}) {
    return FavoritesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng')
          ..write(')'))
        .toString();
  }
}

class $CustomRoutesTable extends CustomRoutes
    with TableInfo<$CustomRoutesTable, CustomRoute> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomRoutesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      check: () => name.isNotValue(''),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _routeModeMeta =
      const VerificationMeta('routeMode');
  @override
  late final GeneratedColumnWithTypeConverter<RouteMode, int> routeMode =
      GeneratedColumn<int>('route_mode', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<RouteMode>($CustomRoutesTable.$converterrouteMode);
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumnWithTypeConverter<List<CoordinatesEntity>, String>
      points = GeneratedColumn<String>('points', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<CoordinatesEntity>>(
              $CustomRoutesTable.$converterpoints);
  @override
  List<GeneratedColumn> get $columns => [id, name, routeMode, points];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_routes';
  @override
  VerificationContext validateIntegrity(Insertable<CustomRoute> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    context.handle(_routeModeMeta, const VerificationResult.success());
    context.handle(_pointsMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomRoute map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomRoute(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      routeMode: $CustomRoutesTable.$converterrouteMode.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}route_mode'])!),
      points: $CustomRoutesTable.$converterpoints.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}points'])!),
    );
  }

  @override
  $CustomRoutesTable createAlias(String alias) {
    return $CustomRoutesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RouteMode, int, int> $converterrouteMode =
      const EnumIndexConverter<RouteMode>(RouteMode.values);
  static TypeConverter<List<CoordinatesEntity>, String> $converterpoints =
      const CoordinatesListConverter();
}

class CustomRoute extends DataClass implements Insertable<CustomRoute> {
  final int id;
  final String name;
  final RouteMode routeMode;
  final List<CoordinatesEntity> points;
  const CustomRoute(
      {required this.id,
      required this.name,
      required this.routeMode,
      required this.points});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['route_mode'] = Variable<int>(
          $CustomRoutesTable.$converterrouteMode.toSql(routeMode));
    }
    {
      map['points'] =
          Variable<String>($CustomRoutesTable.$converterpoints.toSql(points));
    }
    return map;
  }

  CustomRoutesCompanion toCompanion(bool nullToAbsent) {
    return CustomRoutesCompanion(
      id: Value(id),
      name: Value(name),
      routeMode: Value(routeMode),
      points: Value(points),
    );
  }

  factory CustomRoute.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomRoute(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      routeMode: $CustomRoutesTable.$converterrouteMode
          .fromJson(serializer.fromJson<int>(json['routeMode'])),
      points: serializer.fromJson<List<CoordinatesEntity>>(json['points']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'routeMode': serializer.toJson<int>(
          $CustomRoutesTable.$converterrouteMode.toJson(routeMode)),
      'points': serializer.toJson<List<CoordinatesEntity>>(points),
    };
  }

  CustomRoute copyWith(
          {int? id,
          String? name,
          RouteMode? routeMode,
          List<CoordinatesEntity>? points}) =>
      CustomRoute(
        id: id ?? this.id,
        name: name ?? this.name,
        routeMode: routeMode ?? this.routeMode,
        points: points ?? this.points,
      );
  CustomRoute copyWithCompanion(CustomRoutesCompanion data) {
    return CustomRoute(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      routeMode: data.routeMode.present ? data.routeMode.value : this.routeMode,
      points: data.points.present ? data.points.value : this.points,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomRoute(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('routeMode: $routeMode, ')
          ..write('points: $points')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, routeMode, points);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomRoute &&
          other.id == this.id &&
          other.name == this.name &&
          other.routeMode == this.routeMode &&
          other.points == this.points);
}

class CustomRoutesCompanion extends UpdateCompanion<CustomRoute> {
  final Value<int> id;
  final Value<String> name;
  final Value<RouteMode> routeMode;
  final Value<List<CoordinatesEntity>> points;
  const CustomRoutesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.routeMode = const Value.absent(),
    this.points = const Value.absent(),
  });
  CustomRoutesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required RouteMode routeMode,
    required List<CoordinatesEntity> points,
  })  : name = Value(name),
        routeMode = Value(routeMode),
        points = Value(points);
  static Insertable<CustomRoute> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? routeMode,
    Expression<String>? points,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (routeMode != null) 'route_mode': routeMode,
      if (points != null) 'points': points,
    });
  }

  CustomRoutesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<RouteMode>? routeMode,
      Value<List<CoordinatesEntity>>? points}) {
    return CustomRoutesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      routeMode: routeMode ?? this.routeMode,
      points: points ?? this.points,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (routeMode.present) {
      map['route_mode'] = Variable<int>(
          $CustomRoutesTable.$converterrouteMode.toSql(routeMode.value));
    }
    if (points.present) {
      map['points'] = Variable<String>(
          $CustomRoutesTable.$converterpoints.toSql(points.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomRoutesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('routeMode: $routeMode, ')
          ..write('points: $points')
          ..write(')'))
        .toString();
  }
}

class $RecentsTable extends Recents with TableInfo<$RecentsTable, Recent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
      'lat', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
      'lng', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _counterMeta =
      const VerificationMeta('counter');
  @override
  late final GeneratedColumn<int> counter = GeneratedColumn<int>(
      'counter', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _createdMeta =
      const VerificationMeta('created');
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
      'created', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  static const VerificationMeta _updatedMeta =
      const VerificationMeta('updated');
  @override
  late final GeneratedColumn<DateTime> updated = GeneratedColumn<DateTime>(
      'updated', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  @override
  List<GeneratedColumn> get $columns =>
      [name, lat, lng, counter, created, updated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recents';
  @override
  VerificationContext validateIntegrity(Insertable<Recent> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
          _latMeta, lat.isAcceptableOrUnknown(data['lat']!, _latMeta));
    } else if (isInserting) {
      context.missing(_latMeta);
    }
    if (data.containsKey('lng')) {
      context.handle(
          _lngMeta, lng.isAcceptableOrUnknown(data['lng']!, _lngMeta));
    } else if (isInserting) {
      context.missing(_lngMeta);
    }
    if (data.containsKey('counter')) {
      context.handle(_counterMeta,
          counter.isAcceptableOrUnknown(data['counter']!, _counterMeta));
    }
    if (data.containsKey('created')) {
      context.handle(_createdMeta,
          created.isAcceptableOrUnknown(data['created']!, _createdMeta));
    }
    if (data.containsKey('updated')) {
      context.handle(_updatedMeta,
          updated.isAcceptableOrUnknown(data['updated']!, _updatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  Recent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recent(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      lat: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lat'])!,
      lng: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lng'])!,
      counter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}counter'])!,
      created: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created'])!,
      updated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated'])!,
    );
  }

  @override
  $RecentsTable createAlias(String alias) {
    return $RecentsTable(attachedDatabase, alias);
  }
}

class Recent extends DataClass implements Insertable<Recent> {
  final String name;
  final double lat;
  final double lng;
  final int counter;
  final DateTime created;
  final DateTime updated;
  const Recent(
      {required this.name,
      required this.lat,
      required this.lng,
      required this.counter,
      required this.created,
      required this.updated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['lat'] = Variable<double>(lat);
    map['lng'] = Variable<double>(lng);
    map['counter'] = Variable<int>(counter);
    map['created'] = Variable<DateTime>(created);
    map['updated'] = Variable<DateTime>(updated);
    return map;
  }

  RecentsCompanion toCompanion(bool nullToAbsent) {
    return RecentsCompanion(
      name: Value(name),
      lat: Value(lat),
      lng: Value(lng),
      counter: Value(counter),
      created: Value(created),
      updated: Value(updated),
    );
  }

  factory Recent.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recent(
      name: serializer.fromJson<String>(json['name']),
      lat: serializer.fromJson<double>(json['lat']),
      lng: serializer.fromJson<double>(json['lng']),
      counter: serializer.fromJson<int>(json['counter']),
      created: serializer.fromJson<DateTime>(json['created']),
      updated: serializer.fromJson<DateTime>(json['updated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'lat': serializer.toJson<double>(lat),
      'lng': serializer.toJson<double>(lng),
      'counter': serializer.toJson<int>(counter),
      'created': serializer.toJson<DateTime>(created),
      'updated': serializer.toJson<DateTime>(updated),
    };
  }

  Recent copyWith(
          {String? name,
          double? lat,
          double? lng,
          int? counter,
          DateTime? created,
          DateTime? updated}) =>
      Recent(
        name: name ?? this.name,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        counter: counter ?? this.counter,
        created: created ?? this.created,
        updated: updated ?? this.updated,
      );
  Recent copyWithCompanion(RecentsCompanion data) {
    return Recent(
      name: data.name.present ? data.name.value : this.name,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
      counter: data.counter.present ? data.counter.value : this.counter,
      created: data.created.present ? data.created.value : this.created,
      updated: data.updated.present ? data.updated.value : this.updated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recent(')
          ..write('name: $name, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('counter: $counter, ')
          ..write('created: $created, ')
          ..write('updated: $updated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, lat, lng, counter, created, updated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recent &&
          other.name == this.name &&
          other.lat == this.lat &&
          other.lng == this.lng &&
          other.counter == this.counter &&
          other.created == this.created &&
          other.updated == this.updated);
}

class RecentsCompanion extends UpdateCompanion<Recent> {
  final Value<String> name;
  final Value<double> lat;
  final Value<double> lng;
  final Value<int> counter;
  final Value<DateTime> created;
  final Value<DateTime> updated;
  final Value<int> rowid;
  const RecentsCompanion({
    this.name = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
    this.counter = const Value.absent(),
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecentsCompanion.insert({
    required String name,
    required double lat,
    required double lng,
    this.counter = const Value.absent(),
    this.created = const Value.absent(),
    this.updated = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        lat = Value(lat),
        lng = Value(lng);
  static Insertable<Recent> custom({
    Expression<String>? name,
    Expression<double>? lat,
    Expression<double>? lng,
    Expression<int>? counter,
    Expression<DateTime>? created,
    Expression<DateTime>? updated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
      if (counter != null) 'counter': counter,
      if (created != null) 'created': created,
      if (updated != null) 'updated': updated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecentsCompanion copyWith(
      {Value<String>? name,
      Value<double>? lat,
      Value<double>? lng,
      Value<int>? counter,
      Value<DateTime>? created,
      Value<DateTime>? updated,
      Value<int>? rowid}) {
    return RecentsCompanion(
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      counter: counter ?? this.counter,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    if (counter.present) {
      map['counter'] = Variable<int>(counter.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    if (updated.present) {
      map['updated'] = Variable<DateTime>(updated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecentsCompanion(')
          ..write('name: $name, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng, ')
          ..write('counter: $counter, ')
          ..write('created: $created, ')
          ..write('updated: $updated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FavoritesTable favorites = $FavoritesTable(this);
  late final $CustomRoutesTable customRoutes = $CustomRoutesTable(this);
  late final $RecentsTable recents = $RecentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [favorites, customRoutes, recents];
}

typedef $$FavoritesTableCreateCompanionBuilder = FavoritesCompanion Function({
  Value<int> id,
  required String name,
  required double lat,
  required double lng,
});
typedef $$FavoritesTableUpdateCompanionBuilder = FavoritesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<double> lat,
  Value<double> lng,
});

class $$FavoritesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavoritesTable,
    Favorite,
    $$FavoritesTableFilterComposer,
    $$FavoritesTableOrderingComposer,
    $$FavoritesTableCreateCompanionBuilder,
    $$FavoritesTableUpdateCompanionBuilder> {
  $$FavoritesTableTableManager(_$AppDatabase db, $FavoritesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$FavoritesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$FavoritesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> lat = const Value.absent(),
            Value<double> lng = const Value.absent(),
          }) =>
              FavoritesCompanion(
            id: id,
            name: name,
            lat: lat,
            lng: lng,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required double lat,
            required double lng,
          }) =>
              FavoritesCompanion.insert(
            id: id,
            name: name,
            lat: lat,
            lng: lng,
          ),
        ));
}

class $$FavoritesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lat => $state.composableBuilder(
      column: $state.table.lat,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lng => $state.composableBuilder(
      column: $state.table.lng,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$FavoritesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lat => $state.composableBuilder(
      column: $state.table.lat,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lng => $state.composableBuilder(
      column: $state.table.lng,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$CustomRoutesTableCreateCompanionBuilder = CustomRoutesCompanion
    Function({
  Value<int> id,
  required String name,
  required RouteMode routeMode,
  required List<CoordinatesEntity> points,
});
typedef $$CustomRoutesTableUpdateCompanionBuilder = CustomRoutesCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<RouteMode> routeMode,
  Value<List<CoordinatesEntity>> points,
});

class $$CustomRoutesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomRoutesTable,
    CustomRoute,
    $$CustomRoutesTableFilterComposer,
    $$CustomRoutesTableOrderingComposer,
    $$CustomRoutesTableCreateCompanionBuilder,
    $$CustomRoutesTableUpdateCompanionBuilder> {
  $$CustomRoutesTableTableManager(_$AppDatabase db, $CustomRoutesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CustomRoutesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CustomRoutesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<RouteMode> routeMode = const Value.absent(),
            Value<List<CoordinatesEntity>> points = const Value.absent(),
          }) =>
              CustomRoutesCompanion(
            id: id,
            name: name,
            routeMode: routeMode,
            points: points,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required RouteMode routeMode,
            required List<CoordinatesEntity> points,
          }) =>
              CustomRoutesCompanion.insert(
            id: id,
            name: name,
            routeMode: routeMode,
            points: points,
          ),
        ));
}

class $$CustomRoutesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CustomRoutesTable> {
  $$CustomRoutesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<RouteMode, RouteMode, int> get routeMode =>
      $state.composableBuilder(
          column: $state.table.routeMode,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<List<CoordinatesEntity>,
          List<CoordinatesEntity>, String>
      get points => $state.composableBuilder(
          column: $state.table.points,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));
}

class $$CustomRoutesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CustomRoutesTable> {
  $$CustomRoutesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get routeMode => $state.composableBuilder(
      column: $state.table.routeMode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get points => $state.composableBuilder(
      column: $state.table.points,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$RecentsTableCreateCompanionBuilder = RecentsCompanion Function({
  required String name,
  required double lat,
  required double lng,
  Value<int> counter,
  Value<DateTime> created,
  Value<DateTime> updated,
  Value<int> rowid,
});
typedef $$RecentsTableUpdateCompanionBuilder = RecentsCompanion Function({
  Value<String> name,
  Value<double> lat,
  Value<double> lng,
  Value<int> counter,
  Value<DateTime> created,
  Value<DateTime> updated,
  Value<int> rowid,
});

class $$RecentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecentsTable,
    Recent,
    $$RecentsTableFilterComposer,
    $$RecentsTableOrderingComposer,
    $$RecentsTableCreateCompanionBuilder,
    $$RecentsTableUpdateCompanionBuilder> {
  $$RecentsTableTableManager(_$AppDatabase db, $RecentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$RecentsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$RecentsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> name = const Value.absent(),
            Value<double> lat = const Value.absent(),
            Value<double> lng = const Value.absent(),
            Value<int> counter = const Value.absent(),
            Value<DateTime> created = const Value.absent(),
            Value<DateTime> updated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecentsCompanion(
            name: name,
            lat: lat,
            lng: lng,
            counter: counter,
            created: created,
            updated: updated,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String name,
            required double lat,
            required double lng,
            Value<int> counter = const Value.absent(),
            Value<DateTime> created = const Value.absent(),
            Value<DateTime> updated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecentsCompanion.insert(
            name: name,
            lat: lat,
            lng: lng,
            counter: counter,
            created: created,
            updated: updated,
            rowid: rowid,
          ),
        ));
}

class $$RecentsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $RecentsTable> {
  $$RecentsTableFilterComposer(super.$state);
  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lat => $state.composableBuilder(
      column: $state.table.lat,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lng => $state.composableBuilder(
      column: $state.table.lng,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get counter => $state.composableBuilder(
      column: $state.table.counter,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get created => $state.composableBuilder(
      column: $state.table.created,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updated => $state.composableBuilder(
      column: $state.table.updated,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$RecentsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $RecentsTable> {
  $$RecentsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lat => $state.composableBuilder(
      column: $state.table.lat,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lng => $state.composableBuilder(
      column: $state.table.lng,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get counter => $state.composableBuilder(
      column: $state.table.counter,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get created => $state.composableBuilder(
      column: $state.table.created,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updated => $state.composableBuilder(
      column: $state.table.updated,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FavoritesTableTableManager get favorites =>
      $$FavoritesTableTableManager(_db, _db.favorites);
  $$CustomRoutesTableTableManager get customRoutes =>
      $$CustomRoutesTableTableManager(_db, _db.customRoutes);
  $$RecentsTableTableManager get recents =>
      $$RecentsTableTableManager(_db, _db.recents);
}
