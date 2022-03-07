import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextHelper {
  static late AppLocalizations appLocalizations;

  static void ensureInitialized(BuildContext context) {
    appLocalizations = AppLocalizations.of(context)!;
  }
}
