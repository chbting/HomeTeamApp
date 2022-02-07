import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_pricing.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduling_data.dart';

import '../../shared_preferences_helper.dart';

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
              title: Text(AppLocalizations.of(context)!.remodeling_options,
                  style: _getCardTitleTextStyle(context)),
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
            title: Text(AppLocalizations.of(context)!.remodeling_start_date,
                style: _getCardTitleTextStyle(context)),
            subtitle: Text(
                DateFormat.yMMMMEEEEd(
                        SharedPreferencesHelper().getLocale().languageCode)
                    .format(data.datePicked),
                style: _getCardBodyTextStyle(context)),
          ),
        ),
        Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
              leading: const Icon(Icons.location_pin),
              title: Text(AppLocalizations.of(context)!.remodeling_address,
                  style: _getCardTitleTextStyle(context)),
              subtitle: Text(
                  '${data.addressLine1 ?? "1座2樓C室"}' //todo remove debug text
                  '\n${data.addressLine2 ?? "雅佳花園"}'
                  '\n${data.district ?? "上環"}'
                  '\n${data.region ?? "香港"}',
                  style: _getCardBodyTextStyle(context))),
        )),
        Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
              leading: const Icon(Icons.contact_phone),
              title: Text(AppLocalizations.of(context)!.contact_number,
                  style: _getCardTitleTextStyle(context)),
              subtitle: Text(
                  '${data.phoneNumber ?? "12345678"}' //todo remove debug text
                  '\n${_getContactName()}',
                  style: _getCardBodyTextStyle(context))),
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
            Text(getRemodelingItemTitle(RemodelingItem.painting, context),
                style: _getCardBodyTextStyle(context)),
            Text(
                formatPrice(RemodelingPricing.getPaintingEstimate(
                    data.paintArea, data.scrapeOldPaint)),
                style: _getCardBodyTextStyle(context))
          ]),
      Text('- ${data.paintArea} ${AppLocalizations.of(context)!.sq_ft}',
          style: _getCardBodyTextStyle(context)),
      Text(
          data.scrapeOldPaint!
              ? '- ${AppLocalizations.of(context)!.scrape_old_paint_yes}'
              : '- ${AppLocalizations.of(context)!.scrape_old_paint_no}',
          style: _getCardBodyTextStyle(context)),
    ]);
  }

  String _getContactName() {
    if (SharedPreferencesHelper().getLocale().languageCode == 'zh') {
      return '${data.lastName ?? "陳"}${data.prefix ?? "先生"}';
    } else {
      return '${data.prefix ?? "Mr."} ${data.lastName ?? "Brown"}'; //Todo remove debug text
    }
  }

  TextStyle? _getCardTitleTextStyle(BuildContext context) {
    return Theme.of(context)
        .textTheme
        .subtitle2!
        .copyWith(color: Theme.of(context).textTheme.caption!.color);
  }

  TextStyle? _getCardBodyTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.subtitle1;
  }
}
