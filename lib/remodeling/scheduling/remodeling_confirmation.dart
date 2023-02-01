import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_info.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_inherited_data.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_pricing.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduler.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/format.dart';
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
          // todo review padding = all 16.0?
          child: ListTile(
              leading: const Icon(Icons.style),
              title: Text(S.of(context).remodeling_options,
                  style: AppTheme.getCardTitleTextStyle(context)),
              subtitle: _getRemodelingOptionsBody(context, info)),
        )),
        Card(
          child: ListTile(
            leading: const SizedBox(
                height: double.infinity, child: Icon(Icons.calendar_today)),
            title: Text(S.of(context).remodeling_start_date,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
                DateFormat(Format.dateLong,
                        SharedPreferencesHelper.getLocale().languageCode)
                    .format(info.datePicked),
                style: AppTheme.getCardBodyTextStyle(context)),
          ),
        ),
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
              title: Text(S.of(context).contact_number,
                  style: AppTheme.getCardTitleTextStyle(context)),
              subtitle: Text(
                  '${info.client.phoneNumber}'
                  '\n${_getContactName(info)}',
                  style: AppTheme.getCardBodyTextStyle(context))),
        ))
      ],
    );
  }

  Widget _getRemodelingOptionsBody(BuildContext context, RemodelingInfo info) {
    // TODO include subtotal and total estimation
    return Wrap(
      runSpacing: 4.0,
      children: [
        info.remodelingItems.contains(RemodelingItem.painting)
            ? _getPaintingItem(context, info)
            : Container(),
      ],
    );
  }

  Widget _getPaintingItem(BuildContext context, RemodelingInfo info) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
                RemodelingItemHelper.getItemName(
                    RemodelingItem.painting, context),
                style: AppTheme.getCardBodyTextStyle(context)),
            Text(
                formatPrice(RemodelingPricing.getPaintingEstimate(
                    info.paintArea, info.scrapeOldPaint)),
                style: AppTheme.getCardBodyTextStyle(context))
          ]),
      Text('- ${info.paintArea} ${S.of(context).sq_ft}',
          style: AppTheme.getCardBodyTextStyle(context)),
      Text(
          info.scrapeOldPaint!
              ? '- ${S.of(context).scrape_old_paint_yes}'
              : '- ${S.of(context).scrape_old_paint_no}',
          style: AppTheme.getCardBodyTextStyle(context)),
    ]);
  }

  String _getContactName(RemodelingInfo info) {
    if (SharedPreferencesHelper.getLocale().languageCode == 'zh') {
      return '${info.client.lastName}${info.client.title}';
    } else {
      return '${info.client.title} ${info.client.lastName}';
    }
  }
}
