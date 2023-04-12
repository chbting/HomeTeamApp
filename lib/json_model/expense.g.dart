// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense(
      type: $enumDecode(_$ExpenseTypeEnumMap, json['type']),
      landlordPay: json['landlordPay'] as bool,
      negotiable: json['negotiable'] as bool? ?? true,
      show: json['show'] as bool? ?? true,
    );

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'type': _$ExpenseTypeEnumMap[instance.type]!,
      'landlordPay': instance.landlordPay,
      'negotiable': instance.negotiable,
      'show': instance.show,
    };

const _$ExpenseTypeEnumMap = {
  ExpenseType.structure: 'structure',
  ExpenseType.fixture: 'fixture',
  ExpenseType.furniture: 'furniture',
  ExpenseType.water: 'water',
  ExpenseType.electricity: 'electricity',
  ExpenseType.gas: 'gas',
  ExpenseType.rates: 'rates',
  ExpenseType.management: 'management',
};
