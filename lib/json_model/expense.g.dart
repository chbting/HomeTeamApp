// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseData _$ExpenseDataFromJson(Map<String, dynamic> json) => ExpenseData(
      landlordPaid: json['landlordPaid'] as bool,
      negotiable: json['negotiable'] as bool? ?? true,
      show: json['show'] as bool? ?? true,
    );

Map<String, dynamic> _$ExpenseDataToJson(ExpenseData instance) =>
    <String, dynamic>{
      'landlordPaid': instance.landlordPaid,
      'negotiable': instance.negotiable,
      'show': instance.show,
    };
