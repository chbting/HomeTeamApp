import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tner_client/properties/rent/contract_offer_data.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/text_helper.dart';

class ContractAdjusterScreen extends StatefulWidget {
  const ContractAdjusterScreen(
      {Key? key, required this.offer, required this.adjusterFormKey})
      : super(key: key);

  final ContractOffer offer;
  final GlobalKey<FormState> adjusterFormKey;

  @override
  State<StatefulWidget> createState() => ContractAdjusterScreenState();
}

class ContractAdjusterScreenState extends State<ContractAdjusterScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: false,
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
      children: [
        Card(
          child: ListTile(
            leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Icon(Icons.place)]),
            title: Text(TextHelper.appLocalizations.property_address,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
              '${widget.offer.property.address}',
              style: AppTheme.getCardBodyTextStyle(context),
            ),
            isThreeLine: true, //todo address format
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: widget.adjusterFormKey,
                child: Wrap(
                  children: [
                    TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        initialValue: '${widget.offer.property.monthlyRent}',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        // todo format to money $50,000
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            icon: const Icon(Icons.attach_money),
                            labelText:
                                TextHelper.appLocalizations.monthly_rent),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return TextHelper
                                .appLocalizations.please_put_in_a_valid_amount;
                          } else {
                            widget.offer.offeredMonthlyRent = int.parse(value);
                            return null;
                          }
                        }),
                    Container(height: 16.0),
                    TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        initialValue: '${widget.offer.property.deposit}',
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            icon: const Icon(Icons.savings),
                            labelText: TextHelper.appLocalizations.deposit),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return TextHelper
                                .appLocalizations.please_put_in_a_valid_amount;
                          } else {
                            widget.offer.offeredDeposit = int.parse(value);
                            return null;
                          }
                        }),
                    Container(height: 16.0),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Text(
                          TextHelper.appLocalizations.lease_length,
                          style: Theme.of(context).textTheme.subtitle1,
                        )),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      icon: const Icon(Icons.calendar_today),
                                      labelText: TextHelper
                                          .appLocalizations.start_date),
                                  onChanged: (value) {
                                    //widget.offer.startDate = value;
                                  })),
                        ),
                        Container(width: 16.0),
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      border: const OutlineInputBorder(),
                                      icon: const Icon(Icons.calendar_today),
                                      labelText:
                                          TextHelper.appLocalizations.end_date),
                                  onChanged: (value) {
                                    //widget.offer.endDate = value;
                                  })),
                        ),
                      ],
                    )
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
