import 'package:flutter/material.dart';
import 'package:hometeam_client/utils/format.dart';

/// If the date needs to be validated, use validator to return the value to
/// the variable, otherwise use onChanged
class DatePickerFormField extends StatefulWidget {
  const DatePickerFormField(
      {super.key,
      required this.labelText,
      required this.pickerHelpText,
      this.helperText,
      required this.initialDate,
      required this.firstDate,
      required this.lastDate,
      this.validator,
      this.onChanged});

  final String labelText, pickerHelpText;
  final String? helperText;
  final DateTime initialDate, firstDate, lastDate;
  final String? Function(DateTime dateTime)? validator;
  final void Function(DateTime dateTime)? onChanged;

  @override
  State<StatefulWidget> createState() => DatePickerFormFieldState();
}

class DatePickerFormFieldState extends State<DatePickerFormField> {
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
            border: const OutlineInputBorder(),
            labelText: widget.labelText,
            helperText: widget.helperText,
            helperMaxLines: 3),
        onTap: () {
          showDatePicker(
                  context: context,
                  helpText: widget.pickerHelpText,
                  initialDate: widget.initialDate,
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate)
              .then((value) {
            if (value != null) {
              _controller.text = Format.date.format(value);
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            }
          });
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          var dateTime = Format.date.parse(value!);
          return widget.validator == null ? null : widget.validator!(dateTime);
        });
  }
}
