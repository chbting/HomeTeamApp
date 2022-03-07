import 'package:flutter/material.dart';
import 'package:tner_client/properties/rent/contract_offer_data.dart';

class ContractViewerScreen extends StatefulWidget {
  const ContractViewerScreen({Key? key, required this.offer})
      : super(key: key);

  final ContractOffer offer;

  @override
  State<StatefulWidget> createState() => ContractViewerScreenState();
}

class ContractViewerScreenState extends State<ContractViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        primary: false,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: []);
  }
}