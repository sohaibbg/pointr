import 'package:flutter/material.dart';

class MyTheme {
  static final themeData = ThemeData(
    useMaterial3: true,
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: MyTheme.colorSecondary,
      selectionHandleColor: MyTheme.colorSecondary,
    ),
    primarySwatch: Colors.indigo,
    colorScheme: ThemeData().colorScheme.copyWith(
          secondary: Colors.amber,
          background: Colors.white,
        ),
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 17),
    ),
  );
  static const TextStyle heading1 = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.bold,
    fontFamily: 'NunitoSans',
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    fontFamily: 'NunitoSans',
  );
  static const TextStyle subheading1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: 'NunitoSans',
  );
  static const TextStyle body = TextStyle(fontSize: 17);
  static const TextStyle subtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w300,
  );
  static const Color colorPrimary = Colors.indigo;
  static const Color colorPrimaryLight = Color.fromARGB(255, 121, 134, 203);
  static const Color colorSecondaryLight = Color(0xffFFF7B1);
  static const Color colorSecondary = Colors.amber;
  static const Color colorSecondaryDark = Color(0xff946B02);
  static const Color colorSecondaryDarkAccent = Color(0xffB98602);
  static ButtonStyle outlineButtonStyle = ButtonStyle(
    side: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.hovered) ||
          states.contains(MaterialState.focused)) {
        return const BorderSide(color: colorSecondaryDarkAccent);
      }
      if (states.contains(MaterialState.selected) ||
          states.contains(MaterialState.pressed)) {
        return const BorderSide(color: colorSecondaryLight);
      }
      return const BorderSide(color: colorSecondary);
    }),
    surfaceTintColor: const MaterialStatePropertyAll(colorSecondaryLight),
    elevation: const MaterialStatePropertyAll(0),
    shape: const MaterialStatePropertyAll(StadiumBorder()),
    shadowColor: const MaterialStatePropertyAll(Colors.black),
    overlayColor: const MaterialStatePropertyAll(Colors.black),
    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) {
          return colorSecondaryDarkAccent;
        }
        if (states.contains(MaterialState.selected) ||
            states.contains(MaterialState.pressed)) return colorSecondaryLight;
        return colorSecondary;
      },
    ),
    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.focused)) return colorSecondaryLight;
        if (states.contains(MaterialState.selected) ||
            states.contains(MaterialState.pressed)) return colorSecondary;
        return Colors.white;
      },
    ),
  );
  // TO-DO implement elevated button style
  static ButtonStyle elevatedButtonStyle = const ButtonStyle(
      // surfaceTintColor: const MaterialStatePropertyAll(colorSecondaryLight),
      // shape: const MaterialStatePropertyAll(StadiumBorder()),
      // shadowColor: const MaterialStatePropertyAll(Colors.black),
      // overlayColor: const MaterialStatePropertyAll(Colors.black),
      // foregroundColor: MaterialStateProperty.resolveWith<Color?>(
      //   (Set<MaterialState> states) {
      //     if (states.contains(MaterialState.hovered) ||
      //         states.contains(MaterialState.focused)) {
      //       return colorSecondaryDarkAccent;
      //     }
      //     if (states.contains(MaterialState.selected) ||
      //         states.contains(MaterialState.pressed)) return colorSecondaryLight;
      //     return colorSecondary;
      //   },
      // ),
      // backgroundColor: MaterialStateProperty.resolveWith<Color?>(
      //   (Set<MaterialState> states) {
      //     if (states.contains(MaterialState.hovered) ||
      //         states.contains(MaterialState.focused)) return colorSecondaryLight;
      //     if (states.contains(MaterialState.selected) ||
      //         states.contains(MaterialState.pressed)) return colorSecondary;
      //     return Colors.white;
      //   },
      // ),
      );

  static InputDecoration addressFieldStyle = const InputDecoration(
    contentPadding: EdgeInsets.symmetric(horizontal: 2),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyTheme.colorSecondary),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: MyTheme.colorSecondary),
    ),
  );
}
