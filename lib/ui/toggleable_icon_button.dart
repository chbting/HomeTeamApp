import 'package:flutter/material.dart';

class ToggleableIconButton extends StatefulWidget {
  const ToggleableIconButton(
      {required this.startIcon,
      required this.endIcon,
      this.duration = const Duration(milliseconds: 250),
      this.beginWithStartIcon = true,
      this.toggleOnPressed = true,
      this.iconSize = 24.0,
      this.splashRadius = 20.0,
      this.onStartPressed,
      this.onEndPressed,
      this.isStartButtonNotifier,
      Key? key})
      : super(key: key);

  final IconData startIcon, endIcon;
  final Duration duration;
  final bool beginWithStartIcon;
  final bool toggleOnPressed;
  final double iconSize, splashRadius;
  final VoidCallback? onStartPressed, onEndPressed;
  final ValueNotifier<bool>? isStartButtonNotifier;

  @override
  State<StatefulWidget> createState() => ToggleableIconButtonState();
}

class ToggleableIconButtonState extends State<ToggleableIconButton> {
  late bool _isStartButton;
  late IconData _iconData;
  bool _updateFinished = true;
  double _iconButtonScale = 1.0;

  @override
  void initState() {
    _isStartButton = widget.beginWithStartIcon;
    _iconData = _isStartButton ? widget.startIcon : widget.endIcon;
    widget.isStartButtonNotifier?.addListener(() {
      _setButton(widget.isStartButtonNotifier!.value);
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.isStartButtonNotifier?.removeListener(() {});
    widget.isStartButtonNotifier?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: widget.iconSize,
        icon: AnimatedScale(
            child: Icon(_iconData, color: Theme.of(context).iconTheme.color),
            duration: widget.duration,
            curve: Curves.easeOut,
            scale: _iconButtonScale,
            onEnd: () {
              if (!_updateFinished) {
                setState(() {
                  // 2. Change the icon
                  _iconData =
                      _isStartButton ? widget.startIcon : widget.endIcon;

                  // 3. Expand the icon
                  _iconButtonScale = 1.0;
                  _updateFinished = true;
                });
              }
            }),
        splashRadius: widget.splashRadius,
        onPressed: () {
          if (widget.toggleOnPressed) {
            // Save value to avoid set button twice
            bool newValue = !_isStartButton;

            // I. Execute the defined codes
            _isStartButton
                ? widget.onStartPressed?.call()
                : widget.onEndPressed?.call();

            // II. Update icon state
            _setButton(newValue);
          } else {
            _isStartButton
                ? widget.onStartPressed?.call()
                : widget.onEndPressed?.call();
          }
        });
  }

  void _setButton(bool isStart) {
    if (_isStartButton != isStart) {
      _isStartButton = isStart;

      setState(() {
        //1. Shrink the icon
        _updateFinished = false;
        _iconButtonScale = 0.0;
      });
    }
  }
}
