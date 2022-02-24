import 'package:flutter/material.dart';
import 'package:tner_client/properties/visit/properties_visit_data.dart';

class PropertiesVisitStartingPointWidget extends StatefulWidget {
  const PropertiesVisitStartingPointWidget({Key? key, required this.data})
      : super(key: key);

  final PropertiesVisitData data;

  @override
  State<PropertiesVisitStartingPointWidget> createState() =>
      PropertiesVisitStartingPointWidgetState();
}

class PropertiesVisitStartingPointWidgetState
    extends State<PropertiesVisitStartingPointWidget> {
  final int _schedulingRange = 30;

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
        // all sides, thus these values are offset
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        primary: false,
        children: [
          Card(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: CalendarDatePicker(
                    initialDate: widget.data.dateTimePicked,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    onDateChanged: (DateTime value) {
                      setState(() {
                        widget.data.dateTimePicked = value;
                      });
                    })),
          ),
        ]);
  }
}
