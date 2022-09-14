import 'package:flutter/material.dart';

class AppTheme {
  static final Color darkThemeAccent =
      Colors.lightBlueAccent[100]!; // #FF80D8FF
  static const Color lightThemeAccent = Colors.white;
  static final Color? darkThemeBackground = Colors.grey[900];
  static final Color tnerBlue = Colors.lightBlueAccent[700]!;
  static MaterialColor customLightBlue = MaterialColor(
    darkThemeAccent.value,
    // Affects button, button text, textField border colors
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
  static const bool useMaterial3Themes = false;

  // todo define primary, onPrimary, secondary,...
  // todo try to standardize with fromSeed/fromSwatch without sacrificing the current theming
  static ThemeData getDarkTheme() {
    if (useMaterial3Themes) {
      ColorScheme colorScheme = ColorScheme.fromSeed(
          brightness: Brightness.dark, seedColor: Colors.lightBlueAccent);

      return _getDarkThemeWithColorScheme(colorScheme).copyWith(
          scaffoldBackgroundColor: darkThemeBackground,
          errorColor: const Color(0xFFCF6679),
          // As defined in material design
          appBarTheme: ThemeData.dark()
              .appBarTheme
              .copyWith(backgroundColor: colorScheme.surface),
          checkboxTheme: ThemeData.dark()
              .checkboxTheme
              .copyWith(checkColor: MaterialStateProperty.all(Colors.black)),
          snackBarTheme: ThemeData.dark()
              .snackBarTheme
              .copyWith(actionTextColor: Colors.blue));
    } else {
      return _getMaterial2DarkTheme();
    }
  }

  /// Work around for the hardcoded Colors.tealAccent[200] teal accent color
  static ThemeData _getDarkThemeWithColorScheme(ColorScheme colorScheme) {
    // have artifacts when the sliverSearchBar
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      indicatorColor: colorScheme.primary,
      toggleableActiveColor: colorScheme.primary,
      colorScheme: colorScheme,
    );
  }

  static ThemeData _getMaterial2DarkTheme() {
    return ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: darkThemeBackground,
        // override
        indicatorColor: darkThemeAccent,
        // todo  indicatorColor ??= accentColor == primaryColor ? Colors.white : accentColor;
        // As defined in material design
        errorColor: const Color(0xFFCF6679),
        // TabBar & custom checkbox in remodelling selections
        toggleableActiveColor: darkThemeAccent,
        // Flutter checkbox
        checkboxTheme: ThemeData.dark()
            .checkboxTheme
            .copyWith(checkColor: MaterialStateProperty.all(Colors.black)),
        // Checkbox & Switch
        // In dark mode, the accentColor setting has no effect because it is forced to be Colors.tealAccent[200]
        // same as toggleableActiveColor and must be manually overridden
        colorScheme: ColorScheme.fromSwatch(
                primarySwatch: customLightBlue,
                //accentColor: darkThemeAccent,
                brightness: Brightness.dark)
            .copyWith(
                secondary: darkThemeAccent, tertiary: Colors.lightBlueAccent),
        appBarTheme: ThemeData.dark()
            .appBarTheme
            .copyWith(backgroundColor: ThemeData.dark().canvasColor),
        snackBarTheme: ThemeData.dark()
            .snackBarTheme
            .copyWith(actionTextColor: Colors.blue));
  }

  static ThemeData getLightTheme() {
    if (useMaterial3Themes) {
      return ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue); //todo
    } else {
      return _getMaterial2LightTheme();
    }
  }

  static ThemeData _getMaterial2LightTheme() {
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

  static Color getBackgroundColor(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;

  /// Essentially the same function as getCardTitleTextStyle(), this should be
  /// used only in a ListTile setting when swapping between title and subtitle
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

  /// Specifically for the rent text in PropertyListTile
  static TextStyle? getRentTextStyle(BuildContext context) =>
      Theme.of(context).textTheme.subtitle1;

  static TextStyle? getHeadline6TextStyle(BuildContext context) =>
      Theme.of(context).textTheme.headline6;

  static TextStyle? getInkWellButtonTextStyle(BuildContext context) =>
      Theme.of(context)
          .textTheme
          .button!
          .copyWith(color: getTertiaryColor(context));

  static TextStyle? getStepTitleTextStyle(BuildContext context) =>
      Theme.of(context)
          .textTheme
          .subtitle1!
          .copyWith(color: Theme.of(context).colorScheme.secondary);

  static TextStyle? getStepSubtitleTextStyle(BuildContext context) =>
      Theme.of(context)
          .textTheme
          .subtitle1!
          .copyWith(color: Theme.of(context).textTheme.caption!.color);

  static Color? getPrimaryColor(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static Color? getTertiaryColor(BuildContext context) =>
      Theme.of(context).colorScheme.tertiary;
}
