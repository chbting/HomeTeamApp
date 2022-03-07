import 'package:flutter/material.dart';
import 'package:tner_client/properties/rent/contract_offer_data.dart';
import 'package:tner_client/theme.dart';
import 'package:tner_client/utils/text_helper.dart';

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
        children: [
          Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(TextHelper.appLocalizations.property_address,
                  style: AppTheme.getCardTitleTextStyle(context)),
              subtitle: Text('${widget.offer.property.address}',
                  style: AppTheme.getCardBodyTextStyle(context)),
            ),
          ))
        ]);
  }
}
