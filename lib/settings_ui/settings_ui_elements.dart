import 'package:flutter/material.dart';

getSettingsTitle(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(72.0, 16.0, 0.0, 0.0),
    child: Text(title,
        style: Theme.of(context)
            .textTheme
            .subtitle2!
            .copyWith(color: Theme.of(context).colorScheme.secondary)),
  );
}
