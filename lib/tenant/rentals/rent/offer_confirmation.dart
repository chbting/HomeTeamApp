import 'package:flutter/material.dart';
import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/json_model/tenant.dart';
import 'package:hometeam_client/debug.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_broker.dart';
import 'package:hometeam_client/json_model/contract_bid.dart';
import 'package:hometeam_client/ui/theme.dart';
import 'package:hometeam_client/utils/format.dart';
import 'package:hometeam_client/utils/shared_preferences_helper.dart';
import 'package:intl/intl.dart';

class OfferConfirmationScreen extends StatelessWidget {
  const OfferConfirmationScreen({Key? key, required this.property, required this.bid})
      : super(key: key);

  final Property property;
  final ContractBid bid;
  final double _leadSpacing = 56.0;
  final double _itemSpacing = 12.0; // Spacing between title-item pairs
  final double _listViewPadding = 16.0;
  final double _listViewInternalPadding =
      4.0; // note: ListView has 4.0 internal padding on all sides
  final double _cardPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    if (bid.tenant.firstName.isEmpty) {
      bid.tenant = getSampleClientData();
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
              leading: const Icon(Icons.place),
              title: Text(S.of(context).property_address,
                  style: AppTheme.getCardTitleTextStyle(context)),
              subtitle: Text(
                '${property.address}',
                style: AppTheme.getCardBodyTextStyle(context),
              ),
              isThreeLine: true, //todo address format
            ),
          ),
          Card(
              child: Padding(
                  padding: EdgeInsets.all(_cardPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          Text(S.of(context).lease_terms,
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
                          Text(S.of(context).lease_period,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Text(
                              '${DateFormat(Format.date).format(bid.contract.startDate!)} '
                                  '- ${DateFormat(Format.date).format(bid.contract.endDate!)}',
                              style: AppTheme.getCardBodyTextStyle(context)),
                          Container(height: _itemSpacing),
                          Text(S.of(context).notes,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Text(
                              bid.notes.isEmpty
                                      ? '-'
                                  : bid.notes,
                              style: AppTheme.getCardBodyTextStyle(context)),
                        ],
                      ))
                    ],
                  ))),
          Card(
              child: Padding(
                  padding: EdgeInsets.all(_cardPadding),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          width: _leadSpacing,
                          child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.person))),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.of(context).tenant_info,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Container(height: _itemSpacing),
                          Text(S.of(context).name,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Text(_getTenantName(),
                              style: AppTheme.getCardBodyTextStyle(context)),
                          Container(height: _itemSpacing),
                          Text(S.of(context).id_card_number,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Text(bid.tenant.idCardNumber,
                              style: AppTheme.getCardBodyTextStyle(context)),
                          Container(height: _itemSpacing),
                          Text(S.of(context).contact_number,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Text(bid.tenant.phoneNumber,
                              style: AppTheme.getCardBodyTextStyle(context)),
                          Container(height: _itemSpacing),
                          Text(S.of(context).mailing_address,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Text(bid.tenant.address.addressLine1,
                              style: AppTheme.getCardBodyTextStyle(context)),
                          Text(bid.tenant.address.addressLine2,
                              style: AppTheme.getCardBodyTextStyle(context)),
                          Text(bid.tenant.address.district,
                              style: AppTheme.getCardBodyTextStyle(context)),
                          Text(bid.tenant.address.region,
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
        title = S.of(context).offered;
        monthlyRent = bid.contract.monthlyRent;
        deposit = bid.contract.deposit;
        water = bid.contract.waterRequired;
        electricity = bid.contract.electricityRequired;
        gas = bid.contract.gasRequired;
        rates = bid.contract.ratesRequired;
        management = bid.contract.managementRequired;
        break;
      case ClientType.landLord:
        title = S.of(context).original;
        monthlyRent = property.contract.monthlyRent;
        deposit = property.contract.deposit;
        water = property.contract.waterRequired;
        electricity = property.contract.electricityRequired;
        gas = property.contract.gasRequired;
        rates = property.contract.ratesRequired;
        management = property.contract.managementRequired;
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
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            Container(height: _itemSpacing),
            Text(S.of(context).monthly_rent,
                style: AppTheme.getCardTitleTextStyle(context)),
            Text(Format.currency.format(monthlyRent),
                style: AppTheme.getCardBodyTextStyle(context)),
            Container(height: _itemSpacing),
            Text(S.of(context).deposit,
                style: AppTheme.getCardTitleTextStyle(context)),
            Text(Format.currency.format(deposit),
                style: AppTheme.getCardBodyTextStyle(context)),
            Container(height: _itemSpacing),
            Text(S.of(context).tenant_paid_fees_colon,
                style: AppTheme.getCardTitleTextStyle(context)),
            _getFeeItem(context, S.of(context).bill_water, water),
            _getFeeItem(context, S.of(context).bill_electricity, electricity),
            _getFeeItem(context, S.of(context).bill_gas, gas),
            _getFeeItem(context, S.of(context).bill_rates, rates),
            _getFeeItem(context, S.of(context).bill_management, management),
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
    if (SharedPreferencesHelper.getLocale().languageCode == 'zh') {
      return '${bid.tenant.lastName}${bid.tenant.firstName}';
    } else {
      return '${bid.tenant.lastName}, ${bid.tenant.firstName}';
    }
  }
}
