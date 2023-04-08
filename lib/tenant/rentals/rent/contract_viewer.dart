import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_broker.dart';
import 'package:hometeam_client/json_model/contract_bid.dart';

class ContractViewerScreen extends StatefulWidget {
  const ContractViewerScreen({Key? key, required this.offer}) : super(key: key);

  final ContractBid offer;

  @override
  State<StatefulWidget> createState() => ContractViewerScreenState();
}

class ContractViewerScreenState extends State<ContractViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        // note: ListView has 4.0 internal padding on all sides
        padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: ContractBrokerScreen.stepTitleBarHeight - 4.0,
            bottom: ContractBrokerScreen.bottomButtonContainerHeight - 4.0),
        primary: false,
        children: [
          Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(S.of(context).review_before_submission,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).textTheme.bodySmall!.color))),
          Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(S
                    .of(context)
                    .property_visit_agreement_content)), //todo adjust the contract according to the offer
          )
        ]);
  }
}