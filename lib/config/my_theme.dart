import 'package:flutter/material.dart';

abstract class MyTheme {
  static final themeData = ThemeData(
    useMaterial3: true,
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: MyTheme.secondaryColor,
      selectionHandleColor: MyTheme.secondaryColor,
    ),
    primarySwatch: primaryColor,
    colorScheme: ThemeData().colorScheme.copyWith(
          secondary: Colors.amber,
          surface: Colors.white,
        ),
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 17),
    ),
  );
  static const heading1 = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.bold,
    fontFamily: 'NunitoSans',
  );
  static const heading2 = TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    fontFamily: 'NunitoSans',
  );
  static const subheading1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    fontFamily: 'NunitoSans',
  );
  static const body = TextStyle(fontSize: 17);
  static const subtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w300,
  );
  static final primaryColor = MaterialColor(
    Colors.indigo.value,
    const {
      50: Color.fromARGB(255, 218, 222, 246),
      100: Color.fromARGB(255, 121, 134, 203),
      200: Color.fromARGB(255, 86, 100, 170),
      300: Colors.indigo,
      400: Colors.indigo,
      500: Colors.indigo,
      600: Colors.indigo,
      700: Colors.indigo,
      800: Colors.indigo,
      900: Color.fromARGB(255, 25, 38, 113),
    },
  );
  static final secondaryColor = MaterialColor(
    Colors.amber.value,
    const {
      50: Color.fromARGB(255, 251, 249, 218),
      100: Color.fromARGB(255, 251, 247, 174),
      200: Color.fromARGB(255, 254, 247, 110),
      300: Colors.amber,
      400: Color.fromARGB(255, 243, 183, 4),
      500: Color.fromARGB(255, 205, 155, 7),
      600: Color(0xffB98602),
      700: Color.fromARGB(255, 137, 98, 1),
      800: Color.fromARGB(255, 119, 87, 4),
      900: Color.fromARGB(255, 70, 50, 0),
    },
  );
  static final secondaryOutlinedButtonStyle = ButtonStyle(
    surfaceTintColor: WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.pressed)
          ? Colors.grey.withOpacity(0.8)
          : null,
    ),
    iconColor: widgetStatePropertyHelper(
      // simulateState: WidgetState.pressed,
      defaultState: MyTheme.secondaryColor,
      hoveredState: MyTheme.secondaryColor.shade700,
      pressedState: Colors.white,
    ),
    foregroundColor: widgetStatePropertyHelper(
      // simulateState: WidgetState.pressed,
      defaultState: MyTheme.secondaryColor.shade700,
      hoveredState: MyTheme.secondaryColor.shade900,
      pressedState: Colors.white,
    ),
    side: widgetStatePropertyHelper(
      // simulateState: WidgetState.pressed,
      defaultState: BorderSide(
        color: MyTheme.secondaryColor.shade400,
      ),
      hoveredState: BorderSide(
        color: MyTheme.secondaryColor.shade400,
        width: 1.5,
      ),
      pressedState: BorderSide(
        color: MyTheme.secondaryColor.shade600,
        width: 2,
      ),
    ),
    backgroundColor: widgetStatePropertyHelper(
      // simulateState: WidgetState.pressed,
      defaultState: Colors.white,
      hoveredState: MyTheme.secondaryColor.shade50,
      pressedState: MyTheme.secondaryColor.shade300,
    ),
  );
  static final elevatedButtonStyle = ButtonStyle(
    surfaceTintColor: WidgetStatePropertyAll(secondaryColor.shade100),
    shape: const WidgetStatePropertyAll(StadiumBorder()),
    shadowColor: const WidgetStatePropertyAll(Colors.black),
    overlayColor: const WidgetStatePropertyAll(Colors.black),
    foregroundColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return secondaryColor.shade600;
        }
        if (states.contains(WidgetState.selected) ||
            states.contains(WidgetState.pressed)) {
          return secondaryColor.shade100;
        }
        return secondaryColor;
      },
    ),
    backgroundColor: WidgetStateProperty.resolveWith<Color?>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return secondaryColor.shade100;
        }
        if (states.contains(WidgetState.selected) ||
            states.contains(WidgetState.pressed)) return secondaryColor;
        return Colors.white;
      },
    ),
  );
  static final primaryElevatedButtonStyle = ButtonStyle(
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(vertical: 10, horizontal: 18),
    ),
    shape: WidgetStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    textStyle: const WidgetStatePropertyAll(
      TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
    ),
    iconSize: const WidgetStatePropertyAll(36),
    backgroundColor: WidgetStateColor.resolveWith(
      (states) {
        if (states.contains(WidgetState.pressed)) {
          return MyTheme.primaryColor.shade900;
        }
        if ([
          WidgetState.dragged,
          WidgetState.focused,
          WidgetState.hovered,
          WidgetState.selected,
        ].any(states.contains)) {
          return MyTheme.primaryColor.shade100;
        }
        return MyTheme.primaryColor;
      },
    ),
    foregroundColor: WidgetStateColor.resolveWith(
      (states) {
        if (states.contains(WidgetState.pressed)) {
          return MyTheme.secondaryColor.shade200;
        }
        if ([
          WidgetState.dragged,
          WidgetState.focused,
          WidgetState.hovered,
          WidgetState.selected,
        ].any(states.contains)) {
          return MyTheme.secondaryColor;
        }
        return Colors.white;
      },
    ),
  );
  static final primaryOutlinedButtonStyle = ButtonStyle(
    iconColor: widgetStatePropertyHelper(
      defaultState: MyTheme.primaryColor,
      hoveredState: MyTheme.primaryColor.shade800,
      pressedState: Colors.white,
    ),
    foregroundColor: widgetStatePropertyHelper(
      defaultState: MyTheme.primaryColor,
      hoveredState: MyTheme.primaryColor.shade900,
      pressedState: Colors.white,
    ),
    side: widgetStatePropertyHelper(
      defaultState: null,
      hoveredState: BorderSide(
        color: MyTheme.primaryColor.shade900,
        width: 1.5,
      ),
      pressedState: BorderSide(
        color: MyTheme.primaryColor.shade900,
        width: 2,
      ),
    ),
    backgroundColor: widgetStatePropertyHelper(
      defaultState: Colors.white,
      hoveredState: MyTheme.primaryColor.shade50,
      pressedState: MyTheme.primaryColor.shade100,
    ),
  );
  static final secondaryButtonStyle = ButtonStyle(
    shape: const WidgetStatePropertyAll(CircleBorder()),
    padding: const WidgetStatePropertyAll(
      EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
    ),
    backgroundColor: WidgetStateColor.resolveWith(
      (states) {
        if (states.contains(WidgetState.pressed)) {
          return MyTheme.secondaryColor.shade500;
        }
        if ([
          WidgetState.dragged,
          WidgetState.focused,
          WidgetState.hovered,
          WidgetState.selected,
        ].any(states.contains)) {
          return MyTheme.secondaryColor.shade50;
        }
        return MyTheme.secondaryColor.shade100;
      },
    ),
    foregroundColor: WidgetStateColor.resolveWith(
      (states) {
        if (states.contains(WidgetState.pressed)) {
          return MyTheme.primaryColor.shade50;
        }
        if ([
          WidgetState.dragged,
          WidgetState.focused,
          WidgetState.hovered,
          WidgetState.selected,
        ].any(states.contains)) {
          return MyTheme.primaryColor.shade900;
        }
        return MyTheme.primaryColor;
      },
    ),
  );
  static final addressFieldStyle = InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 2),
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: secondaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: secondaryColor),
    ),
  );
  static const cardDecoration = BoxDecoration(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(25),
    ),
    color: Colors.white,
    image: DecorationImage(
      image: AssetImage(
        'assets/images/geometric pattern.png',
      ),
      // repeat: ImageRepeat.repeatX,
      fit: BoxFit.fitWidth,
    ),
    boxShadow: [
      BoxShadow(
        blurRadius: 3,
        color: Colors.grey,
        offset: Offset(0, -1),
      ),
    ],
  );
}

WidgetStateProperty<T> widgetStatePropertyHelper<T>({
  required T defaultState,
  required T hoveredState,
  required T pressedState,
  WidgetState? simulateState,
}) =>
    WidgetStateProperty.resolveWith(
      (states) {
        if (simulateState != null) states = {simulateState};
        if (states.contains(WidgetState.pressed)) {
          return pressedState;
        }
        if ([
          WidgetState.dragged,
          WidgetState.focused,
          WidgetState.hovered,
          WidgetState.selected,
        ].any(states.contains)) {
          return hoveredState;
        }
        return defaultState;
      },
    );
