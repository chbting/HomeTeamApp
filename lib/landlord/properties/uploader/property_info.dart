import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/shared/listing_inherited_data.dart';
import 'package:hometeam_client/shared/ui/address_form.dart';
import 'package:hometeam_client/shared/ui/form_controller.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';

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
  late Property _property;

  @override
  void initState() {
    widget.controller.resetForm = _resetForm;
    widget.controller.validate = _validate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _property = ListingInheritedData.of(context)!.property;

    return Form(
      key: _formKey,
      child: ListView(
        primary: false,
        shrinkWrap: true,
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, bottom: StandardStepper.bottomMargin),
        children: [
          StandardStepper.getSectionTitle(
              context, S.of(context).property_address, verticalPadding: 16.0),
          AddressForm(
              address: _property.address, controller: _addressFormController),
          const Divider(),
          StandardStepper.getSectionTitle(
              context, S.of(context).property_info, verticalPadding: 16.0),
          Wrap(
            runSpacing: 16.0,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                        initialValue: _property.netArea == -1
                            ? null
                            : _property.netArea.toString(),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText:
                                '${S.of(context).area_net} (${S.of(context).sq_ft})'),
                        onChanged: (value) => _property.netArea =
                            value.isNotEmpty ? int.parse(value) : 0,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => (value == null || value.isEmpty)
                            ? S.of(context).msg_info_required
                            : null),
                  ),
                  Container(width: 16.0),
                  Expanded(
                    child: TextFormField(
                        initialValue: _property.grossArea == -1
                            ? null
                            : _property.grossArea.toString(),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText:
                                '${S.of(context).area_gross} (${S.of(context).sq_ft})'),
                        onChanged: (value) => _property.grossArea =
                            value.isNotEmpty ? int.parse(value) : 0,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => (value == null || value.isEmpty)
                            ? S.of(context).msg_info_required
                            : null),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                        initialValue: _property.bedroom == -1
                            ? null
                            : _property.bedroom.toString(),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            icon: const Icon(Icons.bed_outlined),
                            labelText: S.of(context).bedroom),
                        onChanged: (value) => _property.bedroom =
                            value.isNotEmpty ? int.parse(value) : 0,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => (value == null || value.isEmpty)
                            ? S.of(context).msg_info_required
                            : null),
                  ),
                  Container(width: 16.0),
                  Expanded(
                    child: TextFormField(
                        initialValue: _property.bathroom == -1
                            ? null
                            : _property.bathroom.toString(),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            icon: const Icon(Icons.bathtub_outlined),
                            labelText: S.of(context).bathroom),
                        onChanged: (value) => _property.bathroom =
                            value.isNotEmpty ? int.parse(value) : 0,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => (value == null || value.isEmpty)
                            ? S.of(context).msg_info_required
                            : null),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                        initialValue: _property.coveredParking == -1
                            ? null
                            : _property.coveredParking.toString(),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            icon: const Icon(Icons.garage_outlined),
                            labelText: S.of(context).covered_parking),
                        onChanged: (value) => _property.coveredParking =
                            value.isNotEmpty ? int.parse(value) : 0,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => (value == null || value.isEmpty)
                            ? S.of(context).msg_info_required
                            : null),
                  ),
                  Container(width: 16.0),
                  Expanded(
                    child: TextFormField(
                        initialValue: _property.openParking == -1
                            ? null
                            : _property.openParking.toString(),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            icon: const Icon(Icons.local_parking),
                            labelText: S.of(context).open_parking),
                        onChanged: (value) => _property.openParking =
                            value.isNotEmpty ? int.parse(value) : 0,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => (value == null || value.isEmpty)
                            ? S.of(context).msg_info_required
                            : null),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _addressFormController.reset();
    _formKey.currentState!.reset();
    setState(() {
      _property.netArea = -1;
      _property.grossArea = -1;
      _property.bedroom = -1;
      _property.bathroom = -1;
      _property.coveredParking = -1;
      _property.openParking = -1;
    });
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
