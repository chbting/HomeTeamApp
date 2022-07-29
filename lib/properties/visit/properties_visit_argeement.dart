import 'package:flutter/material.dart';
import 'package:tner_client/properties/visit/properties_visit_data.dart';
import 'package:tner_client/properties/visit/properties_visit_scheduler.dart';
import 'package:tner_client/generated/l10n.dart';

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
  @override
  Widget build(BuildContext context) {
    return ListView(
        // note: ListView has 4.0 internal padding on all sides
        padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: PropertiesVisitSchedulingScreen.stepTitleBarHeight - 4.0,
            bottom: 48.0 * 2 + 16.0 * 3 - 4.0),
        primary: false,
        children: [
          Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(S.of(context)
                    .properties_visit_agreement_content)), //todo name of the person
          )
        ]);
  }
}
