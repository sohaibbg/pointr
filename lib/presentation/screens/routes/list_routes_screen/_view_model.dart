part of 'list_routes_screen.dart';

final _filterProvider = StateProvider<Set<RouteMode>>(
  (ref) => RouteMode.values.toSet(),
);
final _selectedRoutesProvider = StateProvider<Set<RouteEntity>>(
  (ref) => {},
);
final _searchTermProvider = StateProvider<String>(
  (ref) => "",
);

class _ListRoutesViewModel extends ViewModel<ListRoutesScreen> {
  const _ListRoutesViewModel(super.context, super.ref);

  List<RouteEntity> calcFilteredRoutes() {
    final searchTerm = ref.watch(_searchTermProvider);
    final filter = ref.watch(_filterProvider);
    final allRoutes = ref.watch(routesUseCaseProvider).requireValue;
    final filteredRoutes = allRoutes.where(
      (route) {
        final isModeFilteredOut = !filter.contains(route.mode);
        final nameCleaned = route.name.toLowerCase().replaceAll(' ', '');
        final searchTermCleaned = searchTerm.toLowerCase().replaceAll(' ', '');
        final doesSearchTermPass = nameCleaned.contains(searchTermCleaned) ||
            searchTermCleaned.contains(nameCleaned);
        return !isModeFilteredOut && (searchTerm.isEmpty || doesSearchTermPass);
      },
    ).toList();
    return filteredRoutes;
  }

  void onModeFiltered(bool value, RouteMode mode) {
    final filter = ref.read(_filterProvider);
    final isSelected = filter.contains(mode);
    if (isSelected && filter.length == 1) return;
    ref
        .read(
          _filterProvider.notifier,
        )
        .state = filter.toggle(mode).toSet();
  }

  String selectedRoutesConstructor() => ref
      .read(
        _selectedRoutesProvider,
      )
      .map(
        (e) {
          final pointsConstructor = e.points
              .map(
                (point) =>
                    'CoordinatesEntity(${point.latitude}, ${point.longitude})',
              )
              .toList();
          return 'RouteEntity(mode: ${e.mode}, name: "${e.name}", points: $pointsConstructor)';
        },
      )
      .toList()
      .toString();
}
