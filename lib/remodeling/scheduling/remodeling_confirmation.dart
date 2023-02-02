import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/remodeling/remodeling_types.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_inherited_data.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_order.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_pricing.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduler.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';

class RemodelingConfirmationWidget extends StatelessWidget {
  const RemodelingConfirmationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var info = RemodelingInheritedData.of(context)!.info;
    return ListView(
      primary: false,
      padding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0,
          top: RemodelingScheduler.stepTitleBarHeight - 4.0,
          bottom: RemodelingScheduler.bottomButtonContainerHeight - 4.0),
      children: [
        Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
              leading: const Icon(Icons.style),
              title: Text(S.of(context).remodeling_options,
                  style: AppTheme.getCardTitleTextStyle(context)),
              subtitle: _getRemodelingOptionsBody(
                  context, info)), // todo estimate summary
        )),
        Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
              leading: const Icon(Icons.location_pin),
              title: Text(S.of(context).remodeling_address,
                  style: AppTheme.getCardTitleTextStyle(context)),
              subtitle: Text(
                  '${info.client.addressLine1}'
                  '\n${info.client.addressLine2}'
                  '\n${info.client.district}'
                  '\n${info.client.region}',
                  style: AppTheme.getCardBodyTextStyle(context))),
        )),
        Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
              leading: const Icon(Icons.contact_phone),
              title: Text(S.of(context).contact_person,
                  style: AppTheme.getCardTitleTextStyle(context)),
              subtitle: Text(
                  '${_getContactName(info)}'
                  '\n${info.client.phoneNumber}',
                  style: AppTheme.getCardBodyTextStyle(context))),
        ))
      ],
    );
  }

  Widget _getRemodelingOptionsBody(BuildContext context, RemodelingOrder info) {
    // TODO include subtotal and total estimation
    return ListView.builder(
        primary: false,
        shrinkWrap: true, // Necessary as a nested ListView
        itemCount: info.remodelingItems.length,
        itemBuilder: (context, index) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Item Name
                      Text(
                          RemodelingTypeHelper.getItemName(
                              info.remodelingItems[index].type, context),
                          style: AppTheme.getCardBodyTextStyle(context)),
                      // Item estimate
                      Text(
                          // todo get a general version, do switch
                          formatPrice(RemodelingPricing.getEstimate(
                              info.remodelingItems[index])),
                          style: AppTheme.getCardBodyTextStyle(context))
                    ]),
                _getRemodelingItemDetails(context, info.remodelingItems[index])
                //todo spacing in between
              ]);
        });
  }

  Widget _getRemodelingItemDetails(BuildContext context, RemodelingItem item) {
    switch (item.type) {
      // todo add other remodeling types here
      case RemodelingType.painting:
        item as RemodelingPainting;
        return Column(children: [
          Text('- ${item.paintArea} ${S.of(context).sq_ft}',
              style: AppTheme.getCardBodyTextStyle(context)),
          Text(
              item.scrapeOldPaint
                  ? '- ${S.of(context).scrape_old_paint_yes}'
                  : '- ${S.of(context).scrape_old_paint_no}', //todo why is it tabbed?
              style: AppTheme.getCardBodyTextStyle(context)),
        ]);
      default:
        return Container();
    }
  }

  String _getContactName(RemodelingOrder info) {
    if (SharedPreferencesHelper.getLocale().languageCode == 'zh') {
      return '${info.client.lastName}${info.client.firstName} ${info.client.title}';
    } else {
      return '${info.client.title} ${info.client.firstName} ${info.client.lastName}';
    }
  }
}
