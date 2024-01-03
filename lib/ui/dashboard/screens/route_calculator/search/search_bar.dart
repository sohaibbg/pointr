import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../route_calculator_view_model.dart';

part 'search_bar.g.dart';

@riverpod
FocusNode searchBarFocusNode(
  SearchBarFocusNodeRef ref,
  int i,
) =>
    useFocusNode();

@riverpod
TextEditingController searchBarTextEditingController(
  SearchBarTextEditingControllerRef ref,
  int i,
) =>
    useTextEditingController();

class LocSearchBar extends HookConsumerWidget {
  final bool autofocus;

  const LocSearchBar({super.key, required this.autofocus});

  String getLabelFromIndex(int i) {
    if (i == 0) return 'FROM';
    assert(i == 1);
    return 'TO';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeStopIndex = ref.watch(activeStopIndexProvider);
    if (activeStopIndex == -1) return const SizedBox();
    final focusNode = ref.read(
      SearchBarFocusNodeProvider(activeStopIndex),
    );
    final textCtl = ref.read(
      searchBarTextEditingControllerProvider(activeStopIndex),
    );
    final indexLabel = getLabelFromIndex(activeStopIndex);

    return TextField(
      autofocus: autofocus,
      controller: textCtl,
      decoration: InputDecoration(
        prefixIcon: focusNode.hasFocus
            ? const Icon(Icons.search)
            : Text(
                indexLabel,
              ),
        suffixIcon: focusNode.hasFocus
            ? IconButton(
                icon: Icon(
                  textCtl.text.isNotEmpty
                      ? Icons.close
                      : Icons.keyboard_arrow_down,
                ),
                onPressed: () {
                  if (textCtl.text.isNotEmpty) return textCtl.clear();
                  focusNode.previousFocus();
                },
              )
            : null,
        constraints: const BoxConstraints(minHeight: 248),
      ),
    );
  }
}
