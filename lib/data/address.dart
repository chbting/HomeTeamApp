import 'package:easy_stepper/easy_stepper.dart';
import 'package:hometeam_client/generated/l10n.dart';

class Address {
  String? addressLine1;
  String addressLine2;
  String district;
  Region? region;

  Address(
      {this.addressLine1,
      this.addressLine2 = '',
      this.district = '',
      this.region});
}

enum District { aberdeen }

enum Region { newTerritories, kowloon, hongKong }

class RegionHelper {
  static String getName(BuildContext context, Region region) {
    switch (region) {
      case Region.newTerritories:
        return S.of(context).new_territories;
      case Region.kowloon:
        return S.of(context).kowloon;
      case Region.hongKong:
        return S.of(context).hong_kong;
    }
  }
}
