import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';
import 'package:hometeam_client/tenant/rentals/visit/visit_data.dart';

class VisitAgreementWidget extends StatefulWidget {
  const VisitAgreementWidget({Key? key, required this.data}) : super(key: key);

  final VisitData data;

  @override
  State<VisitAgreementWidget> createState() => VisitAgreementWidgetState();
}

class VisitAgreementWidgetState extends State<VisitAgreementWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
        // note: ListView has 4.0 internal padding on all sides
        padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            bottom: StandardStepper.buttonBarHeight - 4.0),
        primary: false,
        children: [
          Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(S
                    .of(context)
                    .property_visit_agreement_content)), //todo name of the person
          )
        ]);
  }
}
