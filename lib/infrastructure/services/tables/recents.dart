import 'package:drift/drift.dart';

class Recents extends Table {
  @override
  Set<Column> get primaryKey => {name};
  TextColumn get name => text()();
  RealColumn get lat => real()();
  RealColumn get lng => real()();
  IntColumn get counter => integer().withDefault(const Constant(1))();
  DateTimeColumn get created =>
      dateTime().withDefault(Constant(DateTime.now()))();
  DateTimeColumn get updated =>
      dateTime().withDefault(Constant(DateTime.now()))();
}
