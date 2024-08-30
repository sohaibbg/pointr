import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import '../../config/my_theme.dart';

enum DrawerOptions {
  go(
    iconData: Icons.directions_walk_rounded,
    name: 'Go',
    path: '/go',
  ),
  routes(
    iconData: Icons.route,
    name: 'Routes',
    path: '/route',
  ),
  about(
    iconData: Icons.info,
    name: 'About',
    path: '/about',
  );

  final String name;
  final IconData iconData;
  final String path;

  const DrawerOptions({
    required this.name,
    required this.iconData,
    required this.path,
  });
}

class DrawerScaffold extends HookWidget {
  const DrawerScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final backdrop = Image.asset(
      'assets/images/geometric pattern.png',
      fit: BoxFit.fitWidth,
      alignment: Alignment.topCenter,
    );
    final body = Stack(
      alignment: Alignment.topCenter,
      fit: StackFit.expand,
      children: [backdrop, child],
    );
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Color.lerp(
          MyTheme.primaryColor.shade50,
          Colors.white,
          0.5,
        ),
        child: ListView(
          reverse: true,
          children: [
            DrawerHeader(
              padding: const EdgeInsetsDirectional.fromSTEB(32, 20, 28, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "pointr",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const Text("Public Transport routes for Karachi"),
                ],
              ),
            ),
            ...DrawerOptions.values.map(
              (o) => Column(
                children: [
                  Builder(
                    builder: (context) => ListTile(
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(32, 0, 28, 0),
                      title: Text(o.name),
                      leading: Icon(o.iconData),
                      onTap: () {
                        context.go(o.path);
                        Scaffold.of(context).closeDrawer();
                      },
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
