import 'package:flutter/material.dart';
import 'package:hometeam_client/json_model/contract_bid.dart';

class ContractBrokerInheritedData extends InheritedWidget {
  const ContractBrokerInheritedData({
    Key? key,
    required this.bid,
    required Widget child,
  }) : super(key: key, child: child);

  final ContractBid bid;

  static ContractBrokerInheritedData? of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ContractBrokerInheritedData>();

  @override
  bool updateShouldNotify(covariant ContractBrokerInheritedData oldWidget) {
    return false;
  }
}