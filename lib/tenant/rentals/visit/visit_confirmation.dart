import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/shared/theme/theme.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';
import 'package:hometeam_client/tenant/rentals/visit/visit_data.dart';
import 'package:hometeam_client/utils/format.dart';
import 'package:hometeam_client/utils/shared_preferences_helper.dart';
import 'package:intl/intl.dart';

class VisitConfirmationWidget extends StatelessWidget {
  const VisitConfirmationWidget({Key? key, required this.data})
      : super(key: key);

  final VisitData data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: false,
      padding: const EdgeInsets.only(
          left: 12.0, right: 12.0, bottom: StandardStepper.bottomMargin - 4.0),
      children: [
        Card(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                    leading: const SizedBox(
                      height: double.infinity,
                      child: Icon(Icons.place),
                    ),
                    title: Text(S.of(context).properties,
                        style: AppTheme.getCardTitleTextStyle(context)),
                    subtitle: Text('康翠臺 → 聚賢居 → 尚翹峰', //todo
                        style: AppTheme.getCardBodyTextStyle(context))))),
        Card(
          child: ListTile(
            leading: const SizedBox(
              height: double.infinity,
              child: Icon(Icons.calendar_today),
            ),
            isThreeLine: true,
            title: Text(S.of(context).property_visit_date,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
                '${TimeOfDay(hour: data.dateTimePicked.hour, minute: data.dateTimePicked.minute).format(context)}'
                '\n${DateFormat(Format.dateLong, SharedPreferencesHelper.getLocale().languageCode).format(data.dateTimePicked)}',
                style: AppTheme.getCardBodyTextStyle(context)),
          ),
        ),
        Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
              leading: const SizedBox(
                height: double.infinity,
                child: Icon(Icons.contact_phone),
              ),
              title: Text(S.of(context).contact_number,
                  style: AppTheme.getCardTitleTextStyle(context)),
              subtitle: Text(
                  '${data.phoneNumber ?? "12345678"}' //todo remove debug text
                  '\n${_getContactName()}',
                  style: AppTheme.getCardBodyTextStyle(context))),
        )),
        Card(
          child: ListTile(
            leading: const SizedBox(
              height: double.infinity,
              child: Icon(Icons.description),
            ),
            title: Text(S.of(context).property_visit_agreement,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
                data.agreementSigned
                    ? S.of(context).signed
                    : S.of(context).sign_on_site,
                style: AppTheme.getCardBodyTextStyle(context)),
          ),
        )
      ],
    );
  }

  String _getContactName() {
    if (SharedPreferencesHelper.getLocale().languageCode == 'zh') {
      return '${data.lastName ?? "陳"}${data.prefix ?? "先生"}';
    } else {
      return '${data.prefix ?? "Mr."} ${data.lastName ?? "Brown"}'; //Todo remove debug text
    }
  }
}
