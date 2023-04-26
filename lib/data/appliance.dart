enum Appliance {
  ac,
  washer,
  dryer,
  washerDryerCombo,
  waterHeater,
  fridge,
  stove,
  rangeHood
}

class ApplianceHelper {
  static getDefaultValue(Appliance appliance) {
    switch (appliance) {
      case Appliance.ac:
        return -1;
      case Appliance.washer:
      case Appliance.dryer:
      case Appliance.washerDryerCombo:
      case Appliance.fridge:
      case Appliance.stove:
      case Appliance.rangeHood:
        return false;
      case Appliance.waterHeater:
        return true;
    }
  }
}
