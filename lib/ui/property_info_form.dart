import 'package:flutter/material.dart';
import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/address.dart';
import 'package:hometeam_client/ui/form_controller.dart';
class PropertyInfoForm extends StatefulWidget {
  const PropertyInfoForm(
      {Key? key, required this.property, required this.controller})
      : super(key: key);

  final Property property;
  final FormController controller;

  @override
  State<StatefulWidget> createState() => PropertyInfoFormState();
}

class PropertyInfoFormState extends State<PropertyInfoForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _addressLine1FieldFocus = FocusNode();
  final FocusNode _addressLine2FieldFocus = FocusNode();
  final FocusNode _districtFieldFocus = FocusNode();

  @override
  void initState() {
    widget.controller.reset = _reset;
    widget.controller.validate = _validate;
    _addressLine1FieldFocus.addListener(() {
      setState(() {});
    });
    _addressLine2FieldFocus.addListener(() {
      setState(() {});
    });
    _districtFieldFocus.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _addressLine1FieldFocus.removeListener(() {});
    _addressLine1FieldFocus.dispose();
    _addressLine2FieldFocus.removeListener(() {});
    _addressLine2FieldFocus.dispose();
    _districtFieldFocus.removeListener(() {});
    _districtFieldFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Wrap(
          runSpacing: 16.0,
          children: [
            TextFormField(
              initialValue: widget.property.netArea.toString(),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              focusNode: _addressLine1FieldFocus,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: S.of(context).address_line1_label,
                  helperText: S.of(context).address_line1_helper,
                  icon: Icon(Icons.location_pin,
                      color: (_addressLine1FieldFocus.hasPrimaryFocus ||
                              _addressLine2FieldFocus.hasFocus ||
                              _districtFieldFocus.hasFocus)
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).iconTheme.color)),
              onChanged: (value) =>
                  widget.property.address.addressLine1 = value,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: TextFormField(
                  initialValue: widget.property.address.addressLine2,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  focusNode: _addressLine2FieldFocus,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).address_line2_label,
                      helperText: S.of(context).address_line2_helper),
                  onChanged: (value) =>
                      widget.property.address.addressLine2 = value,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => (value == null || value.isEmpty)
                      ? S.of(context).msg_info_required
                      : null),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextFormField(
                        initialValue: widget.property.address.district,
                        keyboardType: TextInputType.text,
                        focusNode: _districtFieldFocus,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: S.of(context).district),
                        onChanged: (value) =>
                            widget.property.address.district = value,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => (value == null || value.isEmpty)
                            ? S.of(context).msg_info_required
                            : null),
                  ),
                  Container(width: 16.0),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      hint: Text(S.of(context).region),
                      isExpanded: true,
                      value: widget.property.address.region,
                      onChanged: (String? newValue) => setState(
                          () => widget.property.address.region = newValue!),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value == null
                          ? S.of(context).msg_info_required
                          : null,
                      items: Address.getRegions(context)
                          .map<DropdownMenuItem<String>>((String region) {
                        return DropdownMenuItem<String>(
                          value: region,
                          child: Text(region),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  void _reset() {
    _formKey.currentState!.reset();
    setState(() {
      widget.property.address.addressLine1 = '';
      widget.property.address.addressLine2 = '';
      widget.property.address.district = '';
      widget.property.address.region = '';
    });
  }

  bool _validate() => _formKey.currentState!.validate();
}
