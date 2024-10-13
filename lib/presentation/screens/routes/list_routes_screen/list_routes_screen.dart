import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../config/injector.dart';
import '../../../../config/my_theme.dart';
import '../../../../domain/entities/route_entity.dart';
import '../../../../domain/repositories/i_initial_disclaimers_shown_repo.dart';
import '../../../../domain/use_cases/routes_use_case.dart';
import '../../../../infrastructure/services/packages/hooks.dart';
import '../../../../infrastructure/services/packages/iterable.dart';
import '../../../../infrastructure/services/packages/view_model.dart';
import '../../../components/aligned_dialog_pusher_box.dart';
import '../../../components/dialogs.dart';
import '../../../components/header_footer.dart';
import '../../../components/slide_transition_helper.dart';
import '../../../components/space.dart';

part '_view_model.dart';

class ListRoutesScreen extends HookConsumerWidget {
  const ListRoutesScreen({super.key});

  static final createRouteKey = GlobalKey(debugLabel: 'createRoutebtn');
  static final insertFromCodeKey = GlobalKey(debugLabel: 'insertFromCodeBtn');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = _ListRoutesViewModel(context, ref);
    useEffect(
      () {
        vm.initState();
        return null;
      },
      const [],
    );
    final title = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context)
              .textTheme
              .displayMedium
              ?.copyWith(color: Colors.grey.shade800),
          children: const [
            TextSpan(
              text: "Explore existing routes",
              // style: TextStyle(fontWeight: FontWeight.w200),
            ),
            TextSpan(
              text: " (or create your own!)",
              style: TextStyle(
                fontWeight: FontWeight.w200,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
    final insertRouteFromCodeBtn = ElevatedButton.icon(
      key: insertFromCodeKey,
      onPressed: vm.onRouteInsertAsCode,
      label: const Text("Insert Route from Code"),
      icon: const Icon(Icons.password),
      style: MyTheme.secondaryOutlinedButtonStyle,
    );
    final createRoutebtn = ElevatedButton.icon(
      key: createRouteKey,
      onPressed: () => context.go('/route/create'),
      label: const Text("Draw new Route"),
      icon: const Icon(Icons.route),
      style: MyTheme.secondaryOutlinedButtonStyle,
    );
    final watchRoutes = ref.watch(routesUseCaseProvider);
    final routeList = watchRoutes.when(
      data: (data) => _RoutesDataView(data),
      error: (error, stackTrace) => const SliverToBoxAdapter(
        child: Center(
          child: Text(
            "An error occurred. Please try again later.",
          ),
        ),
      ),
      loading: () => Skeletonizer.sliver(
        child: _RoutesDataView(
          isForSkeletonizer: true,
          List.generate(
            7,
            (index) => RouteEntity(
              name: BoneMock.name,
              mode: RouteMode.minibus,
              points: [],
            ),
          ),
        ),
      ),
    );
    final customScrollView = CustomScrollView(
      clipBehavior: Clip.hardEdge,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final height = MediaQuery.sizeOf(context).height;
                  final topPadding = height < 732
                      ? 48
                      : height < 800
                          ? 96
                          : 230;
                  return topPadding.verticalSpace;
                },
              ),
              title,
              24.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    insertRouteFromCodeBtn,
                    createRoutebtn,
                  ],
                ),
              ),
              12.verticalSpace,
            ],
          ),
        ),
        routeList,
      ],
    );
    final overlay = Column(
      children: [
        Expanded(child: customScrollView),
        watchRoutes.when(
          data: (data) => const ListRoutesFooterView(),
          error: (error, stackTrace) => const SizedBox.shrink(),
          loading: () => const Skeletonizer(
            child: ListRoutesFooterView(),
          ),
        ),
      ],
    );
    return ColoredBox(
      color: Colors.white,
      child: HeaderBackdrop(
        child: overlay,
      ),
    );
  }
}

class _RoutesDataView extends HookConsumerWidget {
  const _RoutesDataView(
    this.data, {
    this.isForSkeletonizer = false,
  });

