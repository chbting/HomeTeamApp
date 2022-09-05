import 'package:flutter/cupertino.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_info.dart';

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
    return false; // Update via value notifiers instead
  }

  void setActiveStep(int activeStep) {
    ui.activeStep = activeStep;
    updateRightButtonState();
  }

  void updateRightButtonState() {
    if (ui.activeStep != 1) {
      ui.rightButtonEnabled.value = true;
    } else {
      for (var item in info.remodelingItems) {
        if (RemodelingItemHelper.isPictureRequired(item)) {
          if (info.imageMap[item] == null) {
            ui.rightButtonEnabled.value = false;
            return;
          }
        }
      }
      ui.rightButtonEnabled.value = true;
    }
  }
}

class RemodelingSchedulerUI extends ChangeNotifier {
  ValueNotifier<bool> showBottomButtons;
  ValueNotifier<bool> rightButtonEnabled = ValueNotifier(true);
  int activeStep = 0;

  RemodelingSchedulerUI({required this.showBottomButtons});
}
