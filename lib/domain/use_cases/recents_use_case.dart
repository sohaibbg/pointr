import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/injector.dart';
import '../entities/searchable_place.dart';
import '../repositories/i_recents_repo.dart';

part 'recents_use_case.g.dart';

@Riverpod(keepAlive: true)
class RecentsUseCase extends _$RecentsUseCase {
  static final repo = getIt.call<IRecentsRepo>();

  @override
  Future<List<RecentEntity>> build() => repo.get(length: 5);

  Future<void> record(RecentEntity e) async {
    await repo.record(e);
    ref.invalidateSelf();
  }
}
