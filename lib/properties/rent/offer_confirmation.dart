import 'package:flutter/material.dart';
import 'package:tner_client/properties/rent/contract_broker.dart';
import 'package:tner_client/properties/rent/contract_offer_data.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/client_data.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';
import 'package:tner_client/utils/text_helper.dart';

class OfferConfirmationScreen extends StatelessWidget {
  const OfferConfirmationScreen({Key? key, required this.offer})
      : super(key: key);

  final ContractOffer offer;
  final double _lineSpacing = 8.0;

  @override
  Widget build(BuildContext context) {
    debugPrint('${offer.client.firstName}');
    if (offer.client.firstName == null) {
      offer.client = getSampleClientData();
      debugPrint('${offer.client.firstName}');
    } // todo debug line
    return ListView(
        primary: false,
        // note: ListView has 4.0 internal padding on all sides
        padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: ContractBrokerScreen.stepTitleBarHeight - 4.0,
            bottom: ContractBrokerScreen.bottomButtonContainerHeight - 4.0),
        children: [
          Card(
            child: ListTile(
              leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Icon(Icons.place)]),
              title: Text(TextHelper.appLocalizations.property_address,
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                          width: 56.0,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(Icons.person))),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(TextHelper.appLocalizations.tenant_info,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Container(height: _lineSpacing),
                          Text(TextHelper.appLocalizations.name,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Text(_getTenantName(),
                              style: AppTheme.getCardBodyTextStyle(context)),
                          Container(height: _lineSpacing),
                          Text(TextHelper.appLocalizations.id_card_number,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Text(offer.client.idCardNumber ?? '',
                              style: AppTheme.getCardBodyTextStyle(context)),
                          Container(height: _lineSpacing),
                          Text(TextHelper.appLocalizations.contact_number,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Text(offer.client.phoneNumber ?? '',
                              style: AppTheme.getCardBodyTextStyle(context)),
                          Container(height: _lineSpacing),
                          Text(TextHelper.appLocalizations.mailing_address,
                              style: AppTheme.getCardTitleTextStyle(context)),
                          Text(
                              '${offer.client.addressLine1}'
                              '\n${offer.client.addressLine2}'
                              '\n${offer.client.district}'
                              '\n${offer.client.region}',
                              style: AppTheme.getCardBodyTextStyle(context))
                        ],
                      )
                    ],
                  ))),
        ]);
  }

  String _getTenantName() {
    //todo detect input language is more sophisticated
    if (SharedPreferencesHelper().getLocale().languageCode == 'zh') {
      return '${offer.client.lastName}${offer.client.title}';
    } else {
      return '${offer.client.lastName}, ${offer.client.firstName}';
    }
  }
}
