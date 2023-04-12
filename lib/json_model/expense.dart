import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense.g.dart';

@JsonSerializable()
class Expense {
  ExpenseType type;
  bool landlordPay;
  bool negotiable;
  bool show;

  Expense(
      {required this.type,
      required this.landlordPay,
      this.negotiable = true,
      this.show = true});

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseToJson(this);
}

enum ExpenseType {
  structure,
  fixture,
  furniture,
  water,
  electricity,
  gas,
  rates,
  management
}

class ExpenseHelper {
  static getName(BuildContext context, ExpenseType type) {
    switch (type) {
      case ExpenseType.structure:
        return S.of(context).structure;
      case ExpenseType.fixture:
        return S.of(context).fixture;
      case ExpenseType.furniture:
        return S.of(context).furniture;
      case ExpenseType.water:
        return S.of(context).bill_water;
      case ExpenseType.electricity:
        return S.of(context).bill_electricity;
      case ExpenseType.gas:
        return S.of(context).bill_gas;
      case ExpenseType.rates:
        return S.of(context).bill_rates;
      case ExpenseType.management:
        return S.of(context).bill_electricity;
    }
  }
}
