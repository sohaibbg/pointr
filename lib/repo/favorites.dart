import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/located_place.dart';
import 'database.dart';

part 'favorites.g.dart';

@riverpod
Future<List<LocatedPlace>> favorites(FavoritesRef ref) async {
  final database = AppDatabase();

  await database.into(database.favorite).insert(
        FavoriteCompanion.insert(),
      );
  final favs = database.select(database.favorite);
  final stream = favs.watch();
  final subscription = stream.listen(
    (event) => ref.refresh(favoritesProvider),
  );
  ref.onDispose(subscription.cancel);
  final allFavs = await favs.get();
  return allFavs
      .where((e) => e.preferences != null)
      .map((e) => e.preferences!)
      .toList();
}

class Favorite extends Table {
  static TypeConverter<LocatedPlace, String> converter = TypeConverter.json(
    fromJson: (json) => LocatedPlace.fromJson(json as Map<String, Object?>),
    toJson: (pref) => pref.toJson(),
  );

  TextColumn get preferences => text().map(converter).nullable()();
}
