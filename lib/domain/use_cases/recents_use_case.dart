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
    return repo.get();
  }

  Future<void> record(AddressEntity e) async {
    await repo.record(e);
    ref.invalidateSelf();
    ref.invalidate(searchRecentsProvider);
  }

  Future<void> clearRecord(String name) async {
    await repo.clearRecord(name);
    ref.invalidateSelf();
    ref.invalidate(searchRecentsProvider);
  }
}

@riverpod
Future<List<RecentEntity>> searchRecents(
  SearchRecentsRef ref,
  String term,
) =>
    getIt.call<IRecentsRepo>().search(term);
