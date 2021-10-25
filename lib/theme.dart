import 'package:flutter/material.dart';

class AppTheme {
  static final Color darkThemeAccent =
      Colors.lightBlueAccent[100]!; // #FF80D8FF
  static const Color lightThemeAccent = Colors.white;
  static final Color? darkThemeBackground = Colors.grey[900];
  static final Color tnerBlue = Colors.lightBlueAccent[700]!;

  static ThemeData getDarkTheme() {
    return ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkThemeBackground,
        indicatorColor: darkThemeAccent,
        toggleableActiveColor: darkThemeAccent,
        colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.lightBlue, brightness: Brightness.dark)
            .copyWith(secondary: darkThemeAccent),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(primary: darkThemeAccent)),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          primary: darkThemeAccent,
        )),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
          primary: darkThemeAccent,
        ))
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
