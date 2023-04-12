import 'package:flutter/material.dart';
import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/debug.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/terms.dart';
import 'package:hometeam_client/json_model/bid.dart';
import 'package:hometeam_client/json_model/tenant.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_broker.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_broker_inherited_data.dart';
import 'package:hometeam_client/ui/theme/theme.dart';
import 'package:hometeam_client/utils/format.dart';
import 'package:hometeam_client/utils/shared_preferences_helper.dart';
import 'package:intl/intl.dart';

class OfferConfirmationScreen extends StatelessWidget {
  const OfferConfirmationScreen({Key? key}) : super(key: key);

  final double _leadSpacing = 56.0;
  final double _itemSpacing = 12.0; // Spacing between title-item pairs
  final double _listViewPadding = 16.0;
  final double _listViewInternalPadding =
      4.0; // note: ListView has 4.0 internal padding on all sides
  final double _cardPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    Bid bid = ContractBrokerInheritedData.of(context)!.bid;

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
                '${PropertyHelper.getFromId(bid.contractOriginal.propertyId).address}',
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
                              _getPricingColumn(context, S.of(context).offered,
                                  bid.contractBid),
                              _getPricingColumn(context, S.of(context).original,
                                  bid.contractOriginal)
                            ],
                          ),
                          Container(height: _itemSpacing),
                          const Divider(thickness: 1.0),
                          Text(S.of(context).lease_period,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          // todo show original contract
                          Text(
                              '${DateFormat(Format.date).format(bid.contractBid.startDate!)} '
                              '- ${DateFormat(Format.date).format(bid.contractBid.endDate!)}',
                              style: AppTheme.getCardBodyTextStyle(context)),
                          Container(height: _itemSpacing),
                          Text(S.of(context).notes,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Text(bid.notes.isEmpty ? '-' : bid.notes,
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
                          Text(_getTenantName(bid.tenant),
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
                        ],
                      )
                    ],
                  ))),
        ]);
  }

  Widget _getPricingColumn(
      BuildContext context, String title, Terms contract) {
    int monthlyRent, deposit;
    bool water, electricity, gas, rates, management;

    monthlyRent = contract.rent;
    deposit = contract.deposit;
    water = contract.waterRequired;
    electricity = contract.electricityRequired;
    gas = contract.gasRequired;
    rates = contract.ratesRequired;
    management = contract.managementRequired;

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

  String _getTenantName(Tenant tenant) {
    if (SharedPreferencesHelper.getLocale().languageCode == 'zh') {
      return '${tenant.lastName}${tenant.firstName}';
    } else {
      return '${tenant.lastName}, ${tenant.firstName}';
    }
  }
}
