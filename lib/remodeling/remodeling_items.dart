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
    return TextHelper.s.painting;
  }
  if (item == RemodelingItem.wallCoverings) {
    return TextHelper.s.wallcoverings;
  }
  if (item == RemodelingItem.ac) {
    return TextHelper.s.ac_window_type;
  }
  if (item == RemodelingItem.removals) {
    return TextHelper.s.removals;
  }
  if (item == RemodelingItem.suspendedCeiling) {
    return TextHelper.s.suspended_ceiling;
  }
  if (item == RemodelingItem.toiletReplacement) {
    return TextHelper.s.toilet_replacement;
  }
  if (item == RemodelingItem.pestControl) {
    return TextHelper.s.pest_control;
  }
  throw 'NoTitleCreatedForRemodelingItem';
}
