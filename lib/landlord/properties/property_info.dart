import 'package:flutter/material.dart';
import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/ui/shared/address_form.dart';
import 'package:hometeam_client/ui/shared/form_card.dart';
import 'package:hometeam_client/ui/shared/form_controller.dart';
import 'package:hometeam_client/ui/shared/standard_stepper.dart';

class PropertyInfoWidget extends StatefulWidget {
  const PropertyInfoWidget(
      {Key? key, required this.property, required this.controller})
      : super(key: key);

  final Property property;
  final PropertyInfoWidgetController controller;

  @override
  State<StatefulWidget> createState() => PropertyInfoWidgetState();
}

class PropertyInfoWidgetState extends State<PropertyInfoWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FormController _addressFormController = FormController();

  @override
  void initState() {
    widget.controller.resetForm = _resetForm;
    widget.controller.validate = _validate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        primary: false,
        shrinkWrap: true,
        padding: const EdgeInsets.only(
            left: 8.0, right: 8.0, bottom: StandardStepper.bottomMargin),
        children: [
          FormCard(
            title: S.of(context).property_address,
            body: AddressForm(
                address: widget.property.address,
                controller: _addressFormController),
          ),
          FormCard(
            title: S.of(context).property_info,
            body: AddressForm(
                address: widget.property.address,
                controller: _addressFormController),
          )
        ],
      ),
    );
  }

  void _resetForm() {
    _addressFormController.reset();
  }

  bool _validate() {
    var addressValidate = _addressFormController.validate();
    var formValidate = _formKey.currentState!.validate();
    return addressValidate && formValidate;
  }
}

class PropertyInfoWidgetController {
  late void Function() resetForm;
  late bool Function() validate;
}
