import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/bid.dart';
import 'package:hometeam_client/shared/ui/contact_form.dart';
import 'package:hometeam_client/shared/ui/form_card.dart';
import 'package:hometeam_client/shared/ui/form_controller.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_broker.dart';
import 'package:hometeam_client/tenant/rentals/rent/contract_broker_inherited_data.dart';

class TenantInfoScreen extends StatefulWidget {
  const TenantInfoScreen({Key? key, required this.controller})
      : super(key: key);

  final TenantInfoScreenController controller;

  @override
  State<StatefulWidget> createState() => TenantInfoScreenState();
}

class TenantInfoScreenState extends State<TenantInfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FormController _contactFormController = FormController();
  late Bid _bid;

  @override
  void initState() {
    // TODO: implement initState
    widget.controller.validate = _validate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _bid = ContractBrokerInheritedData.of(context)!.bid;
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
                          client: _bid.tenant,
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
                    ],
                  )))
        ]);
  }

  bool _validate() {
    // note: In "return form1.validate() && form2.validate();", the second statement won't execute if the first one returns false
    bool contactPersonFormValidated = _contactFormController.validate();
    bool tenantFormValidated = _formKey.currentState!.validate(); // Validate ID
    return contactPersonFormValidated && tenantFormValidated;
  }
}

class TenantInfoScreenController {
  late bool Function() validate;
}
