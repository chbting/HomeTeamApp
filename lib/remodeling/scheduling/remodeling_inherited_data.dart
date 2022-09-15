import 'package:flutter/cupertino.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_info.dart';

class RemodelingInheritedData extends InheritedWidget {
  const RemodelingInheritedData(
      {Key? key,
      required Widget child,
      required this.info,
      required this.uiState})
      : super(key: key, child: child);

  final RemodelingInfo info;
  final RemodelingSchedulerUIState uiState;

  static RemodelingInheritedData? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<RemodelingInheritedData>();

  @override
  bool updateShouldNotify(covariant RemodelingInheritedData oldWidget) {
    return false; // Update via value notifiers instead
  }

  void setActiveStep(int activeStep) {
    uiState.activeStep = activeStep;
    updateRightButtonState();
  }

  void updateRightButtonState() {
    if (uiState.activeStep != 1) {
      uiState.rightButtonEnabled.value = true;
    } else {
      for (var item in info.remodelingItems) {
        if (RemodelingItemHelper.isPictureRequired(item)) {
          if (info.imageMap[item] == null) {
            uiState.rightButtonEnabled.value = false;
            return;
          }
        }
      }
      uiState.rightButtonEnabled.value = true;
    }
  }
}

class RemodelingSchedulerUIState {
  ValueNotifier<bool> showBottomButtons;
  ValueNotifier<bool> rightButtonEnabled = ValueNotifier(true);
  int activeStep = 0;

  RemodelingSchedulerUIState({required this.showBottomButtons});
}
