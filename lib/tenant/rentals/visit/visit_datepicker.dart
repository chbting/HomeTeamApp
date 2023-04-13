import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/shared/theme/theme.dart';
import 'package:hometeam_client/shared/ui/collapsable_expansion_tile.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';
import 'package:hometeam_client/tenant/rentals/visit/visit_data.dart';
import 'package:hometeam_client/utils/format.dart';
import 'package:hometeam_client/utils/shared_preferences_helper.dart';
import 'package:intl/intl.dart';

class VisitDatePickerWidget extends StatefulWidget {
  const VisitDatePickerWidget({Key? key, required this.data}) : super(key: key);

  final VisitData data;

  @override
  State<VisitDatePickerWidget> createState() => VisitDatePickerWidgetState();
}

class VisitDatePickerWidgetState extends State<VisitDatePickerWidget> {
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
    const earliestAvailableTime =
        TimeOfDay(hour: 10, minute: 0); //todo from server
    final firstDate = DateTime(
        now.year,
        now.month,
        now.day + VisitData.firstAvailableDay,
        earliestAvailableTime.hour,
        earliestAvailableTime.minute);
    final lastDate = DateTime(
        firstDate.year, firstDate.month, firstDate.day + _schedulingRange);
    if (widget.data.dateTimePicked.isBefore(firstDate)) {
      widget.data.dateTimePicked = firstDate;
    }

    return ListView(
        // note: ListView has 4.0 internal padding on all sides
        padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            bottom: StandardStepper.bottomMargin - 4.0),
        primary: false,
        children: [
          Card(
              child: CollapsableExpansionTile(
            key: _datePickerKey,
            initiallyExpanded: true,
            leading: const SizedBox(
              height: double.infinity,
              child: Icon(Icons.calendar_today),
            ),
            title: Text(S.of(context).date,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
                DateFormat(Format.dateLong,
                        SharedPreferencesHelper.getLocale().languageCode)
                    .format(widget.data.dateTimePicked),
                style: Theme.of(context).textTheme.titleMedium),
            onExpansionChanged: (isExpanded) {
              if (isExpanded && _timePickerKey.currentState!.isExpanded()) {
                _timePickerKey.currentState!.setExpanded(false);
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
                    });
                    _datePickerKey.currentState?.setExpanded(false);
                    _timePickerKey.currentState?.setExpanded(true);
                  })
            ],
          )),
          Card(
              child: CollapsableExpansionTile(
            key: _timePickerKey,
            leading: const SizedBox(
              height: double.infinity,
              child: Icon(Icons.schedule),
            ),
            title: Text(S.of(context).time,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
                TimeOfDay(
                        hour: widget.data.dateTimePicked.hour,
                        minute: widget.data.dateTimePicked.minute)
                    .format(context),
                style: Theme.of(context).textTheme.titleMedium),
            onExpansionChanged: (isExpanded) {
              if (isExpanded && _datePickerKey.currentState!.isExpanded()) {
                _datePickerKey.currentState!.setExpanded(false);
              }
            },
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text(S.of(context).morning,
                          style: AppTheme.getCardTitleTextStyle(context)))),
              GridView.count(
                crossAxisCount: 4,
                childAspectRatio: 2,
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                children: getTimeOfDayList(
                        const TimeOfDay(hour: 10, minute: 0),
                        const TimeOfDay(hour: 11, minute: 30),
                        const Duration(minutes: 30))
                    .map<Widget>((timeOfDay) {
                  return getTimeWidget(timeOfDay, true);
                }).toList(),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Text(S.of(context).afternoon,
                          style: AppTheme.getCardTitleTextStyle(context)))),
              GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: 2,
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  children: getTimeOfDayList(
                          const TimeOfDay(hour: 12, minute: 0),
                          const TimeOfDay(hour: 19, minute: 0),
                          const Duration(minutes: 30))
                      .map<Widget>((timeOfDay) {
                    return getTimeWidget(timeOfDay, true);
                  }).toList()),
              Container(height: 4.0)
            ],
          ))
        ]);
  }

  Widget getTimeWidget(TimeOfDay timeOfDay, bool isAvailable) {
    bool isSelected = timeOfDay.hour == widget.data.dateTimePicked.hour &&
        timeOfDay.minute == widget.data.dateTimePicked.minute;

    Widget timeTextBox = Container(
        decoration: isSelected
            ? BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                shape: BoxShape.rectangle)
            : null,
        child: Align(
            alignment: Alignment.center,
            child: Text(
                '${MaterialLocalizations.of(context).formatHour(timeOfDay)}:'
                '${MaterialLocalizations.of(context).formatMinute(timeOfDay)}',
                style: getTimeTextStyle(isAvailable, isSelected))));

    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: isAvailable
            ? InkWell(
                child: timeTextBox,
                onTap: () {
                  var newValue = DateTime(
                      widget.data.dateTimePicked.year,
                      widget.data.dateTimePicked.month,
                      widget.data.dateTimePicked.day,
                      timeOfDay.hour,
                      timeOfDay.minute);
                  setState(() {
                    widget.data.dateTimePicked = newValue;
                  });
                  _timePickerKey.currentState?.setExpanded(false);
                },
              )
            : timeTextBox);
  }

  TextStyle getTimeTextStyle(bool isAvailable, bool isSelected) {
    if (isAvailable) {
      if (isSelected) {
        return AppTheme.getCardBodyTextStyle(context)!
            .copyWith(color: Theme.of(context).colorScheme.onPrimary);
      } else {
        return AppTheme.getCardBodyTextStyle(context)!;
      }
    } else {
      return AppTheme.getCardBodyTextStyle(context)!
          .copyWith(color: Theme.of(context).disabledColor);
    }
  }

  List<TimeOfDay> getTimeOfDayList(
      TimeOfDay startTime, TimeOfDay endTime, Duration interval) {
    List<TimeOfDay> list = [];
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      list.add(TimeOfDay(hour: hour, minute: minute));
      minute += interval.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
    return list;
  }
}
