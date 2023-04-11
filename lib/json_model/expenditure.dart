import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expenditure.g.dart';

@JsonSerializable()
class Expenditure {
  ExpenditureType type;
  bool landlordPay;
  bool negotiable;
  bool hidden;

  Expenditure(
      {required this.type,
      required this.landlordPay,
      this.negotiable = true,
      this.hidden = false});

  factory Expenditure.fromJson(Map<String, dynamic> json) =>
      _$ExpenditureFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenditureToJson(this);
}

enum ExpenditureType {
  structure,
  fixture,
  furniture,
  water,
  electricity,
  gas,
  rates,
  management
}

class ExpenditureHelper {
  static getName(BuildContext context, ExpenditureType type) {
    switch (type) {
      case ExpenditureType.structure:
        return S.of(context).structure;
      case ExpenditureType.fixture:
        return S.of(context).fixture;
      case ExpenditureType.furniture:
        return S.of(context).furniture;
      case ExpenditureType.water:
        return S.of(context).bill_water;
      case ExpenditureType.electricity:
        return S.of(context).bill_electricity;
      case ExpenditureType.gas:
        return S.of(context).bill_gas;
      case ExpenditureType.rates:
        return S.of(context).bill_rates;
      case ExpenditureType.management:
        return S.of(context).bill_electricity;
    }
  }
}
