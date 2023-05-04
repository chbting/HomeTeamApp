import 'package:flutter/material.dart';
import 'package:hometeam_client/debug.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/property.dart';
import 'package:hometeam_client/shared/listing_inherited_data.dart';
import 'package:hometeam_client/shared/ui/form_card.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';

class PropertyUploaderConfirmationWidget extends StatelessWidget {
  const PropertyUploaderConfirmationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    ListingInheritedData.of(context)!.property.address =
        Debug.getSampleProperties()[0].address; //todo
    Property property = ListingInheritedData.of(context)!.property;

    return ListView(
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.only(
          left: 8.0, right: 8.0, bottom: StandardStepper.buttonBarHeight),
      children: [
        FormCard(
            title: S.of(context).property_address,
            body: Text('${property.address}'))
      ],
    );
  }
}
