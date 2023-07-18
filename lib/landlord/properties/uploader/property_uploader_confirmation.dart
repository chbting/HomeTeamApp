import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/property.dart';
import 'package:hometeam_client/shared/property_uploader_inherited_data.dart';
import 'package:hometeam_client/shared/ui/form_card.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';

class PropertyUploaderConfirmationPage extends StatelessWidget {
  const PropertyUploaderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    //Listing listing = ListingInheritedData.of(context)!.listing;
    Property property = PropertyUploaderInheritedData.of(context)!.property;

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
