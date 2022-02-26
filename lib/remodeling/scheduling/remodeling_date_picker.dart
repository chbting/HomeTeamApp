import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduling_data.dart';
import 'package:tner_client/shared_preferences_helper.dart';

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
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: CalendarDatePicker(
                    initialDate: widget.data.datePicked,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    onDateChanged: (DateTime value) {
                      setState(() {
                        widget.data.datePicked = value;
                      });
                    })),
          ),
          Card(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: 8.0,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.remodeling_start_date,
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      DateFormat(
                              'd/M/y EEEE',
                              SharedPreferencesHelper()
                                  .getLocale()
                                  .languageCode)
                          .format(widget.data.datePicked),
                      style: Theme.of(context).textTheme.subtitle1,
                    )
                  ],
                )),
          )
        ]);
  }
}
