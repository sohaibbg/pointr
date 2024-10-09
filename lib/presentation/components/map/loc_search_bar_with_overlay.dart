import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../config/my_theme.dart';
import '../../../domain/entities/searchable_place.dart';
import '../../../domain/use_cases/recents_use_case.dart';
import '../../../domain/use_cases/suggestions_use_case.dart';
import '../space.dart';
import 'search_suggestions.dart';

class LocSearchBarWithOverlay extends HookConsumerWidget {
  final Widget? prefixIconWhenNotFocused;
  final void Function(AddressEntity locatedPlace) onPlaceSelected;
  final bool showSuggestionChips;

  const LocSearchBarWithOverlay({
    super.key,
    this.prefixIconWhenNotFocused,
    required this.onPlaceSelected,
    this.showSuggestionChips = true,
  });

  static final searchFocusNode = FocusNode();
  static final searchController = TextEditingController();

  static final usePlacesSearchGlobalKey = GlobalKey(
    debugLabel: 'usePlacesSearchGlobalKey',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animCtl = useAnimationController(
      initialValue: searchFocusNode.hasFocus ? 1 : 0,
      duration: kThemeAnimationDuration,
    );
    useEffect(
      () {
        if (searchFocusNode.hasFocus) animCtl.value = 1;
        void toggle() async {
          if (searchFocusNode.hasFocus) {
            animCtl.forward();
          } else {
            animCtl.reverse();
          }
        }

        searchFocusNode.addListener(toggle);
        return () => searchFocusNode.removeListener(toggle);
      },
    );
    final screenWidth = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: animCtl,
      builder: (context, child) {
        final hasFocus = searchFocusNode.hasFocus;
        final value = animCtl.value;
        final modalBarrier = ModalBarrier(
          onDismiss: () {
            searchFocusNode.unfocus();
            searchController.clear();
          },
          color: Color.lerp(
            Colors.transparent,
            Theme.of(context).dialogTheme.barrierColor ?? Colors.black54,
            value,
          ),
        );
        final br = BorderRadius.circular((1 - value) * 100);
        final inputDecoration = InputDecoration(
          border: OutlineInputBorder(
            borderRadius: br,
            borderSide: BorderSide.none,
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: 'Search',
          prefixIcon: const Padding(
            padding: EdgeInsetsDirectional.only(
              start: 24,
              end: 16,
            ),
            child: Icon(Icons.search),
          ),
          suffixIcon: hasFocus
              ? ValueListenableBuilder(
                  valueListenable: searchController,
                  builder: (context, value, child) => value.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: searchController.clear,
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                          ),
                          onPressed: searchFocusNode.unfocus,
                        ),
                )
              : null,
          prefixIconConstraints: const BoxConstraints(),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 24,
          ),
        );
        final textField = TextField(
          key: usePlacesSearchGlobalKey,
          focusNode: searchFocusNode,
          controller: searchController,
          textAlignVertical: TextAlignVertical.center,
          decoration: inputDecoration,
        );
        final textFieldDecorated = Hero(
          tag: 'searchbar',
          child: Material(
            elevation: 2,
            borderRadius: br,
            animationDuration: Duration.zero,
            child: textField,
          ),
        );
        final searchSuggestions = SizedBox(
          height: 250,
          child: ValueListenableBuilder(
            valueListenable: searchController,
            builder: (context, value, child) => SearchSuggestions(
              searchTerm: value.text,
              onSelected: (place) {
                searchController.clear();
                searchFocusNode.unfocus();
                final entity = AddressEntity(
                  coordinates: place.coordinates,
                  address: place.name,
                );
                onPlaceSelected(entity);
                addToHistory(
                  RecentEntity(
                    coordinates: place.coordinates,
                    name: place.name,
                  ),
                  ref,
                );
              },
            ),
          ),
        );
        final searchSuggestionsAnimated = Stack(
          alignment: Alignment.bottomCenter,
          children: [
            modalBarrier,
            FractionalTranslation(
              translation: Offset(
                0,
                (1 - value) * -1,
              ),
              child: searchSuggestions,
            ),
          ],
        );
        final chipsList = ref.watch(recentsUseCaseProvider).when(
              data: (data) => ListView.separated(
                hitTestBehavior: HitTestBehavior.deferToChild,
                padding: const EdgeInsetsDirectional.only(
                  // padding, icon, padding, "Search..."
                  start: 96,
                  top: 3,
                  bottom: 8,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                separatorBuilder: (context, index) => 4.horizontalSpace,
                itemBuilder: (context, index) {
                  final e = data[index];
                  return ActionChip(
                    label: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(
                        maxWidth: 76,
                        minWidth: 56,
                        minHeight: 96,
                      ),
                      child: Text(
                        e.name,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 11),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: MyTheme.primaryColor.shade700,
                    ),
                    onPressed: () => onPlaceSelected(e),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      // vertical: 3,
                    ),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                    color: WidgetStatePropertyAll(
                      Color.lerp(
                        MyTheme.primaryColor.shade50,
                        Colors.white,
                        0.4,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.transparent),
                    ),
                  );
                },
              ),
              error: (_, __) => const SizedBox.shrink(),
              loading: () => Skeletonizer(
                child: ListView(
                  hitTestBehavior: HitTestBehavior.deferToChild,
                  padding: const EdgeInsets.only(bottom: 3),
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // padding, icon, padding, "Search..."
                    96.horizontalSpace,
                    ...List.generate(
                      7,
                      (index) => Padding(
                        padding: const EdgeInsetsDirectional.only(end: 6),
                        child: ActionChip(
                          label: const Text('sersesf'),
                          onPressed: () {},
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 12,
                          ),
                          labelPadding:
                              const EdgeInsets.symmetric(horizontal: 2),
                          color: WidgetStatePropertyAll(
                            Color.lerp(
                              MyTheme.primaryColor.shade50,
                              Colors.white,
                              0.75,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: const BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
        final textFieldPortaled = PortalTarget(
          portalFollower: searchSuggestionsAnimated,
          visible: value != 0.0,
          anchor: const Aligned(
            follower: Alignment.bottomCenter,
            target: Alignment.topCenter,
          ),
          child: textFieldDecorated,
        );
        final textFieldKeyboardPopChecked = KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) => PopScope(
            canPop: !searchFocusNode.hasFocus && !isKeyboardVisible,
            onPopInvokedWithResult: (didPop, result) {
              if (searchFocusNode.hasFocus) searchFocusNode.unfocus();
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: isKeyboardVisible ? 0 : 4),
              child: textFieldPortaled,
            ),
          ),
        );
        final textFieldWithPadding = Padding(
          padding: EdgeInsetsDirectional.lerp(
            EdgeInsetsDirectional.zero,
            const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
            1 - value,
          )!,
          child: textFieldKeyboardPopChecked,
        );
        return ColoredBox(
          color: modalBarrier.color!,
          child: Stack(
            children: [
              textFieldWithPadding,
              Positioned.fill(
                // search padding, prefix padding, prefix icon, prefix padding
                left: lerpDouble(
                  24 + 24 + 24 + 16,
                  screenWidth,
                  value,
                ),
                child: chipsList,
              ),
            ],
          ),
        );
      },
    );
  }
}
