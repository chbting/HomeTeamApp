import 'package:flutter/material.dart';

class AppTheme {
  static final Color darkThemeAccent =
      Colors.lightBlueAccent[100]!; // #FF80D8FF
  static const Color lightThemeAccent = Colors.white;
  static final Color? darkThemeBackground = Colors.grey[900];
  static final Color tnerBlue = Colors.lightBlueAccent[700]!;
  static const MaterialColor lightBlue = MaterialColor(
    0xFF29B6F6,
    <int, Color>{
      50: Color(0xFFE1F5FE),
      100: Color(0xFFB3E5FC),
      200: Color(0xFF81D4FA),
      300: Color(0xFF4FC3F7),
      400: Color(0xFF29B6F6),
      500: Color(0xFF29B6F6),
      600: Color(0xFF039BE5),
      700: Color(0xFF0288D1),
      800: Color(0xFF0277BD),
      900: Color(0xFF01579B),
    },
  );
  static ThemeData getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      indicatorColor: darkThemeAccent,
      toggleableActiveColor: darkThemeAccent,
      colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.lightBlue, brightness: Brightness.dark)
          .copyWith(secondary: darkThemeAccent),
      scaffoldBackgroundColor: darkThemeBackground,
      // inputDecorationTheme: ThemeData.dark().inputDecorationTheme.copyWith(
      //     // labelStyle: const InputDecorationTheme()
      //     //     .labelStyle!
      //     //     .copyWith(color: darkThemeAccent),
      //     focusColor: darkThemeAccent,
      //     focusedBorder: const OutlineInputBorder()
      //         .copyWith(borderSide: BorderSide(color: darkThemeAccent)))
    );
  }

  static ThemeData getLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
    );
  }
}
