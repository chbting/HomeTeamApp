import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/json_model/terms.dart';
import 'package:hometeam_client/ui/form_controller.dart';
import 'package:hometeam_client/ui/terms_item.dart';

class TermsForm extends StatefulWidget {
  const TermsForm(
      {Key? key,
      required this.terms,
      required this.listing,
      required this.controller})
      : super(key: key);

  final Terms terms;
  final Listing listing;
  final FormController controller;

  @override
  State<StatefulWidget> createState() => TermsFormState();
}

class TermsFormState extends State<TermsForm> {
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
            TermsItemWidget.getTitleBar(context),
            TermsItemWidget(
                widget: TextFormField(
                    initialValue: widget.terms.rent == -1
                        ? null
                        : widget.terms.rent.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: S.of(context).monthly_rent),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).please_put_in_a_valid_amount;
                      } else {
                        widget.terms.rent = int.parse(value);
                        return null;
                      }
                    }), // todo pass reference to the checkbox
                termsItemSetting: widget.listing.items[TermsItem.rent]!,
                showToTenantEnabled: false),
          ],
        ));
  }

  void _reset() {
    _formKey.currentState!.reset();
    setState(() {});
  }

  bool _validate() => _formKey.currentState!.validate();
}
