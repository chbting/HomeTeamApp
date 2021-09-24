import 'package:flutter/material.dart';

class AppTheme {
  static final Color tnerLightBlue = Colors.lightBlueAccent[100]!; // #FF80D8FF
  static final Color tnerBlue = Colors.blue[400]!; // #FF42A5F5

  static ThemeData getDarkTheme() {
    return ThemeData.dark().copyWith(
        toggleableActiveColor: tnerLightBlue,
        colorScheme:
            ThemeData.dark().colorScheme.copyWith(secondary: tnerLightBlue));
  }

  // TODO not working
  static ThemeData getLightTheme() {
    return ThemeData.light().copyWith(
        toggleableActiveColor: Colors.redAccent,
        colorScheme: ThemeData.light()
            .colorScheme
            .copyWith(secondary: Colors.redAccent));
  }
}
