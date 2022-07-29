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
        // As defined in material design
        errorColor: const Color(0xFFCF6679),
        // TabBar & custom checkbox in remodelling selections
        toggleableActiveColor: darkThemeAccent,
        // Flutter checkbox
        checkboxTheme: ThemeData.dark()
            .checkboxTheme
            .copyWith(checkColor: MaterialStateProperty.all(Colors.black)),
        // Checkbox & Switch
        colorScheme: ColorScheme.fromSwatch(
                primarySwatch: customLightBlue,
                accentColor: darkThemeAccent,
                brightness: Brightness.dark)
            .copyWith(
                secondary: darkThemeAccent, tertiary: Colors.lightBlueAccent),
        snackBarTheme: ThemeData.dark()
            .snackBarTheme
            .copyWith(actionTextColor: Colors.blue));
  }

  static ThemeData getLightTheme() {
    return ThemeData(
        // todo scroll gradient is difficult to see
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        colorScheme:
            ThemeData.light().colorScheme.copyWith(tertiary: Colors.blueAccent),
        snackBarTheme: ThemeData.light()
            .snackBarTheme
            .copyWith(actionTextColor: darkThemeAccent));
  }

  static TextStyle getDialogTextButtonTextStyle(BuildContext context) =>
      TextStyle(color: Theme.of(context).colorScheme.secondary);

  /// Essentially the same function as getCardTitleTextStyle(), but this should
  /// be used only in a ListTile setting when swapping title and subtitle
  static TextStyle getListTileBodyTextStyle(BuildContext context) =>
      Theme.of(context)
          .textTheme
          .bodyText2!
          .copyWith(color: Theme.of(context).textTheme.caption!.color);

  /// Same style as ListTile subtitle text (unselected)
  static TextStyle? getCardTitleTextStyle(BuildContext context) =>
      Theme.of(context)
          .textTheme
          .bodyText2!
          .copyWith(color: Theme.of(context).textTheme.caption!.color);

  /// Same style (subtitle1) as ListTileStyle.list
  static TextStyle? getCardBodyTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.subtitle1;

  /// Copied from input_decorator.dart _getIconColor(ThemeData themeData)
  static Color getTextFieldIconColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white70
          : Colors.black45;

  static TextStyle? getRentTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.subtitle1;

  static TextStyle? getInkWellButtonTextStyle(BuildContext context) =>
      Theme.of(context)
          .textTheme
          .subtitle2!
          .copyWith(color: getInkWellButtonColor(context));

  static Color? getInkWellButtonColor(BuildContext context) =>
      Theme.of(context).colorScheme.tertiary;
}
