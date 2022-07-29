import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_confirmation.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_contacts.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_date_picker.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_options.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduling_data.dart';
import 'package:tner_client/ui/custom_im_stepper/custom_icon_stepper.dart';
import 'package:tner_client/utils/keyboard_visibility_builder.dart';
import 'package:tner_client/utils/text_helper.dart';

class RemodelingSchedulingScreen extends StatefulWidget {
  const RemodelingSchedulingScreen({Key? key, required this.selectionMap})
      : super(key: key);

  final Map<RemodelingItem, bool> selectionMap;
  static const stepTitleBarHeight = 40.0;
  static const buttonHeight = 48.0; // Same as an extended floatingActionButton
  static const buttonSpacing = 16.0;
  static const bottomButtonContainerHeight = buttonHeight + buttonSpacing * 2;

  @override
  State<RemodelingSchedulingScreen> createState() =>
      RemodelingSchedulingScreenState();
}

class RemodelingSchedulingScreenState
    extends State<RemodelingSchedulingScreen> {
  final GlobalKey _stepperKey = GlobalKey();
  final PageController _pageController = PageController(initialPage: 0);
  final _totalSteps = 4;
  int _activeStep = 0;
  double _stepTitleBarTopMargin = 0.0;
  bool _isButtonEnabled = true;

  late double _buttonWidth;

  final RemodelingSchedulingData _data = RemodelingSchedulingData();

  // For options
  bool _remodelingOptionsAtBottom = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final box = _stepperKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        _stepTitleBarTopMargin = box.size.height - 1; // -1 rounding error?
      });
    });

    widget.selectionMap.forEach((item, value) {
      if (value) {
        _data.selectedItemList.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO backpressed warning: quit scheduling?

    _buttonWidth = (MediaQuery.of(context).size.width -
            RemodelingSchedulingScreen.buttonSpacing * 3) /
        2;
    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        return Scaffold(
            appBar: AppBar(
                title: Text(TextHelper.s.schedule_remodeling)),
            body: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomIconStepper(
                    key: _stepperKey,
                    icons: [
                      Icon(Icons.style,
                          color: Theme.of(context).colorScheme.onSecondary),
                      Icon(Icons.calendar_today,
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
                      children: [
                        RemodelingOptionsWidget(
                            data: _data,
                            callBack: (value) {
                              setState(() {
                                _remodelingOptionsAtBottom = value;
                              });
                            }),
                        RemodelingDatePickerWidget(data: _data),
                        RemodelingContactsWidget(data: _data),
                        RemodelingConfirmationWidget(data: _data)
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: RemodelingSchedulingScreen.stepTitleBarHeight,
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
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Theme.of(context).colorScheme.secondary))),
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: isKeyboardVisible ||
                          (_activeStep == 0 && !_remodelingOptionsAtBottom)
                      ? null
                      : _getBottomButtons())
            ]));
      },
    );
  }

  String _getStepTitle() {
    switch (_activeStep) {
      case 0:
        return TextHelper.s.remodeling_options;
      case 1:
        return TextHelper.s.pick_a_day;
      case 2:
        return TextHelper.s.remodeling_address_and_contacts;
      case 3:
        return TextHelper.s.confirm;
      default:
        return '';
    }
  }

  void _nextStep() {
    if (_activeStep < _totalSteps - 1) {
      _isButtonEnabled = false;
      setState(() {
        _activeStep++;
      });
      _pageController
          .nextPage(
              duration: const Duration(milliseconds: 250), curve: Curves.easeIn)
          .whenComplete(() => _isButtonEnabled = true);
    }
  }

  void _previousStep() {
    if (_activeStep > 0) {
      _isButtonEnabled = false;
      setState(() {
        _activeStep--;
      });
      _pageController
          .previousPage(
              duration: const Duration(milliseconds: 250), curve: Curves.easeIn)
          .whenComplete(() => _isButtonEnabled = true);
    }
  }

  Widget _getBottomButtons() {
    return Container(
        height: RemodelingSchedulingScreen.bottomButtonContainerHeight,
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
            padding:
                const EdgeInsets.all(RemodelingSchedulingScreen.buttonSpacing),
            child: Row(
              mainAxisAlignment: _activeStep == 0
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                _activeStep == 0
                    ? Container()
                    : OutlinedButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        label: Text(TextHelper.s.back),
                        style: OutlinedButton.styleFrom(
                            minimumSize: Size(_buttonWidth,
                                RemodelingSchedulingScreen.buttonHeight),
                            shape: const StadiumBorder(),
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor),
                        onPressed: () {
                          _isButtonEnabled ? _previousStep() : null;
                        }),
                ElevatedButton.icon(
                    icon: Icon(_activeStep < _totalSteps - 1
                        ? Icons.arrow_forward
                        : Icons.check),
                    label: Text(_activeStep < _totalSteps - 1
                        ? TextHelper.s.next
                        : TextHelper.s.confirm_remodeling),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(_buttonWidth,
                          RemodelingSchedulingScreen.buttonHeight),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      if (_isButtonEnabled) {
                        if (_activeStep == _totalSteps - 1) {
                          // todo validate
                          // todo send order
                        } else {
                          _nextStep();
                        }
                      }
                    })
              ],
            )));
  }
}
