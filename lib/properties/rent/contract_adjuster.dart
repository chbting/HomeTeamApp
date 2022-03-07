import 'package:flutter/material.dart';
import 'package:tner_client/properties/rent/contract_offer_data.dart';

class ContractAdjusterScreen extends StatefulWidget {
  const ContractAdjusterScreen({Key? key, required this.offer})
      : super(key: key);

  final ContractOffer offer;

  @override
  State<StatefulWidget> createState() => ContractAdjusterScreenState();
}

class ContractAdjusterScreenState extends State<ContractAdjusterScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        primary: false,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        children: []);
  }
}
