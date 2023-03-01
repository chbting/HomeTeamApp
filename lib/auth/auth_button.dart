import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  const AuthButton(
      {Key? key,
      this.icon,
      required this.label,
      this.backgroundColor,
      this.onPressed})
      : super(key: key);

  final IconData? icon;
  final String label;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  final _horizontalPadding = 24.0;

  @override
  Widget build(BuildContext context) {
    double buttonWidth =
        MediaQuery.of(context).size.width - _horizontalPadding * 2;

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: FilledButton.tonal(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
                minimumSize: Size(buttonWidth, 48.0),
                backgroundColor: backgroundColor,
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0))),
            child: Stack(
              children: <Widget>[
                Align(alignment: Alignment.centerLeft, child: Icon(icon)),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .fontSize),
                    ))
              ],
            )));
  }
}
