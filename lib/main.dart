import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'misc/my_theme.dart';
import 'misc/routes.dart';

void main() => runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pointr',
      theme: MyTheme.themeData,
      routerConfig: router,
    );
  }
}
