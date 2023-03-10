import 'package:easy_stepper/easy_stepper.dart';
import 'package:hometeam_client/generated/l10n.dart';

class Address {
  String addressLine1;
  String addressLine2;
  String district;
  String region;

  Address(
      {this.addressLine1 = '',
      this.addressLine2 = '',
      this.district = '',
      this.region = ''});

  // factory Address.fromJson(Map<String, dynamic> json) =>
  //     _$Address(json);
  //
  // Map<String, dynamic> toJson() => _$Address(this);

  @override
  String toString() {
    var s =
        addressLine1.isNotEmpty ? '$addressLine1,$addressLine2' : addressLine2;
    s += ',$district,$region';
    return s;
  }

  static List<String> getRegions(BuildContext context) {
    return [
      S.of(context).new_territories,
      S.of(context).kowloon,
      S.of(context).hong_kong
    ];
  }
}
