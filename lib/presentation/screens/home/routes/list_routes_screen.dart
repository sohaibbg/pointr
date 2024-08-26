import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../config/my_theme.dart';
import '../../../../domain/entities/route_entity.dart';
import '../../../../domain/use_cases/routes_use_case.dart';
import '../../../../infrastructure/services/packages/hooks.dart';
import '../../../../infrastructure/services/packages/iterable.dart';
import '../../../../infrastructure/services/packages/view_model.dart';
import '../../../components/aligned_dialog_pusher_box.dart';
import '../../../components/slide_transition_helper.dart';
import '../../../components/space.dart';

part 'list_routes_view_model.dart';

class ListRoutesScreen extends HookConsumerWidget {
  const ListRoutesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final createRoutebtn = ElevatedButton.icon(
      onPressed: () {},
      label: const Text("Create new Route"),
      icon: const Icon(Icons.add),
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
              250.verticalSpace,
              title,
              24.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: createRoutebtn,
              ),
              12.verticalSpace,
            ],
          ),
        ),
        routeList,
      ],
    );
    return Column(
      children: [
        Expanded(child: customScrollView),
        watchRoutes.when(
          data: (data) => const _ListRoutesFooterView(),
          error: (error, stackTrace) => const SizedBox.shrink(),
          loading: () => const Skeletonizer(
            child: _ListRoutesFooterView(),
          ),
        ),
      ],
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
            RouteMode.minibus ||
            RouteMode.redBus ||
            RouteMode.pinkBus =>
              Icons.directions_bus,
            RouteMode.chinchi => Icons.electric_rickshaw,
            RouteMode.greenLine => Icons.directions_bus_outlined,
          },
          color: switch (route.mode) {
            RouteMode.minibus => Colors.purple,
            RouteMode.chinchi => Colors.blue.shade600,
            RouteMode.redBus => Colors.red,
            RouteMode.pinkBus => Colors.pink,
            RouteMode.greenLine => Colors.green,
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

class _ListRoutesFooterView extends HookConsumerWidget {
  const _ListRoutesFooterView();

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
    final searchCtl = useTextEditingController();
    final searchBar = SizedBox(
      height: 48,
      child: TextField(
        focusNode: searchNode,
        controller: searchCtl,
        onChanged: (searchTerm) => ref
            .read(
              _searchTermProvider.notifier,
            )
            .state = searchTerm,
        maxLines: 1,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.search,
          ),
          hintText: 'Search...',
          suffixIcon: isFocused
              ? IconButton(
                  onPressed: () {
                    searchCtl.clear();
                    ref.read(_searchTermProvider.notifier).state = '';
                    searchNode.unfocus();
                  },
                  icon: ValueListenableBuilder(
                    valueListenable: searchCtl,
                    builder: (context, value, child) => Icon(
                      value.text.isEmpty
                          ? Icons.keyboard_arrow_down
                          : Icons.clear,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
    final searchAndFilterRow = Container(
      color: Color.lerp(
        MyTheme.primaryColor.shade50,
        Colors.white,
        0.8,
      ),
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: searchBar,
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
        '/display-routes',
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
    final selectionAndViewOnMapRow = Container(
      color: Color.lerp(
        MyTheme.primaryColor.shade50,
        Colors.white,
        0.65,
      ),
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
          ],
        ),
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        searchAndFilterRow,
        selectionAndViewOnMapRow,
      ],
    );
  }
}
