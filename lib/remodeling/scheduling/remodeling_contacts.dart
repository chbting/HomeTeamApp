import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduler.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduling_data.dart';
import 'package:tner_client/ui/address_form.dart';
import 'package:tner_client/ui/name_form.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/generated/l10n.dart';

class RemodelingContactsWidget extends StatefulWidget {
  const RemodelingContactsWidget({Key? key, required this.data})
      : super(key: key);

  final RemodelingSchedulingData data;

  @override
  State<RemodelingContactsWidget> createState() =>
      RemodelingContactsWidgetState();
}

class RemodelingContactsWidgetState extends State<RemodelingContactsWidget>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<NameFormState> _nameFormKey = GlobalKey<NameFormState>();
  final GlobalKey<AddressFormState> _addressFormKey =
      GlobalKey<AddressFormState>();
  final FocusNode _lastNameFieldFocus = FocusNode();
  final FocusNode _firstNameFieldFocus = FocusNode();

  @override
  void initState() {
    _lastNameFieldFocus.addListener(() {
      setState(() {});
    });
    _firstNameFieldFocus.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _lastNameFieldFocus.removeListener(() {});
    _lastNameFieldFocus.dispose();
    _firstNameFieldFocus.removeListener(() {});
    _firstNameFieldFocus.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      padding: const EdgeInsets.only(
          left: 12.0,
          right: 12.0,
          top: RemodelingSchedulingScreen.stepTitleBarHeight - 4.0,
          bottom: RemodelingSchedulingScreen.bottomButtonContainerHeight - 4.0),
      primary: false,
      children: [
        Card(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Wrap(
                children: [
                  NameForm(key: _nameFormKey, client: widget.data.client),
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
                          helperText:
                              S.of(context).hong_kong_number_only,
                          icon: const Icon(Icons.phone)),
                      onChanged: (value) {
                        widget.data.client.phoneNumber = value;
                      },
                      validator: (value) {
                        return (value == null || value.isEmpty)
                            ? S.of(context).info_required
                            : null;
                      }),
                  const Divider(thickness: 1.0),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        S.of(context).remodeling_address,
                        style: AppTheme.getCardTitleTextStyle(context),
                      )),
                  AddressForm(key: _addressFormKey, data: widget.data.client)
                ],
              )),
        ))
      ],
    );
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
