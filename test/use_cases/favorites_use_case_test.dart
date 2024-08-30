import 'package:pointr/config/injector.dart';
import 'package:pointr/domain/entities/coordinates_entity.dart';
import 'package:pointr/domain/entities/searchable_place.dart';
import 'package:pointr/domain/use_cases/favorites_use_case.dart';
import 'package:test/test.dart';

import '../utilities/riverpod.dart';

void main() {
  configureDependencies();
  group(
    'favorites use case',
    () {
      test(
        'insertion',
        () async {
          final container = createContainer();
          const toBeInserted = FavoriteEntity(
            coordinates: CoordinatesEntity(1, 2),
            name: 'name',
          );
          await container
              .read(favoritesUseCaseProvider.notifier)
              .insert(toBeInserted);
          final providerVal = container.read(favoritesUseCaseProvider).value;
          expect(
            providerVal!.first,
            toBeInserted,
          );
        },
      );
      test(
        'deletion',
        () async {
          final container = createContainer();
          const insertee = FavoriteEntity(
            coordinates: CoordinatesEntity(1, 2),
            name: 'name',
          );
          final actor = container.read(favoritesUseCaseProvider.notifier);
          await actor.insert(insertee);
          await actor.delete('name');
          final providerVal = container.read(favoritesUseCaseProvider).value;
          expect(
            providerVal!.isEmpty,
            true,
          );
        },
      );
      test(
        'update',
        () async {
          final container = createContainer();
          const insertee = FavoriteEntity(
            coordinates: CoordinatesEntity(1, 2),
            name: 'name',
          );
          final actor = container.read(favoritesUseCaseProvider.notifier);
          await actor.insert(insertee);
          await actor.updateExisting(
            'name',
            coordinates: const CoordinatesEntity(3, 4),
          );
          final providerVal = container.read(favoritesUseCaseProvider).value;
          expect(
            providerVal!.first,
            const FavoriteEntity(
              name: 'name',
              coordinates: CoordinatesEntity(3, 4),
            ),
          );
        },
      );
      test(
        'check if titled favorite exists',
        () async {
          final container = createContainer();
          final actor = container.read(favoritesUseCaseProvider.notifier);
          expect(await actor.doesTitleAlreadyExist('name'), false);
          const insertee = FavoriteEntity(
            coordinates: CoordinatesEntity(1, 2),
            name: 'name',
          );
          await actor.insert(insertee);
          expect(
            await actor.doesTitleAlreadyExist('name'),
            true,
          );
        },
      );
    },
  );
}
