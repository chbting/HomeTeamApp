import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';

enum Appliance {
  ac,
  waterHeater,
  washer,
  dryer,
  washerDryerCombo,
  fridge,
  stove,
  rangeHood
}

class ApplianceHelper {
  static getDefaultValue(Appliance appliance) {
    switch (appliance) {
      case Appliance.ac:
        return -1;
      case Appliance.waterHeater:
        return true;
      case Appliance.washer:
      case Appliance.dryer:
      case Appliance.washerDryerCombo:
      case Appliance.fridge:
      case Appliance.stove:
      case Appliance.rangeHood:
        return false;
    }
  }

  static String getName(BuildContext context, Appliance appliance) {
    switch (appliance) {
      case Appliance.ac:
        return S.of(context).ac;
      case Appliance.waterHeater:
        return S.of(context).water_heater;
      case Appliance.washer:
        return S.of(context).washer;
      case Appliance.dryer:
        return S.of(context).dryer;
      case Appliance.washerDryerCombo:
        return S.of(context).washer_dryer_combo_two_lines;
      case Appliance.fridge:
        return S.of(context).fridge;
      case Appliance.stove:
        return S.of(context).stove;
      case Appliance.rangeHood:
        return S.of(context).range_hood;
    }
  }

  static List<Appliance> valuesWithBoolValue() {
    var list = Appliance.values.toList();
    list.remove(Appliance.ac);
    return list;
  }
}
