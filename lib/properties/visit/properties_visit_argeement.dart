import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/properties/visit/properties_visit_data.dart';

class PropertiesVisitAgreementWidget extends StatefulWidget {
  const PropertiesVisitAgreementWidget({Key? key, required this.data})
      : super(key: key);

  final PropertiesVisitData data;

  @override
  State<PropertiesVisitAgreementWidget> createState() =>
      PropertiesVisitAgreementWidgetState();
}

class PropertiesVisitAgreementWidgetState
    extends State<PropertiesVisitAgreementWidget> {
  final int _schedulingRange = 30;

  @override
  Widget build(BuildContext context) {
    return ListView(
        // note: ListView with CalendarDatePicker has 4.0 internal padding on
        // all sides, thus these values are offset
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        primary: false,
        children: [
          Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(AppLocalizations.of(context)!
                    .properties_visit_agreement_content)), //todo name of the person
          )
        ]);
  }
}
