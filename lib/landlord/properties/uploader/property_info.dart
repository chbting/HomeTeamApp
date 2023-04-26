import 'package:flutter/material.dart';
import 'package:hometeam_client/data/appliance.dart';
import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/shared/listing_inherited_data.dart';
import 'package:hometeam_client/shared/ui/address_form.dart';
import 'package:hometeam_client/shared/ui/form_controller.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';
import 'package:hometeam_client/shared/ui/standard_ui.dart';

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
  final appliancesWithBoolValue = ApplianceHelper.valuesWithBoolValue();
  late Function(String?) standardValidator;
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
    standardValidator = (value) => (value == null || value.isEmpty)
        ? S.of(context).msg_info_required
        : null;

    return Form(
      key: _formKey,
      child: ListView(
        primary: false,
        shrinkWrap: true,
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, bottom: StandardStepper.bottomMargin),
        children: [
          StandardStepper.getSectionTitle(
              context, S.of(context).property_address,
              verticalPadding: 16.0),
          AddressForm(
              address: _property.address, controller: _addressFormController),
          const Divider(),
          _getPhysicalInfoSection(context),
          const Divider(),
          _getAppliancesSection(context)
        ],
      ),
    );
  }

  Widget _getPhysicalInfoSection(BuildContext context) {
    return Wrap(
      runSpacing: 16.0,
      children: [
        StandardStepper.getSectionTitle(context, S.of(context).property_info,
            bottomPadding: 0.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StandardUI.getExpandedIntTextFormField(
                initialValue: _property.netArea,
                labelText: '${S.of(context).area_net} (${S.of(context).sq_ft})',
                onChanged: (value) => _property.netArea = value,
                validator: standardValidator),
            const SizedBox(width: 16.0),
            StandardUI.getExpandedIntTextFormField(
                initialValue: _property.grossArea,
                labelText:
                    '${S.of(context).area_gross} (${S.of(context).sq_ft})',
                onChanged: (value) => _property.grossArea = value,
                validator: standardValidator),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StandardUI.getExpandedIntTextFormField(
                initialValue: _property.bedroom,
                labelText: S.of(context).bedroom,
                icon: const Icon(Icons.bed_outlined),
                onChanged: (value) => _property.bedroom = value,
                validator: standardValidator),
            const SizedBox(width: 16.0),
            StandardUI.getExpandedIntTextFormField(
                initialValue: _property.bathroom,
                labelText: S.of(context).bathroom,
                icon: const Icon(Icons.bathtub_outlined),
                onChanged: (value) => _property.bathroom = value,
                validator: standardValidator),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StandardUI.getExpandedIntTextFormField(
                initialValue: _property.coveredParking,
                labelText: S.of(context).covered_parking,
                icon: const Icon(Icons.garage_outlined),
                onChanged: (value) => _property.coveredParking = value,
                validator: standardValidator),
            const SizedBox(width: 16.0),
            StandardUI.getExpandedIntTextFormField(
                initialValue: _property.openParking,
                labelText: S.of(context).open_parking,
                icon: const Icon(Icons.local_parking),
                onChanged: (value) => _property.openParking = value,
                validator: standardValidator),
          ],
        ),
      ],
    );
  }

  Widget _getAppliancesSection(BuildContext context) {
    return Wrap(
      runSpacing: 16.0,
      children: [
        StandardStepper.getSectionTitle(
            context, S.of(context).electrical_appliances,
            bottomPadding: 0.0),
        Row(children: [
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: StandardUI.getIntTextFormField(
                    initialValue: _property.appliances[Appliance.ac]!,
                    labelText: S.of(context).ac,
                    onChanged: (value) =>
                        _property.appliances[Appliance.ac] = value,
                    validator: standardValidator),
              )),
          const Expanded(flex: 1, child: SizedBox())
        ]),
        GridView.builder(
            shrinkWrap: true,
            primary: false,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 3.0),
            // childAspectRatio: 3 = (MediaQuery.of(context).size.width - 32.0 {horizontalPadding}) / crossAxisCount / (48.0 {ListTileHeight} + 16.0 {verticalPadding})
            itemCount: Appliance.values.length - 1,
            itemBuilder: (BuildContext context, int index) {
              var appliance = appliancesWithBoolValue[index];
              return Align(
                alignment: Alignment.centerLeft,
                child: CheckboxListTile(
                    title: Text(ApplianceHelper.getName(context, appliance)),
                    value: _property.appliances[appliance],
                    onChanged: (value) => setState(
                        () => _property.appliances[appliance] = value)),
              );
            }),
      ],
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
