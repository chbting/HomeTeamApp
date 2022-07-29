import 'package:flutter/material.dart';
import 'package:tner_client/ui/theme.dart';

class InkWellButton extends StatelessWidget {
  const InkWellButton({Key? key, required this.text, this.icon, this.onTap})
      : super(key: key);

  final String text;
  final IconData? icon;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 4.0,
            children: [
              icon == null
                  // A null width causes the button to take up the whole row
                  ? Container(width: 0.0)
                  : Icon(icon, color: AppTheme.getInkWellButtonColor(context)),
              Text(text, style: AppTheme.getInkWellButtonTextStyle(context))
            ],
          ),
        ));
  }
}
