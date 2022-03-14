import 'package:flutter/material.dart';
import 'package:tner_client/utils/client_data.dart';
import 'package:tner_client/utils/text_helper.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({Key? key, required this.data}) : super(key: key);

  final ClientData data;

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
    _addressLine2FieldFocus.removeListener(() {});
    _districtFieldFocus.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Wrap(
          runSpacing: 16.0,
          children: [
            TextFormField(
              // todo auto complete with the gov api
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              focusNode: _addressLine1FieldFocus,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: TextHelper.appLocalizations.address_line1_label,
                  helperText: TextHelper.appLocalizations.address_line1_helper,
                  icon: Icon(Icons.location_pin,
                      color: (_addressLine1FieldFocus.hasPrimaryFocus ||
                              _addressLine2FieldFocus.hasFocus ||
                              _districtFieldFocus.hasFocus)
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).iconTheme.color)),
              onChanged: (value) {
                widget.data.addressLine1 = value;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: TextFormField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  focusNode: _addressLine2FieldFocus,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText:
                          TextHelper.appLocalizations.address_line2_label,
                      helperText:
                          TextHelper.appLocalizations.address_line2_helper),
                  onChanged: (value) {
                    widget.data.addressLine2 = value;
                  },
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? TextHelper.appLocalizations.info_required
                        : null;
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextFormField(
                        keyboardType: TextInputType.text,
                        focusNode: _districtFieldFocus,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: TextHelper.appLocalizations.district),
                        onChanged: (value) {
                          widget.data.district = value;
                        },
                        validator: (value) {
                          return (value == null || value.isEmpty)
                              ? TextHelper.appLocalizations.info_required
                              : null;
                        }),
                  ),
                  Container(width: 16.0),
                  Expanded(
                    child: DropdownButton<String>(
                      hint: Text(TextHelper.appLocalizations.region),
                      isExpanded: true,
                      value: widget.data.region,
                      onChanged: (String? newValue) {
                        setState(() {
                          widget.data.region = newValue!;
                        });
                      },
                      items: <String>[
                        TextHelper.appLocalizations.hong_kong,
                        TextHelper.appLocalizations.kowloon,
                        TextHelper.appLocalizations.new_territories
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
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

  bool validate() => _formKey.currentState!.validate();
}
