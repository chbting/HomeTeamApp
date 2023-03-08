import 'package:flutter/material.dart';
import 'package:hometeam_client/data/address.dart';
import 'package:hometeam_client/ui/shared/address_form.dart';
import 'package:hometeam_client/ui/shared/form_controller.dart';

class PropertyInfoWidget extends StatefulWidget {
  const PropertyInfoWidget({Key? key, required this.controller})
      : super(key: key);

  final PropertyInfoWidgetController controller;

  @override
  State<StatefulWidget> createState() => PropertyInfoWidgetState();
}

class PropertyInfoWidgetState extends State<PropertyInfoWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FormController _addressFormController = FormController();
  final Address address = Address();

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
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: AddressForm(
                  address: address, controller: _addressFormController),
            ),
          )
        ],
      ),
    );
  }

  void _resetForm() {
    _addressFormController.reset();
  }

  bool _validate() {
    return _formKey.currentState!.validate();
  }
}

class PropertyInfoWidgetController {
  late void Function() resetForm;
  late bool Function() validate;
}
