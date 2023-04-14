import 'package:flutter/material.dart';
import 'package:hometeam_client/utils/format.dart';

class DatePickerTextFormField extends StatefulWidget {
  const DatePickerTextFormField(
      {super.key,
      this.labelText,
      this.helpText,
      required this.initialDate,
      required this.firstDate,
      required this.lastDate,
      this.validator,
      required this.onChanged});

  final String? labelText, helpText;
  final DateTime initialDate, firstDate, lastDate;
  final String? Function(DateTime dateTime)? validator;
  final void Function(DateTime dateTime) onChanged;

  @override
  State<StatefulWidget> createState() => DatePickerTextFormFieldState();
}

class DatePickerTextFormFieldState extends State<DatePickerTextFormField> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller =
        TextEditingController(text: Format.date.format(widget.initialDate));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: _controller,
        keyboardType: TextInputType.none,
        showCursor: false,
        enableInteractiveSelection: false,
        decoration: InputDecoration(
            border: const OutlineInputBorder(), labelText: widget.labelText),
        onTap: () {
          showDatePicker(
                  context: context,
                  helpText: widget.helpText,
                  initialDate: widget.initialDate,
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate)
              .then((value) {
            if (value != null) {
              _controller.text = Format.date.format(value);
              widget.onChanged(value);
            }
          });
        },
        validator: (value) {
          var dateTime = Format.date.parse(value!);
          return widget.validator == null ? null : widget.validator!(dateTime);
        });
  }
}
