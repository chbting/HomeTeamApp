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

  static List<ImagingInstruction> getImagingInstructions(
      RemodelingItem item, BuildContext context) {
    switch (item) {
      case RemodelingItem.painting:
        return [ImagingInstruction('Put the instruction here',
            const AssetImage('assets/images/ac_instruction_1.gif'))];
      case RemodelingItem.wallCoverings:
        return [ImagingInstruction('Put the instruction here',
            const AssetImage('assets/images/ac_instruction_1.gif'))];
      case RemodelingItem.ac:
        return [
          ImagingInstruction(S.of(context).imaging_instruction_ac_1,
              const AssetImage('assets/images/ac_instruction_1.gif')),
          ImagingInstruction(S.of(context).imaging_instruction_ac_2,
              const AssetImage('assets/images/ac_instruction_2.gif')),
          ImagingInstruction(S.of(context).imaging_instruction_ac_3,
              const AssetImage('assets/images/ac_instruction_3.gif')),
        ];
      case RemodelingItem.removals:
        return [ImagingInstruction('Put the instruction here',
            const AssetImage('assets/images/ac_instruction_1.gif'))];
      case RemodelingItem.toiletReplacement:
        return [ImagingInstruction('Put the instruction here',
            const AssetImage('assets/images/ac_instruction_1.gif'))];
      default:
        return [];
    }
  }
}

/// The image size should be 500x500 px
class ImagingInstruction {
  String description;
  AssetImage image;

  ImagingInstruction(this.description, this.image);
}
