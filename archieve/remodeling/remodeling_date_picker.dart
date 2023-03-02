// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:tner_client/generated/l10n.dart';
// import 'package:tner_client/ui/collapsable_expansion_tile.dart';
// import 'package:tner_client/ui/theme.dart';
// import 'package:tner_client/utils/format.dart';
// import 'package:tner_client/utils/shared_preferences_helper.dart';
//
// import 'scheduling/remodeling_order.dart';
// import 'scheduling/remodeling_scheduler.dart';
//
// class RemodelingDatePickerWidget extends StatefulWidget {
//   const RemodelingDatePickerWidget({Key? key, required this.data})
//       : super(key: key);
//
//   final RemodelingOrder data;
//
//   @override
//   State<RemodelingDatePickerWidget> createState() =>
//       RemodelingDatePickerWidgetState();
// }
//
// class RemodelingDatePickerWidgetState
//     extends State<RemodelingDatePickerWidget> {
//   final GlobalKey<CollapsableExpansionTileState> _datePickerKey =
//       GlobalKey<CollapsableExpansionTileState>();
//
//   final int _schedulingRange = 30;
//   late final now = DateTime.now();
//   late final firstDate =
//       DateTime(now.year, now.month, now.day + RemodelingOrder.firstAvailableDay);
//   late final lastDate = DateTime(
//       firstDate.year, firstDate.month, firstDate.day + _schedulingRange);
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.data.datePicked.isBefore(firstDate)) {
//       widget.data.datePicked = firstDate;
//     }
//     return ListView(
//         // note: ListView has 4.0 internal padding on all sides
//         padding: const EdgeInsets.only(
//             left: 12.0,
//             right: 12.0,
//             top: RemodelingScheduler.stepTitleBarHeight - 4.0,
//             bottom: RemodelingScheduler.bottomButtonContainerHeight - 4.0),
//         primary: false,
//         children: [
//           Card(
//               child: CollapsableExpansionTile(
//             key: _datePickerKey,
//             leading: const SizedBox(
//               height: double.infinity,
//               child: Icon(Icons.calendar_today),
//             ),
//             title: Text(S.of(context).remodeling_start_date,
//                 style: AppTheme.getCardTitleTextStyle(context)),
//             subtitle: Text(
//                 DateFormat(Format.dateLong,
//                         SharedPreferencesHelper.getLocale().languageCode)
//                     .format(widget.data.datePicked),
//                 style: Theme.of(context).textTheme.subtitle1),
//             children: [
//               CalendarDatePicker(
//                   initialDate: widget.data.datePicked,
//                   firstDate: firstDate,
//                   lastDate: lastDate,
//                   onDateChanged: (DateTime value) {
//                     setState(() {
//                       widget.data.datePicked = value;
//                       _datePickerKey.currentState?.setExpanded(false);
//                     });
//                   })
//             ],
//           )),
//         ]);
//   }
// }
