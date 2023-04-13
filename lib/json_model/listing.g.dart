// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Listing _$ListingFromJson(Map<String, dynamic> json) => Listing(
      propertyId: json['propertyId'] as int,
      title: json['title'] as String,
      terms: json['terms'] == null
          ? null
          : Terms.fromJson(json['terms'] as Map<String, dynamic>),
    )
      ..id = json['id'] as int
      ..items = (json['items'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$TermsItemEnumMap, k),
            TermsItemSettings.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$ListingToJson(Listing instance) => <String, dynamic>{
      'id': instance.id,
      'propertyId': instance.propertyId,
      'title': instance.title,
      'terms': instance.terms,
      'items':
          instance.items.map((k, e) => MapEntry(_$TermsItemEnumMap[k]!, e)),
    };

const _$TermsItemEnumMap = {
  TermsItem.rent: 'rent',
  TermsItem.deposit: 'deposit',
  TermsItem.earliestStartDate: 'earliestStartDate',
  TermsItem.latestStartDate: 'latestStartDate',
  TermsItem.leaseLength: 'leaseLength',
  TermsItem.leaseEndDate: 'leaseEndDate',
  TermsItem.gracePeriod: 'gracePeriod',
  TermsItem.terminationRight: 'terminationRight',
  TermsItem.terminationRightStartDate: 'terminationRightStartDate',
  TermsItem.terminationNotificationPeriod: 'terminationNotificationPeriod',
};

TermsItemSettings _$TermsItemSettingsFromJson(Map<String, dynamic> json) =>
    TermsItemSettings(
      negotiable: json['negotiable'] as bool,
      showToTenant: json['showToTenant'] as bool,
      showToTenantLocked: json['showToTenantLocked'] as bool,
    );

Map<String, dynamic> _$TermsItemSettingsToJson(TermsItemSettings instance) =>
    <String, dynamic>{
      'negotiable': instance.negotiable,
      'showToTenant': instance.showToTenant,
      'showToTenantLocked': instance.showToTenantLocked,
    };
