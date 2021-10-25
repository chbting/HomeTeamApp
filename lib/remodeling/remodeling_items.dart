import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum RemodelingItem {
  painting,
  wallCoverings,
  acInstallation,
  removals,
  suspendedCeiling,
  toiletReplacement,
  pestControl
}

String getRemodelingItemTitle(RemodelingItem key, BuildContext context) {
  if (key == RemodelingItem.painting) {
    return AppLocalizations.of(context)!.painting;
  }
  if (key == RemodelingItem.wallCoverings) {
    return AppLocalizations.of(context)!.wallcoverings;
  }
  if (key == RemodelingItem.acInstallation) {
    return AppLocalizations.of(context)!.ac_installation;
  }
  if (key == RemodelingItem.removals) {
    return AppLocalizations.of(context)!.removals;
  }
  if (key == RemodelingItem.suspendedCeiling) {
    return AppLocalizations.of(context)!.suspended_ceiling;
  }
  if (key == RemodelingItem.toiletReplacement) {
    return AppLocalizations.of(context)!.toilet_replacement;
  }
  if (key == RemodelingItem.pestControl) {
    return AppLocalizations.of(context)!.pest_control;
  }
  throw 'NoTitleCreatedForRemodelingItem';
}
