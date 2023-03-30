import 'package:pointr/providers/from_provider.dart';
import 'package:pointr/providers/to_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:pointr/classes/my_db.dart';
import 'package:pointr/my_theme.dart';
import 'package:pointr/widgets/bottom_nav_bar.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MyDb.db = await MyDb.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();

    return Sizer(
      builder: (context, orientation, deviceType) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: MyTheme.colorSecondary,
            selectionHandleColor: MyTheme.colorSecondary,
          ),
          primarySwatch: Colors.indigo,
          colorScheme: theme.colorScheme.copyWith(secondary: Colors.amber),
          fontFamily: 'Inter',
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 17),
          ),
        ),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => FromProvider()),
            ChangeNotifierProvider(create: (context) => ToProvider()),
          ],
          child: const BNavScaffold(index: 0),
        ),
      ),
    );
  }
}
