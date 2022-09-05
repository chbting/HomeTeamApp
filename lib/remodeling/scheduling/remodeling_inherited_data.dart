import 'package:flutter/cupertino.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_info.dart';

class RemodelingInherited extends StatefulWidget {
  const RemodelingInherited(
      {Key? key, required this.info, required this.ui, required this.child})
      : super(key: key);

  final RemodelingInfo info;
  final RemodelingSchedulerUI ui;
  final Widget child;

  @override
  State<StatefulWidget> createState() => RemodelingInheritedState();
}

class RemodelingInheritedState extends State<RemodelingInherited> {
  void onChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build');
    return RemodelingInheritedData(
        info: widget.info, ui: widget.ui, child: widget.child);
  }
}

class RemodelingInheritedData extends InheritedWidget {
  const RemodelingInheritedData(
      {Key? key, required Widget child, required this.info, required this.ui})
      : super(key: key, child: child);

  final RemodelingInfo info;
  final RemodelingSchedulerUI ui;

  static RemodelingInheritedData? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RemodelingInheritedData>();

  @override
  bool updateShouldNotify(covariant RemodelingInheritedData oldWidget) {
    return true;
  }
}

class RemodelingSchedulerUI {
  bool showBottomButtons;
  bool rightButtonEnabled;

  RemodelingSchedulerUI(
      {required this.showBottomButtons, required this.rightButtonEnabled});
}
