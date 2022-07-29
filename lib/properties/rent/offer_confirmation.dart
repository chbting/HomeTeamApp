import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tner_client/properties/rent/contract_broker.dart';
import 'package:tner_client/properties/rent/contract_offer_data.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/client_data.dart';
import 'package:tner_client/utils/format.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';
import 'package:tner_client/utils/text_helper.dart';

class OfferConfirmationScreen extends StatelessWidget {
  const OfferConfirmationScreen({Key? key, required this.offer})
      : super(key: key);

  final ContractOffer offer;
  final double _leadSpacing = 56.0;
  final double _itemSpacing = 12.0; // Spacing between title-item pairs
  final double _listViewPadding = 16.0;
  final double _listViewInternalPadding =
      4.0; // note: ListView has 4.0 internal padding on all sides
  final double _cardPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    if (offer.client.firstName == null) {
      offer.client = getSampleClientData();
    } // todo debug line
    return ListView(
        primary: false,
        padding: EdgeInsets.only(
            left: _listViewPadding - _listViewInternalPadding,
            right: _listViewPadding - _listViewInternalPadding,
            top: ContractBrokerScreen.stepTitleBarHeight -
                _listViewInternalPadding,
            bottom: ContractBrokerScreen.bottomButtonContainerHeight -
                _listViewInternalPadding),
        children: [
          Card(
            child: ListTile(
              leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Icon(Icons.place)]),
              title: Text(TextHelper.s.property_address,
                  style: AppTheme.getCardTitleTextStyle(context)),
              subtitle: Text(
                '${offer.property.address}',
                style: AppTheme.getCardBodyTextStyle(context),
              ),
              isThreeLine: true, //todo address format
            ),
          ),
          Card(
              child: Padding(
                  padding: EdgeInsets.all(_cardPadding),
                  child: Row(
                    children: [
                      SizedBox(
                          width: _leadSpacing,
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.local_offer))),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(TextHelper.s.lease_terms,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Container(height: _itemSpacing),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _getPricingColumn(context, ClientType.tenant),
                              _getPricingColumn(context, ClientType.landLord)
                            ],
                          ),
                          Container(height: _itemSpacing),
                          const Divider(thickness: 1.0),
                          Text(TextHelper.s.lease_period,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Text(
                              '${DateFormat(Format.date).format(offer.offeredStartDate!)} '
                              '- ${DateFormat(Format.date).format(offer.offeredEndDate!)}',
                              style: AppTheme.getCardBodyTextStyle(context)),
                          Container(height: _itemSpacing),
                          Text(TextHelper.s.notes,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Text(
                              offer.notes == null
                                  ? '-'
                                  : offer.notes!.isEmpty
                                      ? '-'
                                      : offer.notes!,
                              style: AppTheme.getCardBodyTextStyle(context)),
                        ],
                      ))
                    ],
                  ))),
          Card(
              child: Padding(
                  padding: EdgeInsets.all(_cardPadding),
                  child: Row(
                    children: [
                      SizedBox(
                          width: _leadSpacing,
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.person))),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(TextHelper.s.tenant_info,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Container(height: _itemSpacing),
                          Text(TextHelper.s.name,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Text(_getTenantName(),
                              style: AppTheme.getCardBodyTextStyle(context)),
                          Container(height: _itemSpacing),
                          Text(TextHelper.s.id_card_number,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Text(offer.client.idCardNumber ?? '',
                              style: AppTheme.getCardBodyTextStyle(context)),
                          Container(height: _itemSpacing),
                          Text(TextHelper.s.contact_number,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Text(offer.client.phoneNumber ?? '',
                              style: AppTheme.getCardBodyTextStyle(context)),
                          Container(height: _itemSpacing),
                          Text(TextHelper.s.mailing_address,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Text(offer.client.addressLine1!,
                              style: AppTheme.getCardBodyTextStyle(context)),
                          Text(offer.client.addressLine2!,
                              style: AppTheme.getCardBodyTextStyle(context)),
                          Text(offer.client.district!,
                              style: AppTheme.getCardBodyTextStyle(context)),
                          Text(offer.client.region!,
                              style: AppTheme.getCardBodyTextStyle(context))
                        ],
                      )
                    ],
                  ))),
        ]);
  }

  Widget _getPricingColumn(BuildContext context, ClientType clientType) {
    String title;
    int monthlyRent, deposit;
    bool water, electricity, gas, rates, management;

    switch (clientType) {
      case ClientType.tenant:
        title = TextHelper.s.offered;
        monthlyRent = offer.offeredMonthlyRent!;
        deposit = offer.offeredDeposit!;
        water = offer.offeredWater;
        electricity = offer.offeredElectricity;
        gas = offer.offeredGas;
        rates = offer.offeredRates;
        management = offer.offeredManagement;
        break;
      case ClientType.landLord:
        title = TextHelper.s.original;
        monthlyRent = offer.property.monthlyRent!;
        deposit = offer.property.deposit!;
        water = offer.property.water;
        electricity = offer.property.electricity;
        gas = offer.property.gas;
        rates = offer.property.rates;
        management = offer.property.management;
        break;
    }

    return SizedBox(
        width: MediaQuery.of(context).size.width / 2 -
            _listViewPadding -
            _cardPadding -
            _leadSpacing / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headline6),
            Container(height: _itemSpacing),
            Text(TextHelper.s.monthly_rent,
                style: AppTheme.getCardTitleTextStyle(context)),
            Text(Format.currency.format(monthlyRent),
                style: AppTheme.getCardBodyTextStyle(context)),
            Container(height: _itemSpacing),
            Text(TextHelper.s.deposit,
                style: AppTheme.getCardTitleTextStyle(context)),
            Text(Format.currency.format(deposit),
                style: AppTheme.getCardBodyTextStyle(context)),
            Container(height: _itemSpacing),
            Text(TextHelper.s.tenant_paid_fees_colon,
                style: AppTheme.getCardTitleTextStyle(context)),
            _getFeeItem(context, TextHelper.s.bill_water, water),
            _getFeeItem(context, TextHelper.s.bill_electricity,
                electricity),
            _getFeeItem(context, TextHelper.s.bill_gas, gas),
            _getFeeItem(context, TextHelper.s.bill_rates, rates),
            _getFeeItem(context, TextHelper.s.bill_management,
                management),
          ],
        ));
  }

  Widget _getFeeItem(BuildContext context, String title, bool show) {
    return Container(
        child: show
            ? Text('-$title', style: AppTheme.getCardBodyTextStyle(context))
            : null);
  }

  String _getTenantName() {
    if (SharedPreferencesHelper().getLocale().languageCode == 'zh') {
      return '${offer.client.lastName}${offer.client.firstName}';
    } else {
      return '${offer.client.lastName}, ${offer.client.firstName}';
    }
  }
}

enum ClientType { tenant, landLord }
