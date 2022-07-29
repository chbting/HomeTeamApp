import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_pricing.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduler.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduling_data.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/client_data.dart';
import 'package:tner_client/utils/format.dart';
import 'package:tner_client/utils/text_helper.dart';

import '../../utils/shared_preferences_helper.dart';

class RemodelingConfirmationWidget extends StatelessWidget {
  const RemodelingConfirmationWidget({Key? key, required this.data})
      : super(key: key);

  final RemodelingSchedulingData data;

  @override
  Widget build(BuildContext context) {
    if(data.client.firstName == null) {
      data.client = getSampleClientData();
    } // todo debug line
    return ListView(
      primary: false,
      padding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0,
          top: RemodelingSchedulingScreen.stepTitleBarHeight - 4.0,
          bottom: RemodelingSchedulingScreen.bottomButtonContainerHeight - 4.0),
      children: [
        Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0), // todo review padding = all 16.0?
          child: ListTile(
              leading: const Icon(Icons.style),
              title: Text(TextHelper.s.remodeling_options,
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
            title: Text(TextHelper.s.remodeling_start_date,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
                DateFormat(Format.dateLong,
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
              title: Text(TextHelper.s.remodeling_address,
                  style: AppTheme.getCardTitleTextStyle(context)),
              subtitle: Text(
                  '${data.client.addressLine1}'
                  '\n${data.client.addressLine2}'
                  '\n${data.client.district}'
                  '\n${data.client.region}',
                  style: AppTheme.getCardBodyTextStyle(context))),
        )),
        Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
              leading: const Icon(Icons.contact_phone),
              title: Text(TextHelper.s.contact_number,
                  style: AppTheme.getCardTitleTextStyle(context)),
              subtitle: Text(
                  '${data.client.phoneNumber}'
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
      Text('- ${data.paintArea} ${TextHelper.s.sq_ft}',
          style: AppTheme.getCardBodyTextStyle(context)),
      Text(
          data.scrapeOldPaint!
              ? '- ${TextHelper.s.scrape_old_paint_yes}'
              : '- ${TextHelper.s.scrape_old_paint_no}',
          style: AppTheme.getCardBodyTextStyle(context)),
    ]);
  }

  String _getContactName() {
    if (SharedPreferencesHelper().getLocale().languageCode == 'zh') {
      return '${data.client.lastName}${data.client.title}';
    } else {
      return '${data.client.title} ${data.client.lastName}';
    }
  }
}
