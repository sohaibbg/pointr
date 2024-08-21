import 'dart:async';

import 'package:injectable/injectable.dart';

import '../entities/coordinates_entity.dart';
import '../entities/favorite_entity.dart';

@test
@injectable
class IFavoritesRepo {
  static final List<FavoriteEntity> _state = [];

  Future<List<FavoriteEntity>> getAll() async => _state;

  Future<void> update(
    String prevName, {
    required CoordinatesEntity coordinates,
  }) async {
    if (!_state.any((e) => e.name == prevName)) {
      throw '$prevName named favorite does not exist';
    }
    _state.removeWhere((e) => e.name == prevName);
    final newFav = FavoriteEntity(
      coordinates: coordinates,
      name: prevName,
    );
    _state.add(newFav);
  }

  Future<void> delete(String name) async => _state.removeWhere(
        (e) => e.name == name,
      );

  Future<void> insert(
    FavoriteEntity newFav,
  ) async {
    if (_state.any((e) => e.name == newFav.name)) {
      throw '${newFav.name} named favorite already exists ';
    }
    _state.add(newFav);
  }

  Future<bool> doesTitleAlreadyExist(String name) async => _state.any(
        (e) => e.name == name,
      );
}
