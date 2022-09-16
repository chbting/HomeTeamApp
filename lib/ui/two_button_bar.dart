import 'package:flutter/material.dart';

class TwoButtonBar extends StatelessWidget {
  const TwoButtonBar(
      {Key? key,
      required this.leftButtonLabel,
      required this.leftButtonIcon,
      this.onLeftButtonPressed,
      required this.rightButtonLabel,
      required this.rightButtonIcon,
      this.onRightButtonPressed})
      : super(key: key);

  final Widget leftButtonLabel;
  final Widget leftButtonIcon;
  final VoidCallback? onLeftButtonPressed;
  final Widget rightButtonLabel;
  final Widget rightButtonIcon;
  final VoidCallback? onRightButtonPressed;

  final buttonHeight = 48.0; // Same as an extended floatingActionButton
  final buttonSpacing = 16.0;
  final padding = 16.0;

  @override
  Widget build(BuildContext context) {
    var buttonWidth =
        (MediaQuery.of(context).size.width - buttonSpacing - padding * 2) / 2;

    return Container(
      height: buttonHeight + padding * 2,
      width: double.infinity,
      // Create a gradient background for the button bar to make scrolling in
      // tje parent more user friendly
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
            Theme.of(context).scaffoldBackgroundColor,
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0)
          ])),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left button
            OutlinedButton.icon(
                icon: leftButtonIcon,
                label: leftButtonLabel,
                style: OutlinedButton.styleFrom(
                    minimumSize: Size(buttonWidth, buttonHeight),
                    shape: const StadiumBorder(),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor),
                onPressed: onLeftButtonPressed),
            //Right button
            ElevatedButton.icon(
                icon: rightButtonIcon,
                label: rightButtonLabel,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(buttonWidth, buttonHeight),
                  shape: const StadiumBorder(),
                ),
                onPressed: onRightButtonPressed)
          ],
        ),
      ),
    );
  }
}
