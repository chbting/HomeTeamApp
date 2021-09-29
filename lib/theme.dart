import 'package:flutter/material.dart';

class AppTheme {
  static final Color darkThemeAccent = Colors.lightBlueAccent[100]!; // #FF80D8FF
  static final Color lightThemeAccent = Colors.white;
  static final Color tnerBlue = Colors.lightBlueAccent[700]!;

  static ThemeData getDarkTheme() {
    return ThemeData.dark().copyWith(
        indicatorColor: darkThemeAccent,
        toggleableActiveColor: darkThemeAccent,
        colorScheme:
            ThemeData.dark().colorScheme.copyWith(secondary: darkThemeAccent));
  }

  static ThemeData getLightTheme() {
    return ThemeData.light().copyWith(
        indicatorColor: lightThemeAccent,
        toggleableActiveColor: tnerBlue,
        colorScheme: ThemeData.light()
            .colorScheme
            .copyWith(primary: tnerBlue, secondary: tnerBlue));
  }
}
