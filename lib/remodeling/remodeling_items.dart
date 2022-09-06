import 'package:flutter/material.dart';
import 'package:tner_client/assets/custom_icons_icons.dart';
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

class RemodelingItemHelper {
  static String getItemName(RemodelingItem item, BuildContext context) {
    switch (item) {
      case RemodelingItem.painting:
        return S.of(context).painting;
      case RemodelingItem.wallCoverings:
        return S.of(context).wallcoverings;
      case RemodelingItem.ac:
        return S.of(context).ac_window_type;
      case RemodelingItem.removals:
        return S.of(context).removals;
      case RemodelingItem.suspendedCeiling:
        return S.of(context).suspended_ceiling;
      case RemodelingItem.toiletReplacement:
        return S.of(context).toilet_replacement;
      case RemodelingItem.pestControl:
        return S.of(context).pest_control;
    }
  }

  static IconData getIconData(RemodelingItem item) {
    switch (item) {
      case RemodelingItem.painting:
        return Icons.imagesearch_roller;
      case RemodelingItem.wallCoverings:
        return CustomIcons.wallcovering;
      case RemodelingItem.ac:
        return Icons.ac_unit;
      case RemodelingItem.removals:
        return Icons.delete_forever;
      case RemodelingItem.suspendedCeiling:
        return CustomIcons.suspendedCeiling;
      case RemodelingItem.toiletReplacement:
        return CustomIcons.toilet;
      case RemodelingItem.pestControl:
        return Icons.pest_control;
    }
  }

  static bool isPictureRequired(RemodelingItem item) {
    switch (item) {
      case RemodelingItem.painting:
        return true;
      case RemodelingItem.wallCoverings:
        return true;
      case RemodelingItem.ac:
        return true;
      case RemodelingItem.removals:
        return true;
      case RemodelingItem.suspendedCeiling:
        return false;
      case RemodelingItem.toiletReplacement:
        return true;
      case RemodelingItem.pestControl:
        return false;
    }
  }
}
