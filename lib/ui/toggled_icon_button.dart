import 'package:flutter/material.dart';

class ToggleableIconButton extends StatefulWidget {
  const ToggleableIconButton(
      {required this.startIcon,
      required this.endIcon,
      this.duration = const Duration(milliseconds: 250),
      this.beginWithStartIcon = true,
      this.iconSize = 24.0,
      this.splashRadius = 24.0,
      this.onStartPress,
      this.onEndPress,
      Key? key})
      : super(key: key);

  final IconData startIcon, endIcon;
  final Duration duration;
  final bool beginWithStartIcon;
  final double iconSize, splashRadius;
  final VoidCallback? onStartPress, onEndPress;

  @override
  State<StatefulWidget> createState() => ToggleableIconButtonState();
}

class ToggleableIconButtonState extends State<ToggleableIconButton> {
  late bool _isStart;
  late IconData _iconData;
  bool _updateFinished = true;
  double _iconButtonScale = 1.0;

  @override
  void initState() {
    _isStart = widget.beginWithStartIcon;
    _iconData = _isStart ? widget.startIcon : widget.endIcon;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        iconSize: widget.iconSize,
        icon: AnimatedScale(
            child: Icon(_iconData),
            duration: widget.duration,
            curve: Curves.easeIn,
            scale: _iconButtonScale,
            onEnd: () {
              if (!_updateFinished) {
                // 2. Execute the defined codes
                if (_isStart) {
                  if (widget.onStartPress != null) {
                    widget.onStartPress!();
                  }
                } else {
                  if (widget.onEndPress != null) {
                    widget.onEndPress!();
                  }
                }
                setState(() {
                  // 3. Change the icon
                  _isStart = !_isStart;
                  _iconData = _isStart ? widget.startIcon : widget.endIcon;

                  // 4. Expand the icon
                  _iconButtonScale = 1.0;
                  _updateFinished = true;
                });
              }
            }),
        splashRadius: widget.splashRadius,
        onPressed: () {
          if (_updateFinished) {
            setState(() {
              //1. Shrink the icon
              _updateFinished = false;
              _iconButtonScale = 0.0;
            });
          }
        });
  }
}
