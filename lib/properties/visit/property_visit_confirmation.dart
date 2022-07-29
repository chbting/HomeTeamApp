import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/properties/visit/property_visit_data.dart';
import 'package:tner_client/properties/visit/property_visit_scheduler.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/format.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';

class PropertyVisitConfirmationWidget extends StatelessWidget {
  const PropertyVisitConfirmationWidget({Key? key, required this.data})
      : super(key: key);

  final PropertyVisitData data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: false,
      padding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0,
          top: PropertyVisitSchedulingScreen.stepTitleBarHeight - 4.0,
          bottom: PropertyVisitSchedulingScreen.bottomButtonContainerHeight -
              4.0),
      children: [
        Card(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.place),
                      ],
                    ),
                    title: Text(S.of(context).properties,
                        style: AppTheme.getCardTitleTextStyle(context)),
                    subtitle: Text('康翠臺 → 聚賢居 → 尚翹峰', //todo
                        style: AppTheme.getCardBodyTextStyle(context))))),
        Card(
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                Icon(Icons.calendar_today),
              ],
            ),
            isThreeLine: true,
            title: Text(S.of(context).properties_visit_date,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
                '${TimeOfDay(hour: data.dateTimePicked.hour, minute: data.dateTimePicked.minute).format(context)}'
                '\n${DateFormat(Format.dateLong, SharedPreferencesHelper().getLocale().languageCode).format(data.dateTimePicked)}',
                style: AppTheme.getCardBodyTextStyle(context)),
          ),
        ),
        Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.contact_phone),
                ],
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
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                Icon(Icons.description),
              ],
            ),
            title: Text(S.of(context).properties_visit_agreement,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
                data.agreementSigned
                    ? S.of(context).signed
                    : S.of(context).sign_later,
                style: AppTheme.getCardBodyTextStyle(context)),
          ),
        )
      ],
    );
  }

  String _getContactName() {
    if (SharedPreferencesHelper().getLocale().languageCode == 'zh') {
      return '${data.lastName ?? "陳"}${data.prefix ?? "先生"}';
    } else {
      return '${data.prefix ?? "Mr."} ${data.lastName ?? "Brown"}'; //Todo remove debug text
    }
  }
}
