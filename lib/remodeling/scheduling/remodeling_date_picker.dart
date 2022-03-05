import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduling_data.dart';
import 'package:tner_client/shared_preferences_helper.dart';
import 'package:tner_client/theme.dart';
import 'package:tner_client/ui/collapsable_expansion_tile.dart';

class RemodelingDatePickerWidget extends StatefulWidget {
  const RemodelingDatePickerWidget({Key? key, required this.data})
      : super(key: key);

  final RemodelingSchedulingData data;

  @override
  State<RemodelingDatePickerWidget> createState() =>
      RemodelingDatePickerWidgetState();
}

class RemodelingDatePickerWidgetState
    extends State<RemodelingDatePickerWidget> {
  final GlobalKey<CollapsableExpansionTileState> _datePickerKey =
      GlobalKey<CollapsableExpansionTileState>();
  final int _schedulingRange = 30;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month,
        now.day + RemodelingSchedulingData.firstAvailableDay);
    final lastDate = DateTime(
        firstDate.year, firstDate.month, firstDate.day + _schedulingRange);
    if (widget.data.datePicked.isBefore(firstDate)) {
      widget.data.datePicked = firstDate;
    }
    return ListView(
        // note: ListView with CalendarDatePicker has 4.0 internal padding on
        // all sides, thus these values are adjusted
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        primary: false,
        children: [
          Card(
              child: CollapsableExpansionTile(
            key: _datePickerKey,
            leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Icon(Icons.calendar_today)]),
            title: Text(AppLocalizations.of(context)!.remodeling_start_date,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
                DateFormat(AppTheme.dateFormat,
                        SharedPreferencesHelper().getLocale().languageCode)
                    .format(widget.data.datePicked),
                style: Theme.of(context).textTheme.subtitle1),
            children: [
              CalendarDatePicker(
                  initialDate: widget.data.datePicked,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  onDateChanged: (DateTime value) {
                    setState(() {
                      widget.data.datePicked = value;
                      _datePickerKey.currentState?.setExpanded(false);
                    });
                  })
            ],
          )),
        ]);
  }
}
