import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../config/my_theme.dart';
import '../../../../domain/entities/address_entity.dart';
import '../../../../domain/entities/coordinates_entity.dart';
import '../../../../domain/entities/favorite_entity.dart';
import '../../../../domain/entities/named_address_entity.dart';
import '../../../../domain/repositories/i_location_repo.dart';
import '../../../../domain/use_cases/favorites_use_case.dart';
import '../../../../domain/use_cases/location_use_case.dart';
import '../../../../domain/use_cases/places_use_case.dart';
import '../../../components/loc_search_bar_with_overlay.dart';
import '../../../components/space.dart';

part '_favorites_view.dart';
part '_nearby_suggestions_view.dart';

class GoScreen extends HookConsumerWidget {
  const GoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        void listener() {
          if (LocSearchBarWithOverlay.searchFocusNode.hasFocus) {
            context.go(
              '/route/advisor',
              extra: {'focusSearch': true},
            );
          }
        }

        LocSearchBarWithOverlay.searchFocusNode.addListener(listener);
        return () =>
            LocSearchBarWithOverlay.searchFocusNode.removeListener(listener);
      },
    );
    final stationaryDecoration = InputDecoration(
      fillColor: MyTheme.primaryColor,
      filled: true,
      prefixIconConstraints: const BoxConstraints(),
      prefixIcon: const Padding(
        padding: EdgeInsetsDirectional.only(
          start: 28,
          end: 16,
        ),
        child: Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 24,
      ),
      suffixIcon: GestureDetector(
        onTap: () {
          LocSearchBarWithOverlay.searchFocusNode.unfocus();
          context.go(
            '/route/advisor',
            extra: {'focusSearch': false},
          );
        },
        child: const Padding(
          padding: EdgeInsetsDirectional.only(
            start: 16,
            end: 32,
            top: 24,
            bottom: 24,
          ),
          child: Icon(
            Icons.my_location,
            color: Colors.white,
          ),
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: Colors.white),
      hintText: 'Search',
    );
    final searchField = TextField(
      focusNode: LocSearchBarWithOverlay.searchFocusNode,
      controller: LocSearchBarWithOverlay.searchController,
      decoration: stationaryDecoration,
    );
    final searchButton = Hero(
      tag: 'searchbar',
      flightShuttleBuilder: (
        flightContext,
        animation,
        flightDirection,
        fromHeroContext,
        toHeroContext,
      ) {
        final isSearchFocused =
            LocSearchBarWithOverlay.searchFocusNode.hasFocus;
        final inputDecorationTheme = Theme.of(
          context,
        ).inputDecorationTheme;
        final greyColor = inputDecorationTheme.iconColor ??
            Theme.of(context).textTheme.bodySmall!.color;
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final foregroundColor = Color.lerp(
              Colors.white,
              greyColor,
              animation.value,
            );
            final animatingDecoration = InputDecoration(
              fillColor: Color.lerp(
                MyTheme.primaryColor,
                Colors.white,
                animation.value,
              ),
              filled: true,
              prefixIcon: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: lerpDouble(28, 24, animation.value)!,
                  end: 16,
                ),
                child: Icon(
                  Icons.search,
                  color: foregroundColor,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 24,
              ),
              prefixIconConstraints: const BoxConstraints(),
              suffixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 16,
                  end: 32,
                  top: 24,
                  bottom: 24,
                ),
                child: Icon(
                  isSearchFocused
                      ? animation.value < 0.5
                          ? Icons.my_location
                          : Icons.keyboard_arrow_down
                      : Icons.my_location,
                  color: isSearchFocused
                      ? foregroundColor
                      : animation.value < 0.5
                          ? Color.lerp(
                              Colors.white,
                              Color.lerp(
                                Colors.white,
                                greyColor,
                                0.5,
                              ),
                              animation.value * 2,
                            )
                          : Color.lerp(
                              Color.lerp(
                                Colors.white,
                                greyColor,
                                0.5,
                              ),
                              Colors.white,
                              animation.value * 2,
                            ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  lerpDouble(
                    100,
                    isSearchFocused ? 0 : 100,
                    animation.value,
                  )!,
                ),
                borderSide: BorderSide.none,
              ),
              hintStyle: TextStyle(color: foregroundColor),
              hintText: 'Search',
            );
            final textField = TextField(
              controller: LocSearchBarWithOverlay.searchController,
              focusNode: LocSearchBarWithOverlay.searchFocusNode,
              decoration: animatingDecoration,
            );
            return Material(
              color: Color.lerp(
                MyTheme.primaryColor,
                Colors.white,
                animation.value,
              ),
              elevation: lerpDouble(
                2,
                0,
                animation.value,
              )!,
              borderRadius: BorderRadius.circular(
                lerpDouble(
                  100,
                  isSearchFocused ? 0 : 100,
                  animation.value,
                )!,
              ),
              child: textField,
            );
          },
        );
      },
      child: searchField,
    );
    final title = Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 30,
        bottom: 24,
      ),
      child: Text(
        "Where are you currently?",
        style: Theme.of(context)
            .textTheme
            .displayMedium
            ?.copyWith(color: Colors.grey.shade800),
      ),
    );
    final scrollController = useScrollController();
    final foreground = CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              280.verticalSpace,
              title,
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: searchButton,
              ),
              const FavoritesView(),
            ],
          ),
        ),
        const NearbySuggestionsView(),
        SliverToBoxAdapter(child: 150.verticalSpace),
      ],
    );
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/geometric pattern.png',
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
          foreground,
        ],
      ),
    );
  }
}
