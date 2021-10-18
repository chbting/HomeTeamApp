import 'package:flutter/material.dart';

class SettingsUI {
  static getSettingsTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 72.0, top: 16.0),
      child: Text(title,
          style: Theme.of(context)
              .textTheme
              .subtitle2!
              .copyWith(color: Theme.of(context).colorScheme.secondary)),
    );
  }
}
