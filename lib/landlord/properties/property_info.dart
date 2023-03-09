import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            body: Wrap(
              runSpacing: 16.0,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                          initialValue: widget.property.netArea == -1
                              ? null
                              : widget.property.netArea.toString(),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText:
                                  '${S.of(context).area_net} (${S.of(context).sq_ft})'),
                          onChanged: (value) =>
                              widget.property.netArea = int.parse(value),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => (value == null || value.isEmpty)
                              ? S.of(context).msg_info_required
                              : null),
                    ),
                    Container(width: 16.0),
                    Expanded(
                      child: TextFormField(
                          initialValue: widget.property.grossArea == -1
                              ? null
                              : widget.property.grossArea.toString(),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText:
                                  '${S.of(context).area_gross} (${S.of(context).sq_ft})'),
                          onChanged: (value) =>
                              widget.property.grossArea = int.parse(value),
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
                          initialValue: widget.property.room == -1
                              ? null
                              : widget.property.room.toString(),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              icon: const Icon(Icons.bed_outlined),
                              labelText: S.of(context).room_count),
                          onChanged: (value) =>
                              widget.property.room = int.parse(value),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => (value == null || value.isEmpty)
                              ? S.of(context).msg_info_required
                              : null),
                    ),
                    Container(width: 16.0),
                    Expanded(
                      child: TextFormField(
                          initialValue: widget.property.bathroom == -1
                              ? null
                              : widget.property.bathroom.toString(),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              icon: const Icon(Icons.bathtub_outlined),
                              labelText: S.of(context).bathroom_count),
                          onChanged: (value) =>
                              widget.property.grossArea = int.parse(value),
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
                          initialValue: widget.property.coveredParking == -1
                              ? null
                              : widget.property.coveredParking.toString(),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              icon: const Icon(Icons.garage),
                              labelText: S.of(context).covered_parking_count),
                          onChanged: (value) =>
                              widget.property.coveredParking = int.parse(value),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => (value == null || value.isEmpty)
                              ? S.of(context).msg_info_required
                              : null),
                    ),
                    Container(width: 16.0),
                    Expanded(
                      child: TextFormField(
                          initialValue: widget.property.openParking == -1
                              ? null
                              : widget.property.openParking.toString(),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              icon: const Icon(Icons.local_parking),
                              labelText: S.of(context).open_parking_count),
                          onChanged: (value) =>
                              widget.property.openParking = int.parse(value),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => (value == null || value.isEmpty)
                              ? S.of(context).msg_info_required
                              : null),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _resetForm() {
    _addressFormController.reset();
    _formKey.currentState!.reset();
    setState(() {
      widget.property.netArea = -1;
      widget.property.grossArea = -1;
      widget.property.room = -1;
      widget.property.bathroom = -1;
      widget.property.coveredParking = -1;
      widget.property.openParking = -1;
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
