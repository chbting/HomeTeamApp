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
      ..settings = (json['settings'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$TermsItemEnumMap, k),
            TermsItemSettings.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$ListingToJson(Listing instance) => <String, dynamic>{
      'id': instance.id,
      'propertyId': instance.propertyId,
      'title': instance.title,
      'terms': instance.terms,
      'settings':
          instance.settings.map((k, e) => MapEntry(_$TermsItemEnumMap[k]!, e)),
    };

const _$TermsItemEnumMap = {
  TermsItem.rent: 'rent',
  TermsItem.deposit: 'deposit',
  TermsItem.leasePeriod: 'leasePeriod',
  TermsItem.gracePeriod: 'gracePeriod',
  TermsItem.terminationRight: 'terminationRight',
  TermsItem.earliestTerminationDate: 'earliestTerminationDate',
  TermsItem.daysNoticeBeforeTermination: 'daysNoticeBeforeTermination',
  TermsItem.structure: 'structure',
  TermsItem.fixture: 'fixture',
  TermsItem.electricalAppliances: 'electricalAppliances',
  TermsItem.furniture: 'furniture',
  TermsItem.water: 'water',
  TermsItem.electricity: 'electricity',
  TermsItem.gas: 'gas',
  TermsItem.rates: 'rates',
  TermsItem.management: 'management',
};
