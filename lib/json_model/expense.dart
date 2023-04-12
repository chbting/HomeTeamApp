import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense.g.dart';

@JsonSerializable()
class ExpenseData {
  bool landlordPaid;
  bool negotiable;
  bool show;

  ExpenseData(
      {required this.landlordPaid,
      this.negotiable = true,
      this.show = true});

  factory ExpenseData.fromJson(Map<String, dynamic> json) =>
      _$ExpenseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseDataToJson(this);
}

enum Expense {
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
  static getName(BuildContext context, Expense type) {
    switch (type) {
      case Expense.structure:
        return S.of(context).structure;
      case Expense.fixture:
        return S.of(context).fixture;
      case Expense.furniture:
        return S.of(context).furniture;
      case Expense.water:
        return S.of(context).bill_water;
      case Expense.electricity:
        return S.of(context).bill_electricity;
      case Expense.gas:
        return S.of(context).bill_gas;
      case Expense.rates:
        return S.of(context).bill_rates;
      case Expense.management:
        return S.of(context).bill_electricity;
    }
  }
}
