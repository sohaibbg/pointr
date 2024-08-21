import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'config/injector.dart';
import 'config/logger.dart';
import 'config/my_theme.dart';
import 'config/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(
    ProviderScope(
      observers: [
        LoggerObserver(),
      ],
      child: const MyApp(),
    ),
  );
}

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
