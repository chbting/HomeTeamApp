// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expenditure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expenditure _$ExpenditureFromJson(Map<String, dynamic> json) => Expenditure(
      type: $enumDecode(_$ExpenditureTypeEnumMap, json['type']),
      landlordPay: json['landlordPay'] as bool,
      negotiable: json['negotiable'] as bool? ?? true,
      hidden: json['hidden'] as bool? ?? false,
    );

Map<String, dynamic> _$ExpenditureToJson(Expenditure instance) =>
    <String, dynamic>{
      'type': _$ExpenditureTypeEnumMap[instance.type]!,
      'landlordPay': instance.landlordPay,
      'negotiable': instance.negotiable,
      'hidden': instance.hidden,
    };

const _$ExpenditureTypeEnumMap = {
  ExpenditureType.structure: 'structure',
  ExpenditureType.fixture: 'fixture',
  ExpenditureType.furniture: 'furniture',
  ExpenditureType.water: 'water',
  ExpenditureType.electricity: 'electricity',
  ExpenditureType.gas: 'gas',
  ExpenditureType.rates: 'rates',
  ExpenditureType.management: 'management',
};
