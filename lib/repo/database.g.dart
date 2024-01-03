// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FavoriteTable extends Favorite
    with TableInfo<$FavoriteTable, FavoriteData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _preferencesMeta =
      const VerificationMeta('preferences');
  @override
  late final GeneratedColumnWithTypeConverter<LocatedPlace?, String>
      preferences = GeneratedColumn<String>('preferences', aliasedName, true,
              type: DriftSqlType.string, requiredDuringInsert: false)
          .withConverter<LocatedPlace?>($FavoriteTable.$converterpreferencesn);
  @override
  List<GeneratedColumn> get $columns => [preferences];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite';
  @override
  VerificationContext validateIntegrity(Insertable<FavoriteData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    context.handle(_preferencesMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  FavoriteData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteData(
      preferences: $FavoriteTable.$converterpreferencesn.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}preferences'])),
    );
  }

  @override
  $FavoriteTable createAlias(String alias) {
    return $FavoriteTable(attachedDatabase, alias);
  }

  static TypeConverter<LocatedPlace, String> $converterpreferences =
      Favorite.converter;
  static TypeConverter<LocatedPlace?, String?> $converterpreferencesn =
      NullAwareTypeConverter.wrap($converterpreferences);
}

class FavoriteData extends DataClass implements Insertable<FavoriteData> {
  final LocatedPlace? preferences;
  const FavoriteData({this.preferences});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || preferences != null) {
      map['preferences'] = Variable<String>(
          $FavoriteTable.$converterpreferencesn.toSql(preferences));
    }
    return map;
  }

  FavoriteCompanion toCompanion(bool nullToAbsent) {
    return FavoriteCompanion(
      preferences: preferences == null && nullToAbsent
          ? const Value.absent()
          : Value(preferences),
    );
  }

  factory FavoriteData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteData(
      preferences: serializer.fromJson<LocatedPlace?>(json['preferences']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'preferences': serializer.toJson<LocatedPlace?>(preferences),
    };
  }

  FavoriteData copyWith(
          {Value<LocatedPlace?> preferences = const Value.absent()}) =>
      FavoriteData(
        preferences: preferences.present ? preferences.value : this.preferences,
      );
  @override
  String toString() {
    return (StringBuffer('FavoriteData(')
          ..write('preferences: $preferences')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => preferences.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteData && other.preferences == this.preferences);
}

class FavoriteCompanion extends UpdateCompanion<FavoriteData> {
  final Value<LocatedPlace?> preferences;
  final Value<int> rowid;
  const FavoriteCompanion({
    this.preferences = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoriteCompanion.insert({
    this.preferences = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<FavoriteData> custom({
    Expression<String>? preferences,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (preferences != null) 'preferences': preferences,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoriteCompanion copyWith(
      {Value<LocatedPlace?>? preferences, Value<int>? rowid}) {
    return FavoriteCompanion(
      preferences: preferences ?? this.preferences,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (preferences.present) {
      map['preferences'] = Variable<String>(
          $FavoriteTable.$converterpreferencesn.toSql(preferences.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteCompanion(')
          ..write('preferences: $preferences, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $FavoriteTable favorite = $FavoriteTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [favorite];
}
