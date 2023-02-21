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

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 24.0;
    double buttonWidth =
        MediaQuery.of(context).size.width - horizontalPadding * 2;

    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                minimumSize: Size(buttonWidth, 48.0),
                backgroundColor: backgroundColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0))),
            child: Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(icon)),
                Align(
                    alignment: Alignment.center,
                    child: Text(label,
                        style: Theme.of(context).textTheme.titleMedium))
              ],
            )));
  }
}
