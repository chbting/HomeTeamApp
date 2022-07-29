import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/properties/rent/contract_broker.dart';
import 'package:tner_client/properties/rent/contract_offer_data.dart';
import 'package:tner_client/ui/address_form.dart';
import 'package:tner_client/ui/name_form.dart';
import 'package:tner_client/ui/theme.dart';

class TenantInformationScreen extends StatefulWidget {
  const TenantInformationScreen({Key? key, required this.offer})
      : super(key: key);

  final ContractOffer offer;

  @override
  State<StatefulWidget> createState() => TenantInformationScreenState();
}

class TenantInformationScreenState extends State<TenantInformationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<NameFormState> _nameFormKey = GlobalKey<NameFormState>();
  final GlobalKey<AddressFormState> _addressFormKey =
      GlobalKey<AddressFormState>();

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
          Card(
              child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Wrap(
                  children: [
                    NameForm(key: _nameFormKey, client: widget.offer.client),
                    Container(height: 16.0),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            icon: const Icon(Icons.branding_watermark),
                            labelText: S.of(context).id_card_number),
                        onChanged: (value) {
                          //widget.offer.addressLine2 = value;
                        },
                        // todo format input
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          //todo id card validator
                          return null;
                        }),
                    Container(height: 16.0),
                    TextFormField(
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        maxLength: 8,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: S.of(context).contact_number,
                            helperText: S.of(context).hong_kong_number_only,
                            icon: const Icon(Icons.phone)),
                        onChanged: (value) {
                          widget.offer.client.phoneNumber = value;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return (value == null || value.isEmpty)
                              ? S.of(context).info_required
                              : null;
                        }),
                    const Divider(thickness: 1.0),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          S.of(context).mailing_address,
                          style: AppTheme.getCardTitleTextStyle(context),
                        )),
                    AddressForm(key: _addressFormKey, data: widget.offer.client)
                  ],
                )),
          ))
        ]);
  }

  bool validate() {
    // note: In "return form1.validate() && form2.validate();", the second
    // statement won't execute if the first return false
    bool nameFormValidated = _nameFormKey.currentState!.validate();
    bool currentFormValidated = _formKey.currentState!.validate();
    bool addressFormValidated = _addressFormKey.currentState!.validate();
    return nameFormValidated && currentFormValidated && addressFormValidated;
  }
}
