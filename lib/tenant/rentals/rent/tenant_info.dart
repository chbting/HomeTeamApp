import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/contract_bid.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_broker.dart';
import 'package:hometeam_client/ui/shared/address_form.dart';
import 'package:hometeam_client/ui/shared/contact_form.dart';
import 'package:hometeam_client/ui/shared/form_card.dart';
import 'package:hometeam_client/ui/shared/form_controller.dart';

class TenantInformationScreen extends StatefulWidget {
  const TenantInformationScreen({Key? key, required this.offer})
      : super(key: key);

  final ContractBid offer;

  @override
  State<StatefulWidget> createState() => TenantInformationScreenState();
}

class TenantInformationScreenState extends State<TenantInformationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FormController _contactFormController = FormController();
  final FormController _addressFormController = FormController();

  @override
  Widget build(BuildContext context) {
    return ListView(
        primary: false,
        // note: ListView has 4.0 internal padding on all sides
        padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: ContractBrokerScreen.stepTitleBarHeight - 4.0,
            bottom: ContractBrokerScreen.bottomButtonContainerHeight - 4.0),
        children: [
          FormCard(
              title: S.of(context).tenant,
              body: Form(
                  key: _formKey,
                  child: Wrap(
                    children: [
                      ContactForm(
                          client: widget.offer.tenant,
                          controller: _contactFormController),
                      Container(height: 16.0),
                      TextFormField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              icon: const Icon(Icons.badge_outlined),
                              // todo better icon
                              labelText: S.of(context).id_card_number),
                          onChanged: (value) {},
                          // todo format input
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            //todo id card validator
                            return null;
                          }),
                      Container(height: 16.0),
                      const Divider(thickness: 1.0),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            S.of(context).mailing_address,
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                      AddressForm(
                          address: widget.offer.tenant.address,
                          controller: _addressFormController)
                    ],
                  )))
        ]);
  }

  bool validate() {
    // note: In "return form1.validate() && form2.validate();", the second statement won't execute if the first one returns false
    bool contactPersonFormValidated = _contactFormController.validate();
    bool tenantFormValidated = _formKey.currentState!.validate(); // Validate ID
    bool addressFormValidated = _addressFormController.validate();
    return contactPersonFormValidated &&
        tenantFormValidated &&
        addressFormValidated;
  }
}
