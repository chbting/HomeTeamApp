import 'package:flutter/material.dart';
import 'package:hometeam_client/data/address.dart';
import 'package:hometeam_client/generated/l10n.dart';
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
              initialValue: widget.address.addressLine1 ?? '',
              keyboardType: TextInputType.text,
              // todo autocomplete with the gov address api
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
              onChanged: (value) => widget.address.addressLine1 = value,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: TextFormField(
                  initialValue: widget.address.addressLine2,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  focusNode: _addressLine2FieldFocus,
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
                        focusNode: _districtFieldFocus,
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
                    child: DropdownButtonFormField<Region>(
                      hint: Text(S.of(context).region),
                      isExpanded: true,
                      value: widget.address.region,
                      onChanged: (Region? newValue) =>
                          setState(() => widget.address.region = newValue!),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value == null
                          ? S.of(context).msg_info_required
                          : null,
                      items: Region.values
                          .map<DropdownMenuItem<Region>>((Region region) {
                        return DropdownMenuItem<Region>(
                          value: region,
                          child: Text(RegionHelper.getName(context, region)),
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
    setState(() {
      widget.address.addressLine1 = '';
      widget.address.addressLine2 = '';
      widget.address.district = '';
      widget.address.region = null;
    });
  }

  bool _validate() => _formKey.currentState!.validate();
}
