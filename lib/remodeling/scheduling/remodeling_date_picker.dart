import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduler.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduling_data.dart';
import 'package:tner_client/ui/collapsable_expansion_tile.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/format.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';
import 'package:tner_client/utils/text_helper.dart';

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
  late final now = DateTime.now();
  late final firstDate = DateTime(now.year, now.month,
      now.day + RemodelingSchedulingData.firstAvailableDay);
  late final lastDate = DateTime(
      firstDate.year, firstDate.month, firstDate.day + _schedulingRange);

  @override
  Widget build(BuildContext context) {
    if (widget.data.datePicked.isBefore(firstDate)) {
      widget.data.datePicked = firstDate;
    }
    return ListView(
        // note: ListView has 4.0 internal padding on all sides
        padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: RemodelingSchedulingScreen.stepTitleBarHeight - 4.0,
            bottom:
                RemodelingSchedulingScreen.bottomButtonContainerHeight - 4.0),
        primary: false,
        children: [
          Card(
              child: CollapsableExpansionTile(
            key: _datePickerKey,
            leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Icon(Icons.calendar_today)]),
            title: Text(TextHelper.appLocalizations.remodeling_start_date,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
                DateFormat(Format.dateLong,
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
