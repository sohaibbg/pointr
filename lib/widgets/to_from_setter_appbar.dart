import 'dart:async';

import 'package:pointr/providers/search_suggestion_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pointr/classes/google_api.dart';
import 'package:pointr/my_theme.dart';
import 'package:pointr/providers/from_provider.dart';
import 'package:pointr/providers/to_provider.dart';
import 'package:provider/provider.dart';

class ToFromSetterAppBar extends StatelessWidget {
  const ToFromSetterAppBar({super.key});
  static final TextEditingController fromController = TextEditingController();
  static final TextEditingController toController = TextEditingController();
  static final FocusNode fromFocusNode = FocusNode();
  static final FocusNode toFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) => KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) =>
            Consumer3<FromProvider, ToProvider, SearchSuggestionProvider>(
          builder: (context, fromProvider, toProvider, searchProvider, child) {
            FutureOr<void> onNext(LatLng latLng) async {
              if (fromProvider.selected == null) {
                fromProvider.select(
                  latLng: latLng,
                  name: await GoogleApi.nameFromLatLng(latLng),
                );
              } else {
                toProvider.select(
                  latLng: latLng,
                  name: await GoogleApi.nameFromLatLng(latLng),
                );
                // Get.to(
                //   () => DisplayRoutes(
                //     fromProvider.selected: fromProvider.selected!,
                //     fromName: fromName!,
                //     toLatLng: latLng,
                //     toName: toName,
                //   ),
                // );
              }
            }

            fromFocusNode.addListener(() {
              if (fromFocusNode.hasFocus) fromProvider.clear();
            });
            toFocusNode.addListener(() {
              if (toFocusNode.hasFocus) toProvider.clear();
            });
            return Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewPadding.top + 7,
              ),
              decoration: const BoxDecoration(
                color: MyTheme.colorPrimary,
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/geometric pattern.png',
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      // from
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 16,
                          bottom: 8,
                          left: 48,
                          top: 4,
                        ),
                        child: Consumer<FromProvider>(
                          builder: (context, fromProvider, child) => TextField(
                            focusNode: fromFocusNode,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              fillColor: fromProvider.selected == null
                                  ? MyTheme.colorSecondaryLight
                                  : MyTheme.colorPrimaryLight,
                              filled: true,
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
                                padding: EdgeInsets.only(
                                    top: 16, left: 20, right: 15),
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
                        padding: const EdgeInsets.only(
                          right: 16,
                          bottom: 8,
                          left: 48,
                          top: 4,
                        ),
                        child: Consumer<ToProvider>(
                          builder: (context, toProvider, child) => TextField(
                            enabled: false,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              fillColor: MyTheme.colorPrimaryLight,
                              filled: true,
                              enabled: false,
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
                                padding: EdgeInsets.only(
                                    top: 16, left: 20, right: 15),
                                child: Text(
                                  'TO',
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
                  // FROM is set, its descriptor
                  if (fromProvider.selected != null && !isKeyboardVisible)
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 16, bottom: 8, left: 48, top: 4),
                      child: TextField(
                        enabled: false,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          fillColor: MyTheme.colorPrimaryLight,
                          filled: true,
                          enabled: false,
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
                  // back button, search field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // search title
                      Padding(
                        padding: EdgeInsets.only(left: 56 + 1.w, bottom: 0.5.h),
                        child: Text(
                          fromProvider.selected == null
                              ? "LEAVING FROM"
                              : "GOING TO",
                          style: MyTheme.subtitle,
                        ),
                      ),
                      // back button, search field
                      Padding(
                        padding: const EdgeInsets.only(right: 16, bottom: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // back button
                            IconButton(
                              onPressed: Navigator.of(context).pop,
                              icon: const Icon(Icons.arrow_back),
                            ),
                            // search field
                            Flexible(
                              child: TextField(
                                autofocus: true,
                                controller: fromController,
                                // clear all button
                                decoration: MyTheme.addressFieldStyle.copyWith(
                                  suffixIcon: IconButton(
                                    onPressed: fromController.clear,
                                    icon: const Icon(Icons.clear),
                                  ),
                                ),
                                onChanged: (_) => searchProvider.clear(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
}
