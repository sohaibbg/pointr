// ignore: depend_on_referenced_packages, implementation_imports
import 'package:geolocator_platform_interface/src/enums/location_permission.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../config/injector.dart';
import '../entities/searchable_place.dart';
import '../repositories/i_places_repo.dart';
import '../repositories/i_recents_repo.dart';
import 'location_use_case.dart';
import 'places_use_case.dart';

part 'suggestions_use_case.g.dart';

@riverpod
Stream<List<SearchablePlace>> searchSuggestions(
  SearchSuggestionsRef ref,
  String term,
) async* {
  final results = <SearchablePlace>[];
  final recents = await getIt.call<IRecentsRepo>().search(term);
  results.addAll(recents);
  if (results.isNotEmpty) yield results;
  final permission = await ref.read(locPermissionProvider.future);
  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    final coordinates = await ref.read(currentLocProvider.future);
    final nearby = await ref.read(
      NearbyPlacesFromCoordinatesProvider(coordinates).future,
    );
    results.insertAll(results.length, nearby);
    if (results.isNotEmpty) yield results;
  }
  final autoComplete = await _googlePlacesAutoComplete(ref, term);
  if (autoComplete == null) return;
  results.insertAll(results.length, autoComplete);
  yield results;
}

Future<List<AutocompleteSuggestionEntity>?> _googlePlacesAutoComplete(
  SearchSuggestionsRef ref,
  String term,
) async {
  if (term.isEmpty) return [];
  // We capture whether the provider is currently disposed or not.
  bool didDispose = false;
  ref.onDispose(() => didDispose = true);

  // We delay the request to wait for the user to stop typing
  await Future.delayed(const Duration(seconds: 1));

  // If the provider was disposed during the delay, it means that the user
  // refreshed again. We throw an exception to cancel the request.
  // It is safe to use an exception here, as it will be caught by Riverpod.
  if (didDispose) return null;

  return getIt.call<IPlacesRepo>().getAutocompleteSuggestions(term.trim());
}

Future<void> addToHistory(
  RecentEntity address,
  WidgetRef ref,
) async {
  await getIt.call<IRecentsRepo>().record(address);
  ref.invalidate(searchSuggestionsProvider(''));
}
