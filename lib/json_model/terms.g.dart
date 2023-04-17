// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Terms _$TermsFromJson(Map<String, dynamic> json) => Terms(
      propertyId: json['propertyId'] as int,
      rent: json['rent'] as int? ?? -1,
      deposit: json['deposit'] as int? ?? -1,
      earliestStartDate: json['earliestStartDate'] == null
          ? null
          : DateTime.parse(json['earliestStartDate'] as String),
      latestStartDate: json['latestStartDate'] == null
          ? null
          : DateTime.parse(json['latestStartDate'] as String),
      leaseLength: json['leaseLength'] as int?,
      leaseEndDate: json['leaseEndDate'] == null
          ? null
          : DateTime.parse(json['leaseEndDate'] as String),
      gracePeriod: json['gracePeriod'] as int? ?? -1,
      terminationRight:
          $enumDecodeNullable(_$PartyTypeEnumMap, json['terminationRight']) ??
              PartyType.both,
      terminationRightStartDate: json['terminationRightStartDate'] == null
          ? null
          : DateTime.parse(json['terminationRightStartDate'] as String),
      terminationNotice:
          json['terminationNotificationPeriod'] as int? ?? -1,
    )..expenses = (json['expenses'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$ExpenseEnumMap, k), e as bool),
      );

Map<String, dynamic> _$TermsToJson(Terms instance) => <String, dynamic>{
      'propertyId': instance.propertyId,
      'rent': instance.rent,
      'deposit': instance.deposit,
      'earliestStartDate': instance.earliestStartDate.toIso8601String(),
      'latestStartDate': instance.latestStartDate?.toIso8601String(),
      'leaseLength': instance.leaseLength,
      'leaseEndDate': instance.leaseEndDate?.toIso8601String(),
      'gracePeriod': instance.gracePeriod,
      'terminationRight': _$PartyTypeEnumMap[instance.terminationRight]!,
      'terminationRightStartDate':
          instance.earliestTerminationDate.toIso8601String(),
      'terminationNotificationPeriod': instance.terminationNotice,
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
