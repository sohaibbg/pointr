import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointr/classes/star.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'package:pointr/classes/located_google_place.dart';
import 'package:pointr/my_theme.dart';
import 'package:pointr/providers/from_provider.dart';
import 'package:pointr/providers/search_suggestion_provider.dart';
import 'package:pointr/providers/star_provider.dart';
import 'package:pointr/providers/to_provider.dart';
import 'package:pointr/widgets/map_results.dart';

import 'horizontal_chip_scroller.dart';

class ToFromSetterAppBar extends StatelessWidget {
  const ToFromSetterAppBar({super.key, required this.onSelected});
  final Function(LatLng latLng) onSelected;
  static final TextEditingController fromController = TextEditingController();
  static final TextEditingController toController = TextEditingController();
  static final FocusNode fromFocusNode = FocusNode();
  static final FocusNode toFocusNode = FocusNode();
  static final LayerLink _layerLink = LayerLink();
  @override
  Widget build(BuildContext context) {
    OverlayEntry? overlay;
    OverlayEntry overlaySuggestions() => OverlayEntry(
          builder: (context) => CompositedTransformFollower(
            link: _layerLink,
            targetAnchor: Alignment.bottomLeft,
            followerAnchor: Alignment.topLeft,
            showWhenUnlinked: false,
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Material(
                    elevation: 1.0,
                    child: Column(
                      children: [
                        Consumer<StarProvider>(
                          builder: (context, starProvider, child) =>
                              HorizontalChipScroller(
                            height: starProvider.all.isEmpty ? 0 : 5.5.h + 32,
                            items: starProvider.all,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 20),
                            onSelected: (Star star) {
                              overlay!.remove();
                              overlay = null;
                              if (fromFocusNode.hasFocus && context.mounted) {
                                fromController.clear();
                                Provider.of<FromProvider>(context,
                                        listen: false)
                                    .select(
                                  latLng: star.latLng,
                                  name: star.title,
                                  context: context,
                                );
                              } else if (toFocusNode.hasFocus) {
                                toController.clear();
                                Provider.of<ToProvider>(context, listen: false)
                                    .select(
                                  latLng: star.latLng,
                                  name: star.title,
                                  context: context,
                                );
                              }
                              onSelected(star.latLng);
                            },
                          ),
                        ),
                        Expanded(
                          child: Consumer<SearchSuggestionProvider>(
                            builder:
                                (context, searchSuggestionProvider, child) =>
                                    PlaceListview(
                              items: searchSuggestionProvider.suggestions,
                              onSelected: (place) async {
                                late LatLng latLng;
                                if (place is! LocatedGooglePlace) {
                                  latLng = await place.getLatLng();
                                } else {
                                  latLng = place.latLng;
                                }
                                overlay!.remove();
                                overlay = null;
                                FromProvider fromProvider;
                                ToProvider toProvider;
                                if (context.mounted) {
                                  fromProvider = Provider.of<FromProvider>(
                                      context,
                                      listen: false);
                                  toProvider = Provider.of<ToProvider>(context,
                                      listen: false);
                                } else {
                                  throw Exception('context not mounted');
                                }
                                if (fromFocusNode.hasFocus && context.mounted) {
                                  fromController.clear();
                                  fromFocusNode.unfocus();
                                  if (toProvider.selected == null) {
                                    toFocusNode.requestFocus();
                                  }
                                  fromProvider.select(
                                    latLng: latLng,
                                    name: place.title,
                                    context: context,
                                  );
                                } else if (toFocusNode.hasFocus) {
                                  toController.clear();
                                  toFocusNode.unfocus();
                                  if (fromProvider.selected == null) {
                                    fromFocusNode.requestFocus();
                                  }
                                  Provider.of<ToProvider>(context,
                                          listen: false)
                                      .select(
                                    latLng: latLng,
                                    name: place.title,
                                    context: context,
                                  );
                                }
                                onSelected(latLng);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    child: const SizedBox.expand(
                      child: Opacity(
                        opacity: 0.6,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.black),
                        ),
                      ),
                    ),
                    onTap: () {
                      if (overlay?.mounted ?? false) overlay!.remove();
                      overlay = null;
                      Provider.of<SearchSuggestionProvider>(context,
                              listen: false)
                          .clear();
                      if (fromFocusNode.hasFocus) {
                        fromController.clear();
                        fromFocusNode.unfocus();
                      }
                      if (toFocusNode.hasFocus) {
                        toController.clear();
                        toFocusNode.unfocus();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );

    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).viewPadding.top + 7,
          left: 15,
        ),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 3,
              offset: Offset(1, 1),
            )
          ],
          color: MyTheme.colorPrimary,
          image: DecorationImage(
            alignment: Alignment.topCenter,
            image: AssetImage(
              'assets/images/geometric pattern.png',
            ),
            fit: BoxFit.fitWidth,
            colorFilter: ColorFilter.mode(
              MyTheme.colorPrimaryLight,
              BlendMode.srcATop,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // back button
            IconButton(
              onPressed: Navigator.of(context).pop,
              color: MyTheme.colorSecondaryLight,
              icon: const Icon(Icons.arrow_back),
            ),
            // text fields
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // from
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Consumer<FromProvider>(
                      builder: (context, fromProvider, child) => TextField(
                        controller: fromController,
                        autofocus: true,
                        onChanged: (term) async {
                          if (term.trim().isEmpty) return;
                          var searchProvider =
                              Provider.of<SearchSuggestionProvider>(
                            context,
                            listen: false,
                          );
                          await searchProvider.fetchSuggestions(
                            context,
                            term,
                          );
                        },
                        focusNode: fromFocusNode
                          ..addListener(() {
                            bool isOverlayMounted = overlay?.mounted ?? false;
                            if (fromFocusNode.hasFocus) {
                              fromProvider.clear();
                              if (!isOverlayMounted) {
                                overlay = overlaySuggestions();
                                Overlay.of(context).insert(overlay!);
                              }
                            } else if (isOverlayMounted) {
                              fromController.clear();
                              Provider.of<SearchSuggestionProvider>(
                                context,
                                listen: false,
                              ).clear();
                              overlay!.remove();
                              overlay = null;
                            }
                          }),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          fillColor: fromFocusNode.hasFocus
                              ? Colors.white
                              : fromProvider.selected == null
                                  ? MyTheme.colorSecondaryLight
                                  : MyTheme.colorPrimaryLight,
                          filled: true,
                          focusColor: Colors.red,
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                            borderSide: BorderSide(
                              color: MyTheme.colorSecondary,
                              width: 5,
                            ),
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(99),
                            ),
                          ),
                          hintText: fromProvider.title,
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Padding(
                            padding:
                                EdgeInsets.only(top: 16, left: 20, right: 15),
                            child: Text(
                              'FROM',
                              textScaleFactor: 0.6,
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // to
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Consumer<ToProvider>(
                      builder: (context, toProvider, child) => TextField(
                        controller: toController,
                        onChanged: (term) {
                          if (term.trim().isEmpty) return;
                          var searchProvider =
                              Provider.of<SearchSuggestionProvider>(
                            context,
                            listen: false,
                          );
                          searchProvider.fetchSuggestions(context, term);
                        },
                        focusNode: toFocusNode
                          ..addListener(() {
                            bool isOverlayMounted = overlay?.mounted ?? false;
                            if (toFocusNode.hasFocus) {
                              toProvider.clear();
                              if (!isOverlayMounted) {
                                overlay = overlaySuggestions();
                                Overlay.of(context).insert(overlay!);
                              }
                            } else if (isOverlayMounted) {
                              toController.clear();
                              Provider.of<SearchSuggestionProvider>(
                                context,
                                listen: false,
                              ).clear();
                              overlay!.remove();
                              overlay = null;
                            }
                          }),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          fillColor: toFocusNode.hasFocus
                              ? Colors.white
                              : toProvider.selected == null
                                  ? MyTheme.colorSecondaryLight
                                  : MyTheme.colorPrimaryLight,
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                            borderSide: BorderSide(
                              color: MyTheme.colorSecondary,
                              width: 5,
                            ),
                          ),
                          filled: true,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(99),
                            ),
                          ),
                          hintText: toProvider.title,
                          hintStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Padding(
                            padding:
                                EdgeInsets.only(top: 16, left: 20, right: 15),
                            child: Text(
                              'TO      ',
                              textAlign: TextAlign.center,
                              textScaleFactor: 0.6,
                              style: TextStyle(fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
