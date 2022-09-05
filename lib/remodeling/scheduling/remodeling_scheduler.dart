import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_confirmation.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_contacts.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_images.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_info.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_inherited_data.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_options.dart';
import 'package:tner_client/ui/custom_im_stepper/custom_icon_stepper.dart';
import 'package:tner_client/utils/keyboard_visibility_builder.dart';

class RemodelingScheduler extends StatefulWidget {
  const RemodelingScheduler({Key? key, required this.remodelingItems})
      : super(key: key);

  final List<RemodelingItem> remodelingItems;
  static const stepTitleBarHeight = 40.0;
  static const buttonHeight = 48.0; // Same as an extended floatingActionButton
  static const buttonSpacing = 16.0;
  static const bottomButtonContainerHeight = buttonHeight + buttonSpacing * 2;

  @override
  State<RemodelingScheduler> createState() => RemodelingSchedulerState();
}

class RemodelingSchedulerState extends State<RemodelingScheduler> {
  late RemodelingInheritedData _data;
  final GlobalKey _stepperKey = GlobalKey();
  final PageController _pageController = PageController(initialPage: 0);
  final _totalSteps = 4;
  int _activeStep = 0;
  double _stepTitleBarTopMargin = 0.0;
  bool _bottomButtonEnabled = true;

  late double _buttonWidth;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final box = _stepperKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        _stepTitleBarTopMargin = box.size.height - 1; // -1 rounding error?
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO backpressed warning: quit scheduling?
    _buttonWidth = (MediaQuery.of(context).size.width -
            RemodelingScheduler.buttonSpacing * 3) /
        2;
    return RemodelingInherited(
        info: RemodelingInfo(remodelingItems: widget.remodelingItems),
        ui: RemodelingSchedulerUI(
            showBottomButtons:
                widget.remodelingItems.length == 1 ? true : false,
            rightButtonEnabled: true),
        child: KeyboardVisibilityBuilder(
            builder: (context, child, isKeyboardVisible) {
          _data = RemodelingInheritedData.of(context)!;
          return Scaffold(
              appBar: AppBar(title: Text(S.of(context).schedule_remodeling)),
              body: Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomIconStepper(
                      key: _stepperKey,
                      icons: [
                        Icon(Icons.style,
                            color: Theme.of(context).colorScheme.onSecondary),
                        Icon(Icons.camera_alt,
                            color: Theme.of(context).colorScheme.onSecondary),
                        Icon(Icons.contact_phone,
                            color: Theme.of(context).colorScheme.onSecondary),
                        Icon(Icons.check,
                            color: Theme.of(context).colorScheme.onSecondary)
                      ],
                      activeStep: _activeStep,
                      activeStepBorderWidth: 2,
                      activeStepColor: Theme.of(context).colorScheme.secondary,
                      enableNextPreviousButtons: false,
                      enableStepTapping: false,
                      showStepCompleted: true,
                      stepRadius: 24.0,
                      lineColor: Colors.grey,
                      onStepReached: (index) {
                        setState(() {
                          _activeStep = index;
                        });
                      },
                    ),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          RemodelingOptionsWidget(),
                          RemodelingImagesWidget(),
                          RemodelingContactsWidget(),
                          RemodelingConfirmationWidget()
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: RemodelingScheduler.stepTitleBarHeight,
                  margin: EdgeInsets.only(top: _stepTitleBarTopMargin),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: const Alignment(0.0, 0.5),
                          colors: [
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.0),
                        Theme.of(context).scaffoldBackgroundColor
                      ])),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Text(_getStepTitle(),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary))),
                ),
                Container(
                    alignment: Alignment.bottomCenter,
                    child: !isKeyboardVisible &&
                            RemodelingInheritedData.of(context)!
                                .ui
                                .showBottomButtons
                        ? _getBottomButtons(context)
                        : null) //todo sometimes it is not properly built, not showing the button or show half of the previous button
              ]));
        }));
  }

  String _getStepTitle() {
    switch (_activeStep) {
      case 0:
        return S.of(context).remodeling_options;
      case 1:
        return S.of(context).take_pictures;
      case 2:
        return S.of(context).remodeling_address_and_contacts;
      case 3:
        return S.of(context).confirm;
      default:
        return '';
    }
  }

  void _nextStep() {
    if (_activeStep < _totalSteps - 1) {
      _bottomButtonEnabled = false;
      setState(() {
        _activeStep++;
      });
      _pageController
          .nextPage(
              duration: const Duration(milliseconds: 250), curve: Curves.easeIn)
          .whenComplete(() => _bottomButtonEnabled = true);
    }
  }

  void _previousStep() {
    if (_activeStep > 0) {
      _bottomButtonEnabled = false;
      setState(() {
        _activeStep--;
      });
      _pageController
          .previousPage(
              duration: const Duration(milliseconds: 250), curve: Curves.easeIn)
          .whenComplete(() => _bottomButtonEnabled = true);
    }
  }

  Widget _getBottomButtons(BuildContext context) {
    return Container(
        height: RemodelingScheduler.bottomButtonContainerHeight,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0)
            ])),
        child: Padding(
            padding: const EdgeInsets.all(RemodelingScheduler.buttonSpacing),
            child: Row(
              mainAxisAlignment: _activeStep == 0
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                // Left button
                _activeStep == 0
                    ? Container()
                    : OutlinedButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        label: Text(S.of(context).back),
                        style: OutlinedButton.styleFrom(
                            minimumSize: Size(
                                _buttonWidth, RemodelingScheduler.buttonHeight),
                            shape: const StadiumBorder(),
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor),
                        onPressed: () {
                          _bottomButtonEnabled ? _previousStep() : null;
                        }),
                //Right button
                ElevatedButton.icon(
                    icon: Icon(_activeStep < _totalSteps - 1
                        ? Icons.arrow_forward
                        : Icons.check),
                    label: Text(_activeStep < _totalSteps - 1
                        ? S.of(context).next
                        : S.of(context).confirm_remodeling),
                    style: ElevatedButton.styleFrom(
                      minimumSize:
                          Size(_buttonWidth, RemodelingScheduler.buttonHeight),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: !_data.ui.rightButtonEnabled
                        ? null // This null makes the button to grey out
                        : () {
                            // The check here won't grey out the button
                            if (_bottomButtonEnabled) {
                              if (_activeStep == _totalSteps - 1) {
                                // todo validate on step 3
                                // todo send order on step 4
                              } else {
                                _nextStep();
                              }
                            }
                          })
              ],
            )));
  }

// todo the child setState doesn't cause this to run
// void _updateRightButtonState() {
//   if (_activeStep != 1) {
//     _rightButtonEnabled = true;
//   } else {
//     for (var item in _data.selectedItemList) {
//       if (RemodelingItemHelper.isPictureRequired(item)) {
//         if (_data.imageMap[item] == null) {
//           _rightButtonEnabled = false;
//           return;
//         }
//       }
//     }
//     _rightButtonEnabled = true;
//   }
// }
}
