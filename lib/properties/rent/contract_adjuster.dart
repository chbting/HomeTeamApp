import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        const Divider(thickness: 1.0),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Card(
              child: SizedBox(
                  // 16.0 on one side + 4.0 card margin
                  width: MediaQuery.of(context).size.width / 2 - 20.0,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 16.0),
                      child: TextField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          // todo comma, dollar sign
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              icon: const Icon(Icons.savings),
                              labelText: TextHelper.appLocalizations.deposit),
                          onChanged: (value) {
                            value.isEmpty
                                ? widget.offer.offeredDeposit = 0
                                : widget.offer.offeredDeposit =
                                    int.parse(value);
                          })))),
          Card(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 20.0,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 16.0),
                      child: TextField(
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          // todo comma
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              icon: const Icon(Icons.attach_money),
                              labelText:
                                  TextHelper.appLocalizations.monthly_rent),
                          onChanged: (value) {
                            value.isEmpty
                                ? widget.offer.offeredMonthlyRent = 0
                                : widget.offer.offeredMonthlyRent =
                                    int.parse(value);
                          })))),
        ]),
        Card(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  TextHelper.appLocalizations.lease_length,
                  style: Theme.of(context).textTheme.subtitle1,
                )),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText:
                              TextHelper.appLocalizations.contract_start_date),
                          onChanged: (value) {
                            //widget.offer.startDate = value;
                          }),
                    ),
                    Container(width: 16.0),
                    Expanded(
                      child: TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText:
                              TextHelper.appLocalizations.contract_end_date),
                          onChanged: (value) {
                            //widget.offer.endDate = value;
                          }),
                    ),
                  ],
                )
          ]),
          // todo datePicker
        )
      ],
    );
  }
}
