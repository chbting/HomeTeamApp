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
  Map<TermsItem, TermsItemSettings> items;

  Listing({required this.propertyId, required this.title, Terms? terms})
      : id = propertyId,
        terms = terms ?? Terms(propertyId: propertyId),
        items = {
          TermsItem.rent: TermsItemSettings(
              negotiable: true, showToTenant: true, showToTenantLocked: true)
        };

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
  terminationRightStartDate,
  terminationNotificationPeriod
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
