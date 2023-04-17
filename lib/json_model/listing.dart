import 'package:hometeam_client/debug.dart';
import 'package:hometeam_client/json_model/terms.dart';
import 'package:json_annotation/json_annotation.dart';

part 'listing.g.dart';

@JsonSerializable()
class Listing {
  int id;
  int propertyId;
  String title;
  Terms terms;
  Map<TermsItem, TermsItemSettings> settings = {};

  Listing({required this.propertyId, required this.title, Terms? terms})
      : id = propertyId,
        terms = terms ?? Terms(propertyId: propertyId) {
    for (var item in TermsItem.values) {
      settings[item] = TermsItemHelper.getDefaultSettings(item);
    }
  }

  factory Listing.fromJson(Map<String, dynamic> json) =>
      _$ListingFromJson(json);

  Map<String, dynamic> toJson() => _$ListingToJson(this);
}

enum TermsItem {
  rent,
  deposit,
  earliestStartDate,
  latestStartDate,
  leaseLength,
  leaseEndDate,
  gracePeriod,
  terminationRight,
  earliestTerminationDate,
  terminationNotice,
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
      case TermsItem.earliestStartDate:
      case TermsItem.leaseLength:
      case TermsItem.leaseEndDate:
        return TermsItemSettings(
            negotiable: true, showToTenant: true, showToTenantLocked: true);
      case TermsItem.latestStartDate:
      case TermsItem.gracePeriod:
      case TermsItem.terminationRight:
      case TermsItem.earliestTerminationDate:
      case TermsItem.terminationNotice:
        return TermsItemSettings(
            negotiable: true, showToTenant: false, showToTenantLocked: false);
      case TermsItem.structure:
      case TermsItem.fixture:
      case TermsItem.furniture:
      case TermsItem.water:
      case TermsItem.electricity:
      case TermsItem.gas:
      case TermsItem.rates:
      case TermsItem.management:
      return TermsItemSettings(
          negotiable: false, showToTenant: true, showToTenantLocked: false);
    }
  }
}

@JsonSerializable()
class TermsItemSettings {
  bool negotiable;
  bool showToTenant;
  final bool showToTenantLocked;

  TermsItemSettings(
      {required this.negotiable,
      required this.showToTenant,
      required this.showToTenantLocked});

  factory TermsItemSettings.fromJson(Map<String, dynamic> json) =>
      _$TermsItemSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$TermsItemSettingsToJson(this);
}

class ListingHelper {
  static Listing getFromId(int id) {
    //todo temporary solution
    return getSampleListing().firstWhere((listing) => listing.id == id);
  }
}
