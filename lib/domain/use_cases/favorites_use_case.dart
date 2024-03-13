import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/injector.dart';
import '../entities/coordinates_entity.dart';
import '../entities/favorite_entity.dart';
import '../repositories/i_favorites_repo.dart';

part 'favorites_use_case.g.dart';

@riverpod
class FavoritesUseCase extends _$FavoritesUseCase {
  final repo = getIt.call<IFavoritesRepo>();

  @override
  Future<IList<FavoriteEntity>> build() => repo.getAll().then(
        (value) => value.toIList(),
      );

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
            (value) => state = AsyncData(
              state.value!.updateById(
                [
                  FavoriteEntity(
                    coordinates: coordinates,
                    name: prevName,
                  ),
                ],
                (item) => item.name,
              ),
            ),
          );

  Future<void> delete(String name) => repo.delete(name).then(
        (value) => state = AsyncData(
          state.value!.removeWhere(
            (element) => element.name == name,
          ),
        ),
      );

  Future<void> insert(
    FavoriteEntity newFav,
  ) =>
      repo.insert(newFav).then(
            (value) => state = AsyncData(
              state.value!.add(newFav),
            ),
          );

  Future<bool> doesTitleAlreadyExist(String name) =>
      repo.doesTitleAlreadyExist(name);
}
