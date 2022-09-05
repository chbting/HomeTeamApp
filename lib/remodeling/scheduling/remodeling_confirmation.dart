import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_info.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_inherited_data.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_pricing.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduler.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/client_data.dart';
import 'package:tner_client/utils/format.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';

class RemodelingConfirmationWidget extends StatefulWidget {
  const RemodelingConfirmationWidget({Key? key}) : super(key: key);

  @override
  State<RemodelingScheduler> createState() => RemodelingSchedulerState();
}

class RemodelingConfirmationWidgetState
    extends State<RemodelingConfirmationWidget> {
  late RemodelingInfo _data;

  @override
  Widget build(BuildContext context) {
    _data = RemodelingInheritedData.of(context)!.info;
    if (_data.client.firstName == null) {
      _data.client = getSampleClientData();
    } // todo debug line
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
            title: Text(S.of(context).remodeling_start_date,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
                DateFormat(Format.dateLong,
                        SharedPreferencesHelper.getLocale().languageCode)
                    .format(_data.datePicked),
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
                  '${_data.client.addressLine1}'
                  '\n${_data.client.addressLine2}'
                  '\n${_data.client.district}'
                  '\n${_data.client.region}',
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
                  '${_data.client.phoneNumber}'
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
        _data.remodelingItems.contains(RemodelingItem.painting)
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
            Text(
                RemodelingItemHelper.getTitle(RemodelingItem.painting, context),
                style: AppTheme.getCardBodyTextStyle(context)),
            Text(
                formatPrice(RemodelingPricing.getPaintingEstimate(
                    _data.paintArea, _data.scrapeOldPaint)),
                style: AppTheme.getCardBodyTextStyle(context))
          ]),
      Text('- ${_data.paintArea} ${S.of(context).sq_ft}',
          style: AppTheme.getCardBodyTextStyle(context)),
      Text(
          _data.scrapeOldPaint!
              ? '- ${S.of(context).scrape_old_paint_yes}'
              : '- ${S.of(context).scrape_old_paint_no}',
          style: AppTheme.getCardBodyTextStyle(context)),
    ]);
  }

  String _getContactName() {
    if (SharedPreferencesHelper.getLocale().languageCode == 'zh') {
      return '${_data.client.lastName}${_data.client.title}';
    } else {
      return '${_data.client.title} ${_data.client.lastName}';
    }
  }
}
