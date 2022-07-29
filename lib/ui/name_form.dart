import 'package:flutter/material.dart';
import 'package:tner_client/utils/client_data.dart';
import 'package:tner_client/utils/text_helper.dart';

class NameForm extends StatefulWidget {
  const NameForm({Key? key, required this.client}) : super(key: key);

  final Client client;

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
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      focusNode: _lastNameFieldFocus,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: TextHelper.s.last_name),
                      onChanged: (value) {
                        widget.client.lastName = value;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return (value == null || value.isEmpty)
                            ? TextHelper.s.info_required
                            : null;
                      }),
                ),
                Container(width: 16.0),
                Expanded(
                  child: DropdownButton<String>(
                    hint: Text(TextHelper.s.title),
                    isExpanded: true,
                    value: widget.client.title,
                    onChanged: (String? newValue) {
                      setState(() {
                        widget.client.title = newValue!;
                      });
                    },
                    items: <String>[
                      TextHelper.s.mr,
                      TextHelper.s.mrs,
                      TextHelper.s.miss,
                      TextHelper.s.ms
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
                      labelText: TextHelper.s.first_name),
                  onChanged: (value) {
                    widget.client.firstName = value;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return (value == null || value.isEmpty)
                        ? TextHelper.s.info_required
                        : null;
                  }),
            )
          ],
        ));
  }

  bool validate() => _formKey.currentState!.validate();
}
