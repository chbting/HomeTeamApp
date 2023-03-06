import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/utils/client_data.dart';

class AddressForm extends StatefulWidget {
  const AddressForm({Key? key, required this.data}) : super(key: key);

  final Client data;

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
              initialValue: widget.data.addressLine1 ?? '',
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
              onChanged: (value) {
                widget.data.addressLine1 = value;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: TextFormField(
                  initialValue: widget.data.addressLine2 ?? '',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  focusNode: _addressLine2FieldFocus,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).address_line2_label,
                      helperText: S.of(context).address_line2_helper),
                  onChanged: (value) {
                    widget.data.addressLine2 = value;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? S.of(context).info_required
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
                        initialValue: widget.data.district ?? '',
                        keyboardType: TextInputType.text,
                        focusNode: _districtFieldFocus,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: S.of(context).district),
                        onChanged: (value) {
                          widget.data.district = value;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          return (value == null || value.isEmpty)
                              ? S.of(context).info_required
                              : null;
                        }),
                  ),
                  Container(width: 16.0),
                  Expanded(
                    child: DropdownButton<String>(
                      hint: Text(S.of(context).region),
                      isExpanded: true,
                      value: widget.data.region, //todo validate
                      onChanged: (String? newValue) {
                        setState(() {
                          widget.data.region = newValue!;
                        });
                      },
                      items: <String>[
                        S.of(context).hong_kong,
                        S.of(context).kowloon,
                        S.of(context).new_territories
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
