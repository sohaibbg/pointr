import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/injector.dart';
import '../entities/searchable_place.dart';
import '../repositories/i_recents_repo.dart';

part 'recents_use_case.g.dart';

@Riverpod(keepAlive: true)
class RecentsUseCase extends _$RecentsUseCase {
  static final repo = getIt.call<IRecentsRepo>();

  @override
  Future<List<RecentEntity>> build() {
    repo.deleteAllOlderThan30Days();
    return repo.get(length: 5);
  }

  Future<void> record(AddressEntity e) async {
    await repo.record(e);
    ref.invalidateSelf();
  }

  Future<void> clearRecord(RecentEntity e) async {
    await repo.clearRecord(e);
    ref.invalidateSelf();
  }
}
