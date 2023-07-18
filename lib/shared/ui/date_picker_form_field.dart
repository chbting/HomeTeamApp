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
      this.enabled = true,
      this.validator,
      this.onChanged});

  final String labelText, pickerHelpText;
  final String? helperText;
  final DateTime? initialDate;
  final DateTime firstDate, lastDate;
  final String? Function(DateTime? dateTime)? validator;
  final void Function(DateTime dateTime)? onChanged;
  final bool enabled;

  @override
  State<StatefulWidget> createState() => DatePickerFormFieldState();
}

class DatePickerFormFieldState extends State<DatePickerFormField> {
  late TextEditingController _controller;

  @override
  void initState() {
    String initialDateText = widget.initialDate == null
        ? ''
        : Format.date.format(widget.initialDate!);
    _controller = TextEditingController(text: initialDateText);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime initialDate = widget.initialDate ?? widget.firstDate;
    // Failsafe check
    if (initialDate.isBefore(widget.firstDate)) {
      initialDate = widget.firstDate;
    }
    return TextFormField(
        controller: _controller,
        enabled: widget.enabled,
        keyboardType: TextInputType.none,
        showCursor: false,
        enableInteractiveSelection: false,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: widget.labelText,
            helperText: widget.helperText,
            helperMaxLines: 2),
        onTap: () {
          showDatePicker(
                  context: context,
                  helpText: widget.pickerHelpText,
                  initialDate: initialDate,
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
        validator: (String? value) {
          if (!widget.enabled || widget.validator == null) {
            return null;
          } else {
            if (value == null || value.isEmpty) {
              return widget.validator!(null);
            } else {
              return widget.validator!(Format.date.parse(value));
            }
          }
        });
  }
}
