import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/http_request/place_autocomplete_helper.dart';
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
  final GlobalKey _addressLine1Key = GlobalKey();
  final _iconPadding = 40.0;
  double _suggestionWidgetWidth = 0.0;
  late TextEditingController _addressLine1Controller,
      _addressLine2Controller,
      _districtController;

  @override
  void initState() {
    widget.controller.reset = _reset;
    widget.controller.validate = _validate;
    _addressLine1Controller =
        TextEditingController(text: widget.address.addressLine1);
    _addressLine2Controller =
        TextEditingController(text: widget.address.addressLine2);
    _districtController = TextEditingController(text: widget.address.district);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _addressLine1Key.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        _suggestionWidgetWidth = renderBox.size.width;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _districtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Wrap(
          runSpacing: 16.0,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.location_pin,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                Container(width: 16.0),
                Expanded(
                  child: TextFormField(
                      initialValue: widget.address.flat,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: S.of(context).address_flat),
                      onChanged: (value) => widget.address.flat = value),
                ),
                Container(width: 16.0),
                Expanded(
                  child: TextFormField(
                      initialValue: widget.address.floor,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: S.of(context).address_floor),
                      onChanged: (value) => widget.address.floor = value),
                )
              ],
            ),
            Autocomplete<Address>(
                optionsBuilder: (TextEditingValue textEdit) =>
                    PlaceAutocompleteHelper.getSuggestions(
                        context, textEdit.text),
                optionsViewBuilder: (context, onSelect, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: _iconPadding),
                      child: Material(
                        child: SizedBox(
                          width: _suggestionWidgetWidth,
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: options.length,
                              itemBuilder: (context, index) {
                                Address address = options.elementAt(index);
                                String title = address.addressLine1.isNotEmpty
                                    ? address.addressLine1
                                    : address.addressLine2;
                                String subtitle = address
                                        .addressLine1.isNotEmpty
                                    ? '${address.addressLine2}, ${address.district.isNotEmpty ? address.district : address.region}'
                                    : address.district.isNotEmpty
                                        ? address.district
                                        : address.region;
                                return ListTile(
                                  onTap: () =>
                                      onSelect(options.elementAt(index)),
                                  title: Text(title),
                                  subtitle: Text(subtitle),
                                );
                              }),
                        ),
                      ),
                    ),
                  );
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController textEditingController,
                    FocusNode focusNode,
                    VoidCallback onFieldSubmitted) {
                  return Padding(
                    padding: EdgeInsets.only(left: _iconPadding),
                    child: TextFormField(
                      key: _addressLine1Key,
                      controller: _addressLine1Controller,
                      focusNode: focusNode,
                      keyboardType: TextInputType.streetAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) => onFieldSubmitted(),
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: S.of(context).address_line1_label,
                          helperText: S.of(context).address_line1_helper),
                      onChanged: (value) {
                        textEditingController.text = value;
                        widget.address.addressLine1 = value;
                      },
                    ),
                  );
                },
                onSelected: (address) {
                  _addressLine1Controller.text = address.addressLine1;
                  _addressLine2Controller.text = address.addressLine2;
                  _districtController.text = address.district;

                  setState(() {
                    widget.address.addressLine1 = address.addressLine1;
                    widget.address.addressLine2 = address.addressLine2;
                    widget.address.district = address.district;
                    widget.address.region = address.region;
                  });
                  FocusManager.instance.primaryFocus?.unfocus();
                }),
            Padding(
              padding: EdgeInsets.only(left: _iconPadding),
              child: TextFormField(
                  controller: _addressLine2Controller,
                  keyboardType: TextInputType.streetAddress,
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
              padding: EdgeInsets.only(left: _iconPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: _districtController,
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
