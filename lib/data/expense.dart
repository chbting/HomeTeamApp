import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';

enum Expense {
  structure,
  fixture,
  furniture,
  electricalAppliances,
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
      case Expense.electricalAppliances:
        return S.of(context).electrical_appliances;
      case Expense.water:
        return S.of(context).bill_water;
      case Expense.electricity:
        return S.of(context).bill_electricity;
      case Expense.gas:
        return S.of(context).bill_gas;
      case Expense.rates:
        return S.of(context).bill_rates;
      case Expense.management:
        return S.of(context).bill_management;
    }
  }

  static bool isPaidByLandlordDefault(Expense type) {
    switch (type) {
      case Expense.structure:
        return true;
      case Expense.fixture:
        return true;
      case Expense.furniture:
        return true;
      case Expense.electricalAppliances:
        return true;
      case Expense.water:
        return false;
      case Expense.electricity:
        return false;
      case Expense.gas:
        return false;
      case Expense.rates:
        return true;
      case Expense.management:
        return true;
    }
  }
}
