import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RemodelingItems {
  static const String paintingKey = 'painting';
  static const String wallCoveringsKey = 'wallCoverings';
  static const String acInstallationKey = 'acInstallation';
  static const String removalsKey = 'removals';
  static const String suspendedCeilingKey = 'suspendedCeiling';
  static const String toiletReplacementKey = 'toiletReplacement';
  static const String pestControlKey = 'pestControl';

  static String getRemodelingItemTitle(String key, BuildContext context) {
    if (key == paintingKey) {
      return AppLocalizations.of(context)!.painting;
    }
    if (key == wallCoveringsKey) {
      return AppLocalizations.of(context)!.wallcoverings;
    }
    if (key == acInstallationKey) {
      return AppLocalizations.of(context)!.ac_installation;
    }
    if (key == removalsKey) {
      return AppLocalizations.of(context)!.removals;
    }
    if (key == suspendedCeilingKey) {
      return AppLocalizations.of(context)!.suspended_ceiling;
    }
    if (key == toiletReplacementKey) {
      return AppLocalizations.of(context)!.toilet_replacement;
    }
    if (key == pestControlKey) {
      return AppLocalizations.of(context)!.pest_control;
    }
    return ''; // default case
  }
}
