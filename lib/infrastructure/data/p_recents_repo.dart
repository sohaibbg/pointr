import 'dart:async';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/coordinates_entity.dart';
import '../../domain/entities/searchable_place.dart';
import '../../domain/repositories/i_recents_repo.dart';
import '../services/packages/database.dart';

@dev
@prod
@Injectable(as: IRecentsRepo)
class PRecentsRepo implements IRecentsRepo {
  final table = AppDatabase.instance.recents;

  /// may get less than [length]
  @override
  Future<List<RecentEntity>> get({int length = 5}) async {
    final simpleSelectStatement = AppDatabase.instance.select(table)
      ..orderBy(
        [
          (t) => OrderingTerm(
                expression: t.counter,
                mode: OrderingMode.desc,
              ),
        ],
      )
      ..limit(length);
    final topNRecents = await simpleSelectStatement.get();
    return topNRecents
        .map(
          (recent) => RecentEntity(
            coordinates: CoordinatesEntity(recent.lat, recent.lng),
            name: recent.name,
          ),
        )
        .toList();
  }

  @override
  Future<void> record(
    RecentEntity e,
  ) =>
      AppDatabase.instance.into(table).insert(
            RecentsCompanion.insert(
              name: e.name,
              lat: e.coordinates.latitude,
              lng: e.coordinates.longitude,
            ),
            onConflict: DoUpdate(
              (old) => RecentsCompanion.custom(
                counter: old.counter + const Constant(1),
              ),
            ),
          );

  @override
  Future<List<RecentEntity>> search(
    String term, {
    int length = 2,
  }) async {
    final stmt = AppDatabase.instance.select(table)
      ..where(
        (recent) => recent.name.lower().contains(term.toLowerCase()),
      )
      ..orderBy(
        [
          (t) => OrderingTerm(
                expression: t.counter,
                mode: OrderingMode.desc,
              ),
        ],
      )
      ..limit(length);
    final result = await stmt.get();
    return result
        .map(
          (recent) => RecentEntity(
            coordinates: CoordinatesEntity(recent.lat, recent.lng),
            name: recent.name,
          ),
        )
        .toList();
  }
}
