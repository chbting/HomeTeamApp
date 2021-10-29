import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum RemodelingItem {
  painting,
  wallCoverings,
  ac,
  removals,
  suspendedCeiling,
  toiletReplacement,
  pestControl
}

String getRemodelingItemTitle(RemodelingItem item, BuildContext context) {
  if (item == RemodelingItem.painting) {
    return AppLocalizations.of(context)!.painting;
  }
  if (item == RemodelingItem.wallCoverings) {
    return AppLocalizations.of(context)!.wallcoverings;
  }
  if (item == RemodelingItem.ac) {
    return AppLocalizations.of(context)!.ac_window_type;
  }
  if (item == RemodelingItem.removals) {
    return AppLocalizations.of(context)!.removals;
  }
  if (item == RemodelingItem.suspendedCeiling) {
    return AppLocalizations.of(context)!.suspended_ceiling;
  }
  if (item == RemodelingItem.toiletReplacement) {
    return AppLocalizations.of(context)!.toilet_replacement;
  }
  if (item == RemodelingItem.pestControl) {
    return AppLocalizations.of(context)!.pest_control;
  }
  throw 'NoTitleCreatedForRemodelingItem';
}
