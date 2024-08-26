import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../config/my_theme.dart';
import 'go/go_screen.dart';
import 'routes/list_routes_screen.dart';

enum HomeScreenOptions { go, routes }

class Home extends HookWidget {
  const Home({
    super.key,
    required this.homeScreenOptions,
  });

  final HomeScreenOptions homeScreenOptions;
  @override
  Widget build(BuildContext context) {
    final selectedOptionIndex = useState(homeScreenOptions.index);
    final selectedOption = switch (selectedOptionIndex.value) {
      0 => HomeScreenOptions.go,
      1 => HomeScreenOptions.routes,
      _ => throw UnimplementedError(),
    };
    final bottomNavigationBar = Material(
      elevation: 8,
      child: BottomNavigationBar(
        backgroundColor: Color.lerp(
          MyTheme.primaryColor.shade50,
          Colors.white,
          0.5,
        ),
        currentIndex: selectedOptionIndex.value,
        onTap: (value) => selectedOptionIndex.value = value,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk_rounded),
            label: "Go",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.route),
            label: "Routes",
          ),
        ],
      ),
    );
    final backdrop = Image.asset(
      'assets/images/geometric pattern.png',
      fit: BoxFit.fitWidth,
      alignment: Alignment.topCenter,
    );
    final body = Stack(
      alignment: Alignment.topCenter,
      fit: StackFit.expand,
      children: [
        backdrop,
        switch (selectedOption) {
          HomeScreenOptions.go => const GoScreen(),
          HomeScreenOptions.routes => const ListRoutesScreen(),
        },
      ],
    );
    return Scaffold(
      bottomNavigationBar: bottomNavigationBar,
      body: body,
    );
  }
}