  final List<RouteEntity> data;
  final bool isForSkeletonizer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = _ListRoutesViewModel(context, ref);
    final filteredRoutes = isForSkeletonizer ? data : vm.calcFilteredRoutes();
    return SliverList.separated(
      itemCount: filteredRoutes.length,
      itemBuilder: (context, index) {
        final route = filteredRoutes[index];
        final icon = Icon(
          switch (route.mode) {
            RouteMode.minibus => Icons.directions_bus,
            RouteMode.chinchi => Icons.electric_rickshaw,
            RouteMode.acBus => Icons.directions_bus_outlined,
          },
          color: switch (route.mode) {
            RouteMode.minibus => Colors.purple,
            RouteMode.chinchi => Colors.blue.shade600,
            RouteMode.acBus => Colors.red,
          },
        );
        final isSelected = ref.watch(
          _selectedRoutesProvider.select(
            (selection) => selection.contains(route),
          ),
        );
        return Material(
          color: Colors.white,
          child: CheckboxListTile(
            value: isSelected,
            title: Row(
              children: [
                18.horizontalSpace,
                icon,
                24.horizontalSpace,
                Expanded(child: Text(route.name)),
              ],
            ),
            onChanged: (isChecked) => ref
                .read(
                  _selectedRoutesProvider.notifier,
                )
                .state = ref
                .read(
                  _selectedRoutesProvider,
                )
                .toggle(route)
                .toSet(),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 0),
    );
  }
}

class ListRoutesFooterView extends HookConsumerWidget {
  const ListRoutesFooterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = _ListRoutesViewModel(context, ref);
    final filterDialog = SizedBox(
      width: 300,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Wrap(
            spacing: 12,
            children: RouteMode.values
                .map(
                  (mode) => FilterChip(
                    label: Text(mode.name),
                    selected: ref.watch(
                      _filterProvider.select(
                        (filter) => filter.contains(mode),
                      ),
                    ),
                    onSelected: (value) => vm.onModeFiltered(value, mode),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
    final filterBtn = AlignedDialogPusherBox(
      followerAnchor: Alignment.bottomRight,
      targetAnchor: Alignment.topRight,
      dialogBuilder: (context) => filterDialog,
      childBuilder: ({required dismiss, required push}) => ElevatedButton.icon(
        onPressed: push,
        label: const Text("Filter"),
        icon: const Icon(Icons.filter_alt),
        style: MyTheme.primaryOutlinedButtonStyle,
      ),
    );
    final searchNode = useFocusNode();
    final isFocused = useIsFocused(searchNode);
    // final searchCtl = useTextEditingController();
    // final searchBar = SizedBox(
    //   height: 48,
    //   child: TextField(
    //     focusNode: searchNode,
    //     controller: searchCtl,
    //     onChanged: (searchTerm) => ref
    //         .read(
    //           _searchTermProvider.notifier,
    //         )
    //         .state = searchTerm,
    //     maxLines: 1,
    //     textAlignVertical: TextAlignVertical.center,
    //     decoration: InputDecoration(
    //       prefixIcon: const Icon(
    //         Icons.search,
    //       ),
    //       hintText: 'Search...',
    //       suffixIcon: isFocused
    //           ? IconButton(
    //               onPressed: () {
    //                 searchCtl.clear();
    //                 ref.read(_searchTermProvider.notifier).state = '';
    //                 searchNode.unfocus();
    //               },
    //               icon: ValueListenableBuilder(
    //                 valueListenable: searchCtl,
    //                 builder: (context, value, child) => Icon(
    //                   value.text.isEmpty
    //                       ? Icons.keyboard_arrow_down
    //                       : Icons.clear,
    //                 ),
    //               ),
    //             )
    //           : null,
    //     ),
    //   ),
    // );
    final searchRowColor = Color.lerp(
      MyTheme.primaryColor.shade50,
      Colors.white,
      0.8,
    );
    final drawerBtn = SlideTransitionHelper(
      axis: Axis.horizontal,
      axisAlignment: 1,
      doShow: !isFocused,
      child: Row(
        children: [
          const DrawerButton(),
          12.horizontalSpace,
        ],
      ),
    );
    final searchRow = Container(
      color: searchRowColor,
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
      ),
      child: Row(
        children: [
          drawerBtn,
          ElevatedButton.icon(
            onPressed: () async {
              final allRoutes = ref.read(routesUseCaseProvider).requireValue;
              final filter = ref.read(_filterProvider);
              final filteredRoutes = allRoutes.where(
                (e) => filter.contains(e.mode),
              );
              ref.read(_selectedRoutesProvider.notifier).state =
                  filteredRoutes.toSet();
            },
            label: const Text("Select all"),
            icon: const Icon(Icons.select_all),
            style: MyTheme.primaryOutlinedButtonStyle,
          ),
          SlideTransitionHelper(
            doShow: !isFocused,
            axis: Axis.horizontal,
            axisAlignment: -1,
            child: Row(
              children: [
                12.horizontalSpace,
                filterBtn,
              ],
            ),
          ),
        ],
      ),
    );
    final isSelectionPopulated = ref.watch(
      _selectedRoutesProvider.select(
        (selection) => selection.isNotEmpty,
      ),
    );
    final viewOnMapBtn = ElevatedButton.icon(
      onPressed: () => context.go(
        '/route/display',
        extra: ref.read(_selectedRoutesProvider),
      ),
      style: MyTheme.primaryElevatedButtonStyle.copyWith(
        textStyle: const WidgetStatePropertyAll(null),
        iconSize: const WidgetStatePropertyAll(null),
      ),
      label: const Text('View On Map'),
      icon: const Icon(Icons.map),
    );
    final clearSelectionBtn = OutlinedButton.icon(
      onPressed: () => ref.read(_selectedRoutesProvider.notifier).state = {},
      style: MyTheme.primaryOutlinedButtonStyle,
      label: const Text(
        'Clear selection',
      ),
      icon: const Icon(Icons.deselect),
    );
    final deleteBtn = OutlinedButton.icon(
      onPressed: () => context.loaderWithErrorDialog(
        () async {
          final selection = ref.read(
            _selectedRoutesProvider,
          );
          final areAllHardcoded = selection.every((e) => e.isHardcoded);
          if (areAllHardcoded) {
            return context.simpleDialog(
              title: 'Only hardcoded routes selected',
              content: 'You can\'t delete hardcoded routes',
            );
          }
          final deletableSelection = selection.where(
            (e) => !e.isHardcoded,
          );
          final undeletableSelection = selection.where(
            (e) => e.isHardcoded,
          );
          final deletableClause =
              'Are you sure you want to delete the following routes?\n${deletableSelection.map(
                    (e) => ' ・ ${e.name}',
                  ).join('\n')}\n';
          final undeletableClause = undeletableSelection.isEmpty
              ? null
              : 'The following hardcoded routes cannot and will not be deleted:\n${undeletableSelection.map(
                    (e) => ' ・ ${e.name}',
                  ).join('\n')}\n';
          final confirmationDialogResult = await context.simpleDialog(
            title: 'Confirm deletion',
            content: undeletableClause == null
                ? deletableClause
                : '$deletableClause\n$undeletableClause',
            alternativeAction: ElevatedButton(
              onPressed: () => context.pop(true),
              child: const Text("Yes I'm sure"),
            ),
          );
          if (confirmationDialogResult != true) return;
          for (final route in deletableSelection) {
            await ref
                .read(routesUseCaseProvider.notifier)
                .deleteRoute(route.name);
          }
          ref.read(_selectedRoutesProvider.notifier).state =
              undeletableSelection.toSet();
        },
      ),
      style: MyTheme.primaryOutlinedButtonStyle.copyWith(
        foregroundColor: const WidgetStatePropertyAll(
          Colors.red,
        ),
        iconColor: const WidgetStatePropertyAll(
          Colors.red,
        ),
      ),
      label: Text(
        'Delete route${ref.watch(
          _selectedRoutesProvider.select(
            (list) => list.length < 2,
          ),
        ) ? '' : 's'}',
      ),
      icon: const Icon(Icons.delete),
    );
    final selectedRowColor = Color.lerp(
      MyTheme.primaryColor.shade50,
      Colors.white,
      0.65,
    );
    final copyBtn = ElevatedButton.icon(
      onPressed: vm.onCopy,
      label: const Text("Copy as Code"),
      icon: const Icon(Icons.copy),
    );
    final selectedRow = Container(
      color: selectedRowColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 12,
      ),
      child: SlideTransitionHelper(
        doShow: isSelectionPopulated && !isFocused,
        axis: Axis.vertical,
        axisAlignment: -1,
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            viewOnMapBtn,
            clearSelectionBtn,
            copyBtn,
            deleteBtn,
          ],
        ),
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        searchRow,
        selectedRow,
        ColoredBox(
          color: selectedRowColor!,
          child: SizedBox(
            height: MediaQuery.of(context).padding.bottom,
            width: double.infinity,
          ),
        ),
      ],
    );
  }
}
