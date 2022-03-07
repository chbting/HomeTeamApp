import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tner_client/properties/visit/properties_visit_data.dart';
import 'package:tner_client/theme.dart';
import 'package:tner_client/utils/text_helper.dart';

import '../../utils/shared_preferences_helper.dart';

class PropertiesVisitConfirmationWidget extends StatelessWidget {
  const PropertiesVisitConfirmationWidget({Key? key, required this.data})
      : super(key: key);

  final PropertiesVisitData data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: false,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
                    title: Text(TextHelper.appLocalizations.properties,
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
            title: Text(TextHelper.appLocalizations.properties_visit_date,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
                '${TimeOfDay(hour: data.dateTimePicked.hour, minute: data.dateTimePicked.minute).format(context)}'
                '\n${DateFormat(AppTheme.dateFormat, SharedPreferencesHelper().getLocale().languageCode).format(data.dateTimePicked)}',
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
              title: Text(TextHelper.appLocalizations.contact_number,
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
            title: Text(
                TextHelper.appLocalizations.properties_visit_agreement,
                style: AppTheme.getCardTitleTextStyle(context)),
            subtitle: Text(
                data.agreementSigned
                    ? TextHelper.appLocalizations.signed
                    : TextHelper.appLocalizations.sign_later,
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
