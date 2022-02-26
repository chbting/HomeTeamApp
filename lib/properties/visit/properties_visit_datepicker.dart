import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:tner_client/properties/visit/properties_visit_data.dart';
import 'package:tner_client/shared_preferences_helper.dart';
import 'package:tner_client/theme.dart';

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
  final int _schedulingRange = 30;

  @override
  void initState() {
    super.initState();
    //widget.data.dateTimePicked.;
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
              child: ExpansionTile(
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
            children: [
              CalendarDatePicker(
                  initialDate: widget.data.dateTimePicked,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  onDateChanged: (DateTime value) {
                    setState(() {
                      widget.data.dateTimePicked = value;
                    });
                  })
            ],

          )),
          Card(
              child: ExpansionTile(
            leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Icon(Icons.schedule)]),
            title: Text(AppLocalizations.of(context)!.time,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
                DateFormat('KK:mm',
                        SharedPreferencesHelper().getLocale().languageCode)
                    .format(widget.data.dateTimePicked),
                style: Theme.of(context).textTheme.subtitle1),
            children: [
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                children: [
                  TextButton(
                    child: Text("9:00"),
                    onPressed: () {

                    },
                  ),
                  Text("9:30"),
                  Text("10:00"),
                  Text("10:30")
                ],
              )
            ],
          ))
        ]);
  }

  List<String> getAvailableTimes() {
    final startTime = TimeOfDay(hour: 9, minute: 0);
    final endTime = TimeOfDay(hour: 20, minute: 0);
    final step = Duration(minutes: 30);
    return getTimes(startTime, endTime, step)
        .map((tod) => tod.format(context))
        .toList();
  }

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
