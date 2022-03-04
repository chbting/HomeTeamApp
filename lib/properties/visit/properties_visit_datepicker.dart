import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:tner_client/properties/visit/properties_visit_data.dart';
import 'package:tner_client/shared_preferences_helper.dart';
import 'package:tner_client/theme.dart';
import 'package:tner_client/ui/collapsable_expansion_tile.dart';

class PropertiesVisitDatePickerWidget extends StatefulWidget {
  const PropertiesVisitDatePickerWidget({Key? key, required this.data})
      : super(key: key);

  final PropertiesVisitData data;

  @override
  State<PropertiesVisitDatePickerWidget> createState() =>
      PropertiesVisitDatePickerWidgetState();
}

class PropertiesVisitDatePickerWidgetState
    extends State<PropertiesVisitDatePickerWidget> {
  final GlobalKey<CollapsableExpansionTileState> _datePickerKey =
      GlobalKey<CollapsableExpansionTileState>();
  final GlobalKey<CollapsableExpansionTileState> _timePickerKey =
      GlobalKey<CollapsableExpansionTileState>();
  final int _schedulingRange = 30;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDate = DateTime(
        now.year, now.month, now.day + PropertiesVisitData.firstAvailableDay);
    final lastDate = DateTime(
        firstDate.year, firstDate.month, firstDate.day + _schedulingRange);
    if (widget.data.dateTimePicked.isBefore(firstDate)) {
      widget.data.dateTimePicked = firstDate;
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
            title: Text(AppLocalizations.of(context)!.date,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
                DateFormat('d/M/y EEEE',
                        SharedPreferencesHelper().getLocale().languageCode)
                    .format(widget.data.dateTimePicked),
                style: Theme.of(context).textTheme.subtitle1),
            onExpansionChanged: (isExpanded) {
              if (isExpanded && _timePickerKey.currentState!.isExpanded()) {
                setState(() {
                  _timePickerKey.currentState!.setExpanded(false);
                });
              }
            },
            children: [
              CalendarDatePicker(
                  initialDate: widget.data.dateTimePicked,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  onDateChanged: (DateTime value) {
                    setState(() {
                      widget.data.dateTimePicked = value;
                      _datePickerKey.currentState?.setExpanded(false);
                      // todo collapse the tile
                      // _datePickerTile.setExpanded(false);
                    });
                  })
            ],
          )),
          Card(
              child: CollapsableExpansionTile(
            key: _timePickerKey,
            leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Icon(Icons.schedule)]),
            title: Text(AppLocalizations.of(context)!.time,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
                TimeOfDay(
                        hour: widget.data.dateTimePicked.hour,
                        minute: widget.data.dateTimePicked.minute)
                    .format(context),
                style: Theme.of(context).textTheme.subtitle1),
            onExpansionChanged: (isExpanded) {
              if (isExpanded && _datePickerKey.currentState!.isExpanded()) {
                setState(() {
                  _datePickerKey.currentState!.setExpanded(false);
                });
              }
            },
            children: [
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                children: [
                  getTimeButton(TimeOfDay(hour: 9, minute: 0)),
                  getTimeButton(TimeOfDay(hour: 9, minute: 30)),
                  getTimeButton(TimeOfDay(hour: 10, minute: 0)),
                  getTimeButton(TimeOfDay(hour: 10, minute: 30)),
                ],
              )
            ],
          ))
        ]);
  }

  Widget getTimeButton(TimeOfDay timeOfDay) {
    return TextButton(
      child: Text(timeOfDay.format(context)),
      onPressed: () {
        var newValue = DateTime(
            widget.data.dateTimePicked.year,
            widget.data.dateTimePicked.month,
            widget.data.dateTimePicked.day,
            timeOfDay.hour,
            timeOfDay.minute);
        setState(() {
          widget.data.dateTimePicked = newValue;
          _timePickerKey.currentState?.setExpanded(false);
        });
      },
    );
  }

  // List<String> getAvailableTimes() {
  //   final startTime = TimeOfDay(hour: 9, minute: 0);
  //   final endTime = TimeOfDay(hour: 20, minute: 0);
  //   final step = Duration(minutes: 30);
  //   return getTimes(startTime, endTime, step)
  //       .map((tod) => tod.format(context))
  //       .toList();
  // }

  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }
}

class Item {
  Item({
    this.isExpanded = false,
  });

  bool isExpanded;
}
