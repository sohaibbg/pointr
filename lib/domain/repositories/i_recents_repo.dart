import 'dart:async';

import 'package:injectable/injectable.dart';

import '../entities/searchable_place.dart';

@test
@injectable
class IRecentsRepo {
  static final Map<RecentEntity, int> _state = {};

  /// may get less than [length]
  Future<List<RecentEntity>> get({int length = 5}) async {
    if (_state.length < length) return _state.keys.toList();
    final sorted = _state.entries.toList()
      ..sort(
        (a, b) => a.value.compareTo(b.value),
      );
    return sorted
        .sublist(0, 5)
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
    RecentEntity e,
  ) async =>
      _state.remove(e);

  Future<void> deleteAllOlderThan30Days() async {}
}
