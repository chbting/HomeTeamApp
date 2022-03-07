import 'package:tner_client/utils/text_helper.dart';

enum RemodelingItem {
  painting,
  wallCoverings,
  ac,
  removals,
  suspendedCeiling,
  toiletReplacement,
  pestControl
}

String getRemodelingItemTitle(RemodelingItem item) {
  if (item == RemodelingItem.painting) {
    return TextHelper.appLocalizations.painting;
  }
  if (item == RemodelingItem.wallCoverings) {
    return TextHelper.appLocalizations.wallcoverings;
  }
  if (item == RemodelingItem.ac) {
    return TextHelper.appLocalizations.ac_window_type;
  }
  if (item == RemodelingItem.removals) {
    return TextHelper.appLocalizations.removals;
  }
  if (item == RemodelingItem.suspendedCeiling) {
    return TextHelper.appLocalizations.suspended_ceiling;
  }
  if (item == RemodelingItem.toiletReplacement) {
    return TextHelper.appLocalizations.toilet_replacement;
  }
  if (item == RemodelingItem.pestControl) {
    return TextHelper.appLocalizations.pest_control;
  }
  throw 'NoTitleCreatedForRemodelingItem';
}
