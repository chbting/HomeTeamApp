import 'package:json_annotation/json_annotation.dart';

part 'terms_item.g.dart';

@JsonSerializable()
class TermsItemSettings {
  bool negotiable;
  bool? showToTenant;

  TermsItemSettings({required this.negotiable, this.showToTenant});

  factory TermsItemSettings.fromJson(Map<String, dynamic> json) =>
      _$TermsItemSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$TermsItemSettingsToJson(this);
}

enum TermsItem {
  rent,
  deposit,
  leasePeriod,
  gracePeriod,
  terminationRight,
  earliestTerminationDate,
  daysNoticeBeforeTermination,
  structure,
  fixture,
  furniture,
  water,
  electricity,
  gas,
  rates,
  management
}

class TermsItemHelper {
  static TermsItemSettings getDefaultSettings(TermsItem item) {
    switch (item) {
      case TermsItem.rent:
      case TermsItem.deposit:
      case TermsItem.leasePeriod:
        return TermsItemSettings(negotiable: true);
      case TermsItem.gracePeriod:
      case TermsItem.terminationRight:
      case TermsItem.earliestTerminationDate:
      case TermsItem.daysNoticeBeforeTermination:
        return TermsItemSettings(negotiable: true, showToTenant: false);
      case TermsItem.structure:
      case TermsItem.fixture:
      case TermsItem.furniture:
      case TermsItem.water:
      case TermsItem.electricity:
      case TermsItem.gas:
      case TermsItem.rates:
      case TermsItem.management:
        return TermsItemSettings(negotiable: false, showToTenant: true);
    }
  }
}
