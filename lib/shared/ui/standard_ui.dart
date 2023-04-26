import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A collection of function calls to return standardize UIs
class StandardUI {
  static Widget getExpandedIntTextFormField(
      {required int initialValue,
      required String labelText,
      Widget? icon,
      TextInputAction textInputAction = TextInputAction.next,
      required Function(int) onChanged,
      required Function(String?)? validator}) {
    return Expanded(
      child: getIntTextFormField(
          initialValue: initialValue,
          labelText: labelText,
          icon: icon,
          textInputAction: textInputAction,
          onChanged: onChanged,
          validator: validator),
    );
  }

  static Widget getIntTextFormField(
      {required int initialValue,
      required String labelText,
      Widget? icon,
      TextInputAction textInputAction = TextInputAction.next,
      required Function(int) onChanged,
      required Function(String?)? validator}) {
    return TextFormField(
        initialValue: initialValue == -1 ? null : initialValue.toString(),
        keyboardType: TextInputType.number,
        textInputAction: textInputAction,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            icon: icon,
            labelText: labelText),
        onChanged: (value) =>
            onChanged(value.isNotEmpty ? int.parse(value) : 0),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => validator == null ? null : validator(value));
  }
}
