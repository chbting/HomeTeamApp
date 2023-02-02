import 'package:flutter/material.dart';
import 'package:tner_client/assets/custom_icons_icons.dart';
import 'package:tner_client/generated/l10n.dart';

enum RemodelingType {
  painting,
  wallCoverings,
  ac,
  removals,
  suspendedCeiling,
  toiletReplacement,
  pestControl
}

class RemodelingItem {
  RemodelingType type;

  RemodelingItem(this.type);
}

class RemodelingPainting extends RemodelingItem {
  int paintArea;
  bool scrapeOldPaint;

  RemodelingPainting({this.paintArea = 0, this.scrapeOldPaint = false})
      : super(RemodelingType.painting);
}

class RemodelingWallCoverings extends RemodelingItem {
  int area;

  RemodelingWallCoverings({this.area = 0})
      : super(RemodelingType.wallCoverings);
}

class RemodelingAC extends RemodelingItem {
  //TODO params
  int? acCount;

  RemodelingAC() : super(RemodelingType.ac);
}

class RemodelingRemovals extends RemodelingItem {
  //TODO params
  RemodelingRemovals() : super(RemodelingType.removals);
}

class RemodelingSuspendedCeiling extends RemodelingItem {
  //TODO params
  RemodelingSuspendedCeiling() : super(RemodelingType.suspendedCeiling);
}

class RemodelingToiletReplacement extends RemodelingItem {
  //TODO params
  String? toiletType;

  RemodelingToiletReplacement() : super(RemodelingType.toiletReplacement);
}

class RemodelingPestControl extends RemodelingItem {
  //TODO params
  RemodelingPestControl() : super(RemodelingType.pestControl);
}

/// Helper class should ask for the RemodelingType, not RemodelingItem
class RemodelingTypeHelper {
  static String getItemName(RemodelingType type, BuildContext context) {
    switch (type) {
      case RemodelingType.painting:
        return S.of(context).painting;
      case RemodelingType.wallCoverings:
        return S.of(context).wallcoverings;
      case RemodelingType.ac:
        return S.of(context).ac_window_type;
      case RemodelingType.removals:
        return S.of(context).removals;
      case RemodelingType.suspendedCeiling:
        return S.of(context).suspended_ceiling;
      case RemodelingType.toiletReplacement:
        return S.of(context).toilet_replacement;
      case RemodelingType.pestControl:
        return S.of(context).pest_control;
    }
  }

  static IconData getIconData(RemodelingType type) {
    switch (type) {
      case RemodelingType.painting:
        return Icons.imagesearch_roller;
      case RemodelingType.wallCoverings:
        return CustomIcons.wallcovering;
      case RemodelingType.ac:
        return Icons.ac_unit;
      case RemodelingType.removals:
        return Icons.delete_forever;
      case RemodelingType.suspendedCeiling:
        return CustomIcons.suspendedCeiling;
      case RemodelingType.toiletReplacement:
        return CustomIcons.toilet;
      case RemodelingType.pestControl:
        return Icons.pest_control;
    }
  }

  static bool isPictureRequired(RemodelingType type) {
    switch (type) {
      case RemodelingType.painting:
        return true;
      case RemodelingType.wallCoverings:
        return true;
      case RemodelingType.ac:
        return true;
      case RemodelingType.removals:
        return true;
      case RemodelingType.suspendedCeiling:
        return false;
      case RemodelingType.toiletReplacement:
        return true;
      case RemodelingType.pestControl:
        return false;
    }
  }

  static List<ImagingInstruction> getImagingInstructions(
      RemodelingType type, BuildContext context) {
    switch (type) {
      case RemodelingType.painting:
        return [
          ImagingInstruction('Put the instruction here',
              const AssetImage('assets/images/ac_instruction_1.gif'))
        ];
      case RemodelingType.wallCoverings:
        return [
          ImagingInstruction('Put the instruction here',
              const AssetImage('assets/images/ac_instruction_1.gif'))
        ];
      case RemodelingType.ac:
        return [
          ImagingInstruction(S.of(context).imaging_instruction_ac_1,
              const AssetImage('assets/images/ac_instruction_1.gif')),
          ImagingInstruction(S.of(context).imaging_instruction_ac_2,
              const AssetImage('assets/images/ac_instruction_2.gif')),
          ImagingInstruction(S.of(context).imaging_instruction_ac_3,
              const AssetImage('assets/images/ac_instruction_3.gif')),
        ];
      case RemodelingType.removals:
        return [
          ImagingInstruction('Put the instruction here',
              const AssetImage('assets/images/ac_instruction_1.gif'))
        ];
      case RemodelingType.toiletReplacement:
        return [
          ImagingInstruction('Put the instruction here',
              const AssetImage('assets/images/ac_instruction_1.gif'))
        ];
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
