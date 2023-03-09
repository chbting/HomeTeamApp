import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/ui/shared/form_controller.dart';
import 'package:hometeam_client/json_model/tenant.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({Key? key, required this.client, required this.controller})
      : super(key: key);

  final Tenant client;
  final FormController controller;

  @override
  State<StatefulWidget> createState() => ContactFormState();
}

class ContactFormState extends State<ContactForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _lastNameFieldFocus = FocusNode();
  final FocusNode _firstNameFieldFocus = FocusNode();

  @override
  void initState() {
    widget.controller.validate = _validate;
    _lastNameFieldFocus.addListener(() {
      setState(() {});
    });
    _firstNameFieldFocus.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _lastNameFieldFocus.removeListener(() {});
    _lastNameFieldFocus.dispose();
    _firstNameFieldFocus.removeListener(() {});
    _firstNameFieldFocus.dispose();
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 40.0,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Icon(
                        Icons.person_outline,
                        color: (_lastNameFieldFocus.hasFocus ||
                                _firstNameFieldFocus.hasFocus)
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).iconTheme.color,
                      )),
                ),
                Expanded(
                  child: TextFormField(
                      initialValue: widget.client.lastName ?? '',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      focusNode: _lastNameFieldFocus,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: S.of(context).last_name),
                      onChanged: (value) {
                        widget.client.lastName = value;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return (value == null || value.isEmpty)
                            ? S.of(context).msg_info_required
                            : null;
                      }),
                ),
                Container(width: 16.0),
                Expanded(
                  // todo validate
                  child: DropdownButtonFormField<String>(
                    hint: Text(S.of(context).title),
                    isExpanded: true,
                    value: widget.client.title,
                    onChanged: (String? newValue) =>
                        setState(() => widget.client.title = newValue!),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) =>
                        value == null ? S.of(context).msg_info_required : null,
                    items: <String>[
                      S.of(context).mr,
                      S.of(context).mrs,
                      S.of(context).miss,
                      S.of(context).ms
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
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: TextFormField(
                  initialValue: widget.client.firstName ?? '',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  focusNode: _firstNameFieldFocus,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: S.of(context).first_name),
                  onChanged: (value) => widget.client.firstName = value,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? S.of(context).msg_info_required
                        : null;
                  }),
            ),
            TextFormField(
                initialValue: widget.client.phoneNumber,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                maxLength: 8,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: S.of(context).contact_number,
                    helperText: S.of(context).hong_kong_number_only,
                    icon: const Icon(Icons.phone)),
                onChanged: (value) => widget.client.phoneNumber = value,
                validator: (value) =>
                    (value == null || value.isEmpty || value.length < 8)
                        ? S.of(context).msg_info_required
                        : null),
          ],
        ));
  }

  bool _validate() => _formKey.currentState!.validate();
}
