import 'package:flutter/material.dart';

class AppTheme {
  static final Color darkThemeAccent =
      Colors.lightBlueAccent[100]!; // #FF80D8FF
  static const Color lightThemeAccent = Colors.white;
  static final Color? darkThemeBackground = Colors.grey[900];
  static final Color tnerBlue = Colors.lightBlueAccent[700]!;

  static ThemeData getDarkTheme() {
    return ThemeData.dark().copyWith(
        indicatorColor: darkThemeAccent,
        toggleableActiveColor: darkThemeAccent,
        scaffoldBackgroundColor: darkThemeBackground,
        colorScheme:
            ThemeData.dark().colorScheme.copyWith(secondary: darkThemeAccent),
        checkboxTheme: ThemeData.dark().checkboxTheme.copyWith(
            checkColor: MaterialStateProperty.all(darkThemeBackground)),
        snackBarTheme:
            ThemeData.dark().snackBarTheme.copyWith(actionTextColor: tnerBlue),
        inputDecorationTheme: ThemeData.dark().inputDecorationTheme.copyWith(
            // hintStyle: const InputDecorationTheme()
            //     .hintStyle!
            //     .copyWith(color: darkThemeAccent),
            focusColor: darkThemeAccent,
            focusedBorder: const OutlineInputBorder()
                .copyWith(borderSide: BorderSide(color: darkThemeAccent))));
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
