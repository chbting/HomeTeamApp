import 'package:flutter/material.dart';

class AppTheme {
  static final Color darkThemeAccent =
      Colors.lightBlueAccent[100]!; // #FF80D8FF
  static const Color lightThemeAccent = Colors.white;
  static final Color? darkThemeBackground = Colors.grey[900];
  static final Color tnerBlue = Colors.lightBlueAccent[700]!;
  static MaterialColor customLightBlue = MaterialColor(
    darkThemeAccent.value,
    <int, Color>{
      50: Colors.lightBlue[50]!,
      100: Colors.lightBlue[100]!,
      200: Colors.lightBlue[200]!,
      300: Colors.lightBlue[300]!,
      400: Colors.lightBlue[400]!,
      500: Colors.lightBlue[500]!,
      600: Colors.lightBlue[600]!,
      700: Colors.lightBlue[700]!,
      800: Colors.lightBlue[800]!,
      900: Colors.lightBlue[900]!,
    },
  );

  static ThemeData getDarkTheme() {
    return ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkThemeBackground,
        indicatorColor: darkThemeAccent,
        // TabBar
        toggleableActiveColor: darkThemeAccent,
        // Checkbox, Switch
        colorScheme: ColorScheme.fromSwatch(
                primarySwatch: customLightBlue,
                accentColor: darkThemeAccent,
                brightness: Brightness.dark)
            .copyWith(secondary: darkThemeAccent),
        snackBarTheme: ThemeData.dark()
            .snackBarTheme
            .copyWith(actionTextColor: Colors.blue));
  }

  static ThemeData getLightTheme() {
    return ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        snackBarTheme: ThemeData.light()
            .snackBarTheme
            .copyWith(actionTextColor: darkThemeAccent));
  }

  static TextStyle getDialogTextButtonTextStyle(BuildContext context) =>
      TextStyle(color: Theme.of(context).colorScheme.secondary);

  static TextStyle getListTileBodyTextStyle(BuildContext context) =>
      Theme.of(context)
          .textTheme
          .bodyText2!
          .copyWith(color: Theme.of(context).textTheme.caption!.color);

  static TextStyle? getCardTitleTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.caption;
  }

  static TextStyle? getCardBodyTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.subtitle1;
  }

  static String dateFormat = 'd/M/y (EEEE)';
}
