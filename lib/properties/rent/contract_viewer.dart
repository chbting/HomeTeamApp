import 'package:flutter/material.dart';
import 'package:tner_client/properties/rent/contract_broker.dart';
import 'package:tner_client/properties/rent/contract_offer_data.dart';
import 'package:tner_client/generated/l10n.dart';

class ContractViewerScreen extends StatefulWidget {
  const ContractViewerScreen({Key? key, required this.offer}) : super(key: key);

  final ContractOffer offer;

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
              child: Text(
                S.of(context).review_before_submission,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: Theme.of(context).textTheme.caption!.color
                )
              )),
          Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(S.of(context)
                    .property_visit_agreement_content)), //todo adjust the contract according to the offer
          )
        ]);
  }
}
