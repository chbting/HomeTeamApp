import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //direction: Axis.vertical,
                //spacing: 8.0,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 72.0),
                      child: Text(
                        AppLocalizations.of(context)!.remodeling_start_date,
                        style: Theme.of(context).textTheme.caption,
                      )),
                  ListTile(
                    // todo center icon vertically
                    leading: const Icon(Icons.calendar_today),
                    title: Text(
                      DateFormat.yMMMMEEEEd(SharedPreferencesHelper()
                              .getLocale()
                              .languageCode)
                          .format(data.datePicked),
                    ),
                  ),
                ],
              )),
        )
      ],
    );
  }
}
