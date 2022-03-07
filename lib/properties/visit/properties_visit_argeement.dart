import 'package:flutter/material.dart';
import 'package:tner_client/properties/visit/properties_visit_data.dart';
import 'package:tner_client/utils/text_helper.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        primary: false,
        children: [
          Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(TextHelper.appLocalizations
                    .properties_visit_agreement_content)), //todo name of the person
          )
        ]);
  }
}
