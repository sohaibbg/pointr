import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/injector.dart';
import '../../infrastructure/services/packages/iterable.dart';
import '../entities/coordinates_entity.dart';
import '../entities/searchable_place.dart';
import '../repositories/i_favorites_repo.dart';

part 'favorites_use_case.g.dart';

@riverpod
class FavoritesUseCase extends _$FavoritesUseCase {
  final repo = getIt.call<IFavoritesRepo>();

  @override
  Future<List<FavoriteEntity>> build() => repo.getAll();

  Future<void> updateExisting(
    String prevName, {
    required CoordinatesEntity coordinates,
  }) =>
      repo
          .update(
        prevName,
        coordinates: coordinates,
      )
          .then(
        (value) {
          final newState = state.value!.replaceWhere(
            (e) => e.name == prevName,
            (e) => e.copyWith(
              coordinates: coordinates,
            ),
          );
          state = AsyncData(newState.toList());
        },
      );

  Future<void> delete(String name) => repo.delete(name).then(
        (value) {
          final value = state.value!
            ..removeWhere(
              (element) => element.name == name,
            );
          state = AsyncData(value.toList());
        },
      );

  Future<void> insert(
    FavoriteEntity newFav,
  ) =>
      repo.insert(newFav).then(
            (value) => state = AsyncData(
              state.value!..add(newFav),
            ),
          );

  Future<bool> doesTitleAlreadyExist(String name) =>
      repo.doesTitleAlreadyExist(name);
}
