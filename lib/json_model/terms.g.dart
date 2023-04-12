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
      latestStartDate: json['latestStartDate'] == null
          ? null
          : DateTime.parse(json['latestStartDate'] as String),
      showLatestStartDate: json['showLatestStartDate'] as bool? ?? false,
      leaseLength: json['leaseLength'] == null
          ? null
          : DateTime.parse(json['leaseLength'] as String),
      leaseEndDate: json['leaseEndDate'] == null
          ? null
          : DateTime.parse(json['leaseEndDate'] as String),
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
    )
      ..startDate = DateTime.parse(json['startDate'] as String)
      ..expenses = (json['expenses'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$ExpenseEnumMap, k),
            ExpenseData.fromJson(e as Map<String, dynamic>)),
      );

Map<String, dynamic> _$TermsToJson(Terms instance) => <String, dynamic>{
      'propertyId': instance.propertyId,
      'rent': instance.rent,
      'deposit': instance.deposit,
      'rentNegotiable': instance.rentNegotiable,
      'depositNegotiable': instance.depositNegotiable,
      'startDate': instance.startDate.toIso8601String(),
      'latestStartDate': instance.latestStartDate?.toIso8601String(),
      'showLatestStartDate': instance.showLatestStartDate,
      'leaseLength': instance.leaseLength?.toIso8601String(),
      'leaseEndDate': instance.leaseEndDate?.toIso8601String(),
      'gracePeriodStart': instance.gracePeriodStart?.toIso8601String(),
      'gracePeriodEnd': instance.gracePeriodEnd?.toIso8601String(),
      'showGracePeriod': instance.showGracePeriod,
      'gracePeriodNegotiable': instance.gracePeriodNegotiable,
      'terminationRight': _$PartyTypeEnumMap[instance.terminationRight]!,
      'terminationRightStartDate':
          instance.terminationRightStartDate.toIso8601String(),
      'terminationNotificationPeriod': instance.terminationNotificationPeriod,
      'expenses':
          instance.expenses.map((k, e) => MapEntry(_$ExpenseEnumMap[k]!, e)),
    };

const _$PartyTypeEnumMap = {
  PartyType.landlord: 'landlord',
  PartyType.tenant: 'tenant',
  PartyType.both: 'both',
};

const _$ExpenseEnumMap = {
  Expense.structure: 'structure',
  Expense.fixture: 'fixture',
  Expense.furniture: 'furniture',
  Expense.water: 'water',
  Expense.electricity: 'electricity',
  Expense.gas: 'gas',
  Expense.rates: 'rates',
  Expense.management: 'management',
};
