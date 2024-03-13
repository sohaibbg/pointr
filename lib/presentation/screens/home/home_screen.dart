import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../config/my_theme.dart';
import 'favorites_view.dart';
import 'nearby_suggestions_view.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backdrop = Image.asset(
      'assets/images/geometric pattern.png',
      fit: BoxFit.fitWidth,
      alignment: Alignment.topCenter,
    );
    final searchButton = ListTile(
      onTap: () => context.go(
        '/route-calculator',
        extra: {'focusSearch': true},
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 24,
      ),
      leading: const Icon(
        Icons.search,
      ),
      trailing: IconButton(
        onPressed: () => context.go(
          '/route-calculator',
        ),
        icon: const Icon(
          Icons.my_location_sharp,
        ),
      ),
      title: const Text("Enter Destination..."),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: const BorderSide(color: MyTheme.colorSecondaryDark),
      ),
      tileColor: MyTheme.colorSecondaryLight,
    );
    final title = ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 400,
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 48,
            left: 24,
            right: 30,
            bottom: 24,
          ),
          child: Text(
            "Where are you currently?",
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ),
    );
    final scrollController = useScrollController();
    final foregroundBody = CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
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
        const SliverToBoxAdapter(
          child: SizedBox(height: 220),
        ),
      ],
    );
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.expand,
        children: [
          backdrop,
          foregroundBody,
        ],
      ),
    );
  }
}
