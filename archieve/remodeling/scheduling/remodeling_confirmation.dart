import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';
import '../remodeling_types.dart';
import 'remodeling_inherited_data.dart';
import 'remodeling_order.dart';
import 'remodeling_pricing.dart';
import 'remodeling_scheduler.dart';

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
              subtitle: _getRemodelingItems(context, info)),
        )),
        Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
              leading: const Icon(Icons.location_pin),
              title: Text(S.of(context).remodeling_address,
                  style: AppTheme.getCardTitleTextStyle(context)),
              subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      '${info.client.addressLine1}'
                      '\n${info.client.addressLine2}'
                      '\n${info.client.district}'
                      '\n${info.client.region}',
                      style: AppTheme.getCardBodyTextStyle(context)))),
        )),
        Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
              leading: const Icon(Icons.contact_phone),
              title: Text(S.of(context).contact_person,
                  style: AppTheme.getCardTitleTextStyle(context)),
              subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                      '${_getContactName(info)}'
                      '\n${info.client.phoneNumber}',
                      style: AppTheme.getCardBodyTextStyle(context)))),
        ))
      ],
    );
  }

  Widget _getRemodelingItems(BuildContext context, RemodelingOrder order) {
    // TODO total estimation
    return ListView.builder(
        padding: const EdgeInsets.only(top: 8.0),
        primary: false,
        shrinkWrap: true,
        // Necessary as a nested ListView
        itemCount: order.remodelingItems.length,
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
                              order.remodelingItems[index].type, context),
                          style: AppTheme.getCardBodyTextStyle(context)),
                      // Item estimate
                      Text(
                          formatPrice(RemodelingPricing.getEstimate(
                              order.remodelingItems[index])),
                          style: AppTheme.getCardBodyTextStyle(context))
                    ]),
                _getRemodelingItemDetails(
                    context, order.remodelingItems[index]),
                index < order.remodelingItems.length - 1
                    ? Container(height: 8.0)
                    // Add spacings between remodeling items
                    : _getTotalEstimation(context, order)
              ]);
        });
  }

  Widget _getTotalEstimation(BuildContext context, RemodelingOrder order) {
    var total = 0;
    for (var element in order.remodelingItems) {
      total += RemodelingPricing.getEstimate(element);
    }
    return Column(
      children: [
        const Divider(thickness: 1.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(S.of(context).total,
                style: AppTheme.getCardBodyTextStyle(context)),
            Text(formatPrice(total),
                style: AppTheme.getCardBodyTextStyle(context))
          ],
        )
      ],
    );
  }

  Widget _getRemodelingItemDetails(BuildContext context, RemodelingItem item) {
    switch (item.type) {
      // todo add other remodeling types here
      case RemodelingType.painting:
        item as RemodelingPainting;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('- ${item.paintArea} ${S.of(context).sq_ft}',
              style: AppTheme.getCardBodySubTextStyle(context)),
          Text(
              item.scrapeOldPaint
                  ? '- ${S.of(context).scrape_old_paint_yes}'
                  : '- ${S.of(context).scrape_old_paint_no}',
              style: AppTheme.getCardBodySubTextStyle(context)),
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
