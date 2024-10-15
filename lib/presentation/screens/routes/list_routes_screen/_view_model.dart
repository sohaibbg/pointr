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

  bool get showSelectAllRoutesBtn => ref
      .watch(
        routesUseCaseProvider,
      )
      .when(
        data: (allRoutes) {
          final filter = ref.read(_filterProvider);
          allRoutes.removeWhere(
            (r) => !filter.contains(r.mode),
          );
          final selectedRoutes = ref.read(_selectedRoutesProvider);
          final areAllRoutesSelected = allRoutes.every(
            selectedRoutes.contains,
          );
          if (areAllRoutesSelected) return false;
          return true;
        },
        error: (error, stackTrace) => false,
        loading: () => false,
      );

  Future<void> onShare() {
    final routes = ref.read(_selectedRoutesProvider);
    final list = routes.map((e) => e.toBase64()).toList();
    final json = jsonEncode(list);
    final code = base64.encode(utf8.encode(json));
    final message =
        '''View routes for ${routes.map((e) => e.name).join(', ')} on Pointr.

https://sharepointr.sohaibcreates.com/route?routesCode=$code''';
    return Share.share(message);
  }

  List<RouteEntity> _codeToRoutes(String code) {
    final source = utf8.decode(base64.decode(code));
    final json = jsonDecode(source) as List;
    final routes = json
        .map(
          (e) => RouteEntity.fromBase64(e),
        )
        .toList();
    return routes;
  }

  void onRouteInsertAsCode() async {
    final code = await context.textFieldDialog(
      hintText: 'Type code',
      confirmText: 'Insert routes',
      showPasteFromClipboardBtn: true,
    );
    if (code == null) return;
    final objects = _codeToRoutes(code);
    context.loaderWithErrorDialog(
      () => Future(
        () async {
          final routes = await ref.read(routesUseCaseProvider.future);
          final names = routes.map((e) => e.name);
          objects.removeWhere((e) => names.contains(e.name));
          for (final obj in objects) {
            await ref
                .read(
                  routesUseCaseProvider.notifier,
                )
                .addRoute(obj);
          }
        },
      ).timeout(const Duration(seconds: 10)),
    );
  }

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
    ref.invalidate(routesUseCaseProvider);
  }

  Future<void> evaluateRouteSharedAsCode() async {
    final code = widget.routesAsCode;
    if (code == null) return;
    if (!context.mounted) return;
    final allRoutesNames = await () async {
      final routes = await ref.read(
        routesUseCaseProvider.future,
      );
      return routes.map((e) => e.name);
    }();
    final codeRoutes = _codeToRoutes(code);
    if (codeRoutes.isEmpty) return;
    final conflictingRoutes = codeRoutes.where(
      (r) => allRoutesNames.contains(r.name),
    );
    final nonConflictingRoutes = codeRoutes.where(
      (r) => !allRoutesNames.contains(r.name),
    );
    if (!context.mounted) return;
    final nonConflictingRouteNames =
        nonConflictingRoutes.map((e) => e.name).join(', ');
    final conflictingRouteNames =
        conflictingRoutes.map((e) => e.name).join(', ');
    final content = <String>[];
    if (nonConflictingRouteNames.isNotEmpty) {
      content.add('Do you want to add $nonConflictingRouteNames?');
    }
    if (conflictingRouteNames.isNotEmpty) {
      content.add(
        '$conflictingRouteNames will not be added as their name conflicts with an existing route.',
      );
    }
    final confirmationFuture = context.simpleDialog(
      title: 'Add Routes',
      content: content.join('\n\n'),
      alternativeAction: conflictingRouteNames.isNotEmpty
          ? ElevatedButton(
              onPressed: () => context.pop(true),
              child: const Text("Confirm"),
            )
          : null,
    );
    final didConfirm = (await confirmationFuture) == true;
    if (!didConfirm) return;
    if (!context.mounted) return;
    context.loaderWithErrorDialog(
      () async {
        for (final route in nonConflictingRoutes) {
          await ref.read(routesUseCaseProvider.notifier).addRoute(route);
        }
      },
    );
  }

  Future<void> showTutorial() async {
    const flag = InitialDisclaimer.addNewRoutes;
    final shouldTutorialBeShown = await shouldFlagBeShown(
      flag,
      context: context,
    );
    if (!shouldTutorialBeShown) return;
    final tutorialCoachMark = TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: 'ListRoutesScreen.createRouteKey',
          keyTarget: ListRoutesScreen.createRouteKey,
          enableOverlayTab: true,
          paddingFocus: 0,
          enableTargetTab: true,
          shape: ShapeLightFocus.RRect,
          contents: [
            TargetContent(
              padding: EdgeInsets.zero,
              customPosition: CustomTargetContentPosition(
                top: -200,
              ),
              align: ContentAlign.top,
              child: Text(
                '''You can create your own ${RouteMode.values.map((e) => e.name)} routes by tapping here.''',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
//         TargetFocus(
//           identify: 'ListRoutesScreen.insertFromCodeKey',
//           keyTarget: ListRoutesScreen.insertFromCodeKey,
//           enableOverlayTab: true,
//           paddingFocus: 0,
//           enableTargetTab: true,
//           shape: ShapeLightFocus.RRect,
//           contents: [
//             TargetContent(
//               padding: EdgeInsets.zero,
//               customPosition: CustomTargetContentPosition(
//                 top: -200,
//               ),
//               align: ContentAlign.top,
//               child: const Text(
//                 '''You can copy routes as a string of code (select a route to see the copy button).

// Those you share the code with then add it to their collection by tapping this button.''',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20.0,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ],
//         ),
      ],
      hideSkip: true,
      onFinish: () => flagTutorialAsSuccessfullyShown(flag),
    );
    tutorialCoachMark.show(context: context);
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
          return 'RouteEntity(mode: ${e.mode}, name: "${e.name}", mode: RouteMode.minibus, points: $pointsConstructor)';
        },
      )
      .toList()
      .toString();
}
