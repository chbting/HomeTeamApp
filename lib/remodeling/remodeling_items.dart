import 'package:flutter/widgets.dart';
import 'package:tner_client/generated/l10n.dart';

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
    return S.of(context).painting;
  }
  if (item == RemodelingItem.wallCoverings) {
    return S.of(context).wallcoverings;
  }
  if (item == RemodelingItem.ac) {
    return S.of(context).ac_window_type;
  }
  if (item == RemodelingItem.removals) {
    return S.of(context).removals;
  }
  if (item == RemodelingItem.suspendedCeiling) {
    return S.of(context).suspended_ceiling;
  }
  if (item == RemodelingItem.toiletReplacement) {
    return S.of(context).toilet_replacement;
  }
  if (item == RemodelingItem.pestControl) {
    return S.of(context).pest_control;
  }
  throw 'NoTitleCreatedForRemodelingItem';
}
