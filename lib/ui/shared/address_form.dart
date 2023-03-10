import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/address.dart';
import 'package:hometeam_client/ui/shared/form_controller.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({Key? key, required this.address, required this.controller})
      : super(key: key);

  final Address address;
  final FormController controller;

  @override
  State<StatefulWidget> createState() => AddressFormState();
}

class AddressFormState extends State<AddressForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    widget.controller.reset = _reset;
    widget.controller.validate = _validate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Wrap(
          runSpacing: 16.0,
          children: [
            TextFormField(
              initialValue: widget.address.addressLine1,
              keyboardType: TextInputType.text,
              // todo autocomplete with the gov address api
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: S.of(context).address_line1_label,
                  helperText: S.of(context).address_line1_helper,
                  icon: const Icon(Icons.location_pin)),
              onChanged: (value) => widget.address.addressLine1 = value,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: TextFormField(
                  initialValue: widget.address.addressLine2,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).address_line2_label,
                      helperText: S.of(context).address_line2_helper),
                  onChanged: (value) => widget.address.addressLine2 = value,
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
                        initialValue: widget.address.district,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: S.of(context).district),
                        onChanged: (value) => widget.address.district = value,
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
                      value: widget.address.region.isEmpty
                          ? null
                          : widget.address.region,
                      onChanged: (String? newValue) =>
                          setState(() => widget.address.region = newValue!),
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
      widget.address.addressLine1 = '';
      widget.address.addressLine2 = '';
      widget.address.district = '';
      widget.address.region = '';
    });
  }

  bool _validate() => _formKey.currentState!.validate();
}
