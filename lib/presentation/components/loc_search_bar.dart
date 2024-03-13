import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/address_entity.dart';
import 'search_suggestions.dart';

class LocSearchBar extends HookConsumerWidget {
  final bool autofocus;
  final Widget? prefixIconWhenNotFocused;
  final FocusNode focusNode;
  final void Function(AddressEntity locatedPlace) onPlaceSelected;

  const LocSearchBar({
    super.key,
    this.autofocus = false,
    this.prefixIconWhenNotFocused,
    required this.focusNode,
    required this.onPlaceSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textEditingController = useTextEditingController();
    final searchBarFocusNode = focusNode;
    final isFocused = useState(searchBarFocusNode.hasFocus);
    final opc = OverlayPortalController();
    final animCtl = useAnimationController(
      duration: kThemeAnimationDuration,
      keys: [searchBarFocusNode],
    );
    useEffect(
      () {
        void listener() async {
          isFocused.value = searchBarFocusNode.hasFocus;
          opc.toggle();
          if (isFocused.value) animCtl.forward();
        }

        searchBarFocusNode.addListener(listener);
        return () => searchBarFocusNode.removeListener(
              listener,
            );
      },
      [searchBarFocusNode, opc],
    );

    Future<void> unfocus() async {
      textEditingController.clear();
      await animCtl.reverse();
      searchBarFocusNode.unfocus();
    }

    final suffixIcon = isFocused.value
        ? ValueListenableBuilder(
            valueListenable: textEditingController,
            builder: (context, value, child) => value.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: textEditingController.clear,
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                    ),
                    onPressed: unfocus,
                  ),
          )
        : null;
    final prefixIcon = isFocused.value
        ? const Icon(
            Icons.search,
          )
        : prefixIconWhenNotFocused ?? const Icon(Icons.search);
    final textField = AnimatedBuilder(
      animation: animCtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 12,
        ),
        child: TextField(
          autofocus: autofocus,
          focusNode: searchBarFocusNode,
          controller: textEditingController,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search Location',
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ),
      builder: (context, child) {
        final animVal = 1 - animCtl.value;
        final br = BorderRadius.circular(
          animVal * 100,
        );
        return InkWell(
          borderRadius: br,
          onTap: isFocused.value ? null : searchBarFocusNode.requestFocus,
          child: Padding(
            padding: EdgeInsets.all(animVal * 24),
            child: Material(
              elevation: 3,
              color: Theme.of(context).inputDecorationTheme.fillColor,
              borderRadius: br,
              child: child,
            ),
          ),
        );
      },
    );
    final searchSuggestions = FractionallySizedBox(
      alignment: Alignment.bottomCenter,
      heightFactor: 0.5,
      widthFactor: 0.9,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: ValueListenableBuilder(
          valueListenable: textEditingController,
          builder: (context, value, child) => SearchSuggestions(
            searchTerm: value.text,
            onSelected: (place) async {
              await unfocus();
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
    final searchSuggestionsAnimated = AnimatedBuilder(
      animation: animCtl,
      child: searchSuggestions,
      builder: (context, child) => FractionalTranslation(
        translation: Offset(0, animCtl.value - 1),
        child: child,
      ),
    );
    final unfocusShade = GestureDetector(
      onTap: unfocus,
      onDoubleTap: unfocus,
      onSecondaryTap: unfocus,
      onSecondaryLongPress: unfocus,
      onVerticalDragStart: (_) => unfocus(),
      onHorizontalDragStart: (_) => unfocus(),
      onSecondaryLongPressStart: (_) => unfocus(),
      onLongPressStart: (_) => unfocus(),
      onForcePressStart: (_) => unfocus(),
      onTertiaryLongPressStart: (_) => unfocus(),
      child: AnimatedBuilder(
        animation: animCtl,
        builder: (context, child) => ColoredBox(
          color: Colors.black.withOpacity(animCtl.value * 0.6),
          child: const SizedBox.expand(),
        ),
      ),
    );
    final overlay = Stack(
      alignment: Alignment.bottomCenter,
      fit: StackFit.expand,
      children: [
        unfocusShade,
        searchSuggestionsAnimated,
      ],
    );
    final ll = LayerLink();
    return OverlayPortal(
      controller: opc,
      overlayChildBuilder: (context) => CompositedTransformFollower(
        link: ll,
        followerAnchor: Alignment.bottomLeft,
        child: overlay,
      ),
      child: CompositedTransformTarget(
        link: ll,
        child: textField,
      ),
    );
  }
}
