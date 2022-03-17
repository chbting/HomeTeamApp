import 'package:flutter/material.dart';
import 'package:tner_client/utils/client_data.dart';
import 'package:tner_client/utils/text_helper.dart';

class NameForm extends StatefulWidget {
  const NameForm({Key? key, required this.data}) : super(key: key);

  final ClientData data;

  @override
  State<StatefulWidget> createState() => NameFormState();
}

class NameFormState extends State<NameForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _lastNameFieldFocus = FocusNode();
  final FocusNode _firstNameFieldFocus = FocusNode();

  @override
  void initState() {
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
    _firstNameFieldFocus.removeListener(() {});
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
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      focusNode: _lastNameFieldFocus,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: TextHelper.appLocalizations.last_name),
                      onChanged: (value) {
                        widget.data.lastName = value;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return (value == null || value.isEmpty)
                            ? TextHelper.appLocalizations.info_required
                            : null;
                      }),
                ),
                Container(width: 16.0),
                Expanded(
                  child: DropdownButton<String>(
                    hint: Text(TextHelper.appLocalizations.title),
                    isExpanded: true,
                    value: widget.data.title,
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.data.title = newValue!;
                      });
                    },
                    items: <String>[
                      TextHelper.appLocalizations.mr,
                      TextHelper.appLocalizations.mrs,
                      TextHelper.appLocalizations.miss,
                      TextHelper.appLocalizations.ms
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
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  focusNode: _firstNameFieldFocus,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: TextHelper.appLocalizations.first_name),
                  onChanged: (value) {
                    widget.data.firstName = value;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? TextHelper.appLocalizations.info_required
                        : null;
                  }),
            )
          ],
        ));
  }

  bool validate() => _formKey.currentState!.validate();
}
