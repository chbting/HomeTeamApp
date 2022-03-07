import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_pricing.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduling_data.dart';
import 'package:tner_client/theme.dart';
import 'package:tner_client/utils/text_helper.dart';

import '../../utils/shared_preferences_helper.dart';

class RemodelingConfirmationWidget extends StatelessWidget {
  const RemodelingConfirmationWidget({Key? key, required this.data})
      : super(key: key);

  final RemodelingSchedulingData data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: false,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      children: [
        Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
              leading: const Icon(Icons.style),
              title: Text(TextHelper.appLocalizations.remodeling_options,
                  style: AppTheme.getCardTitleTextStyle(context)),
              subtitle: _getRemodelingOptionsBody(context)),
        )),
        Card(
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                Icon(Icons.calendar_today),
              ],
            ),
            title: Text(TextHelper.appLocalizations.remodeling_start_date,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
                DateFormat(AppTheme.dateFormat,
                        SharedPreferencesHelper().getLocale().languageCode)
                    .format(data.datePicked),
                style: AppTheme.getCardBodyTextStyle(context)),
          ),
        ),
        Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
              leading: const Icon(Icons.location_pin),
              title: Text(TextHelper.appLocalizations.remodeling_address,
                  style: AppTheme.getCardTitleTextStyle(context)),
              subtitle: Text(
                  '${data.addressLine1 ?? "1座2樓C室"}' //todo remove debug text
                  '\n${data.addressLine2 ?? "雅佳花園"}'
                  '\n${data.district ?? "上環"}'
                  '\n${data.region ?? "香港"}',
                  style: AppTheme.getCardBodyTextStyle(context))),
        )),
        Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
              leading: const Icon(Icons.contact_phone),
              title: Text(TextHelper.appLocalizations.contact_number,
                  style: AppTheme.getCardTitleTextStyle(context)),
              subtitle: Text(
                  '${data.phoneNumber ?? "12345678"}' //todo remove debug text
                  '\n${_getContactName()}',
                  style: AppTheme.getCardBodyTextStyle(context))),
        ))
      ],
    );
  }

  Widget _getRemodelingOptionsBody(BuildContext context) {
    // TODO include subtotal and total estimation
    return Wrap(
      runSpacing: 4.0,
      children: [
        data.selectedItemList.contains(RemodelingItem.painting)
            ? _getPaintingItem(context)
            : Container(),
      ],
    );
  }

  Widget _getPaintingItem(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(getRemodelingItemTitle(RemodelingItem.painting),
                style: AppTheme.getCardBodyTextStyle(context)),
            Text(
                formatPrice(RemodelingPricing.getPaintingEstimate(
                    data.paintArea, data.scrapeOldPaint)),
                style: AppTheme.getCardBodyTextStyle(context))
          ]),
      Text('- ${data.paintArea} ${TextHelper.appLocalizations.sq_ft}',
          style: AppTheme.getCardBodyTextStyle(context)),
      Text(
          data.scrapeOldPaint!
              ? '- ${TextHelper.appLocalizations.scrape_old_paint_yes}'
              : '- ${TextHelper.appLocalizations.scrape_old_paint_no}',
          style: AppTheme.getCardBodyTextStyle(context)),
    ]);
  }

  String _getContactName() {
    if (SharedPreferencesHelper().getLocale().languageCode == 'zh') {
      return '${data.lastName ?? "陳"}${data.prefix ?? "先生"}';
    } else {
      return '${data.prefix ?? "Mr."} ${data.lastName ?? "Brown"}'; //Todo remove debug text
    }
  }
}
