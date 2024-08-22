import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/address_entity.dart';
import 'search_suggestions.dart';

class LocSearchBarWithOverlay extends HookConsumerWidget {
  final Widget? prefixIconWhenNotFocused;
  final void Function(AddressEntity locatedPlace) onPlaceSelected;

  const LocSearchBarWithOverlay({
    super.key,
    this.prefixIconWhenNotFocused,
    required this.onPlaceSelected,
  });

  static final searchFocusNode = FocusNode();
  static final searchController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opc = OverlayPortalController();
    if (searchFocusNode.hasFocus) opc.show();
    final animCtl = useAnimationController(
      initialValue: searchFocusNode.hasFocus ? 1 : 0,
      duration: kThemeAnimationDuration,
    );
    useEffect(
      () {
        void toggle() {
          if (searchFocusNode.hasFocus) {
            opc.show();
            animCtl.forward();
          } else {
            Future.delayed(
              kThemeAnimationDuration,
              opc.hide,
            );
            animCtl.reverse();
          }
        }

        searchFocusNode.addListener(toggle);
        return () => searchFocusNode.removeListener(toggle);
      },
      [searchFocusNode, opc],
    );
    return AnimatedBuilder(
      animation: animCtl,
      builder: (context, child) {
        final hasFocus = searchFocusNode.hasFocus;
        final value = animCtl.value;
        final modalBarrier = ModalBarrier(
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
            child: Icon(
              Icons.search,
            ),
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
            vertical: 20,
            horizontal: 24,
          ),
        );
        final textField = TextField(
          focusNode: searchFocusNode,
          controller: searchController,
          textAlignVertical: TextAlignVertical.center,
          decoration: inputDecoration,
        );
        final decoratedTextField = Hero(
          tag: 'searchbar',
          child: Material(
            elevation: 2,
            borderRadius: br,
            animationDuration: Duration.zero,
            child: textField,
          ),
        );
        final searchSuggestions = FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          widthFactor: 0.9,
          heightFactor: 0.5,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18),
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
                },
              ),
            ),
          ),
        );
        final searchSuggestionsAnimated = FractionalTranslation(
          translation: Offset(
            0,
            (1 - value) * -1,
          ),
          child: searchSuggestions,
        );
        final ll = LayerLink();
        final textFieldConnectedToOverlayPortal = OverlayPortal(
          controller: opc,
          overlayChildBuilder: (context) => CompositedTransformFollower(
            link: ll,
            targetAnchor: Alignment.topCenter,
            followerAnchor: Alignment.bottomCenter,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                modalBarrier,
                searchSuggestionsAnimated,
              ],
            ),
          ),
          child: CompositedTransformTarget(
            link: ll,
            child: decoratedTextField,
          ),
        );
        final textFieldWithKeyboardListenerForPoppingAndOverlayPortal =
            KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) => PopScope(
            canPop: !searchFocusNode.hasFocus && !isKeyboardVisible,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              if (searchFocusNode.hasFocus) searchFocusNode.unfocus();
            },
            child: textFieldConnectedToOverlayPortal,
          ),
        );
        return ColoredBox(
          color: modalBarrier.color!,
          child: Padding(
            padding: EdgeInsetsDirectional.lerp(
              EdgeInsetsDirectional.zero,
              const EdgeInsetsDirectional.fromSTEB(24, 24, 24, 0),
              1 - value,
            )!,
            child: textFieldWithKeyboardListenerForPoppingAndOverlayPortal,
          ),
        );
      },
    );
  }
}
