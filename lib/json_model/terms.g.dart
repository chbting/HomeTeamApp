// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Terms _$TermsFromJson(Map<String, dynamic> json) => Terms(
      propertyId: json['propertyId'] as int,
      rent: json['rent'] as int? ?? -1,
      deposit: json['deposit'] as int? ?? -1,
      rentNegotiable: json['rentNegotiable'] as bool? ?? true,
      depositNegotiable: json['depositNegotiable'] as bool? ?? false,
      earliestStartDate: json['earliestStartDate'] == null
          ? null
          : DateTime.parse(json['earliestStartDate'] as String),
      latestStartDate: json['latestStartDate'] == null
          ? null
          : DateTime.parse(json['latestStartDate'] as String),
      showLatestStartDate: json['showLatestStartDate'] as bool? ?? false,
      leaseLength: json['leaseLength'] == null
          ? null
          : DateTime.parse(json['leaseLength'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      gracePeriodStart: json['gracePeriodStart'] == null
          ? null
          : DateTime.parse(json['gracePeriodStart'] as String),
      gracePeriodEnd: json['gracePeriodEnd'] == null
          ? null
          : DateTime.parse(json['gracePeriodEnd'] as String),
      showGracePeriod: json['showGracePeriod'] as bool? ?? false,
      gracePeriodNegotiable: json['gracePeriodNegotiable'] as bool? ?? false,
      terminationRight:
          $enumDecodeNullable(_$PartyTypeEnumMap, json['terminationRight']) ??
              PartyType.both,
      terminationRightStartDate: json['terminationRightStartDate'] == null
          ? null
          : DateTime.parse(json['terminationRightStartDate'] as String),
      terminationNotificationPeriod:
          json['terminationNotificationPeriod'] as int? ?? -1,
    )..expenses = (json['expenses'] as List<dynamic>)
        .map((e) => Expense.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$TermsToJson(Terms instance) => <String, dynamic>{
      'propertyId': instance.propertyId,
      'rent': instance.rent,
      'deposit': instance.deposit,
      'rentNegotiable': instance.rentNegotiable,
      'depositNegotiable': instance.depositNegotiable,
      'earliestStartDate': instance.earliestStartDate.toIso8601String(),
      'latestStartDate': instance.latestStartDate?.toIso8601String(),
      'showLatestStartDate': instance.showLatestStartDate,
      'leaseLength': instance.leaseLength?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'gracePeriodStart': instance.gracePeriodStart?.toIso8601String(),
      'gracePeriodEnd': instance.gracePeriodEnd?.toIso8601String(),
      'showGracePeriod': instance.showGracePeriod,
      'gracePeriodNegotiable': instance.gracePeriodNegotiable,
      'terminationRight': _$PartyTypeEnumMap[instance.terminationRight]!,
      'terminationRightStartDate':
          instance.terminationRightStartDate.toIso8601String(),
      'terminationNotificationPeriod': instance.terminationNotificationPeriod,
      'expenses': instance.expenses,
    };

const _$PartyTypeEnumMap = {
  PartyType.landlord: 'landlord',
  PartyType.tenant: 'tenant',
  PartyType.both: 'both',
};
