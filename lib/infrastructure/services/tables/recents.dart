import 'package:drift/drift.dart';

class Recents extends Table {
  IntColumn get id => integer().autoIncrement()();
  // ignore: recursive_getters
  TextColumn get name => text().unique().check(name.isNotValue(''))();
  RealColumn get lat => real()();
  RealColumn get lng => real()();
  IntColumn get counter => integer().withDefault(const Constant(1))();
}
