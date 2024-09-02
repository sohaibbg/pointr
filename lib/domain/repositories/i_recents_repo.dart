import 'dart:async';

import 'package:injectable/injectable.dart';

import '../entities/searchable_place.dart';

@test
@injectable
class IRecentsRepo {
  static final Map<RecentEntity, int> _state = {};

  /// may get less than [length]
  Future<List<RecentEntity>> get() async {
    final sorted = _state.entries.toList()
      ..sort(
        (a, b) => a.value.compareTo(b.value),
      );
    return sorted
        .map(
          (e) => e.key,
        )
        .toList();
  }

  Future<List<RecentEntity>> search(
    String term, {
    int length = 2,
  }) async =>
      _state.keys.toList();

  Future<void> record(
    AddressEntity e,
  ) async {
    e = RecentEntity(
      coordinates: e.coordinates,
      name: e.name,
    );
    if (_state.containsKey(e)) {
      _state[e as RecentEntity] = _state[e]! + 1;
      return;
    }
    _state[e as RecentEntity] = 1;
  }

  Future<void> clearRecord(
    String name,
  ) async =>
      _state.removeWhere((e, _) => e.name == name);

  Future<void> deleteAllOlderThan30Days() async {}
}
