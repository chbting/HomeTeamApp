import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/tenant/rentals/visit/visit_scheduler.dart';
import 'package:tner_client/ui/shared/custom_im_stepper/first_stepper/icon_stepper.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/keyboard_visibility_builder.dart';

class PropertyUploader extends StatefulWidget {
  const PropertyUploader({Key? key}) : super(key: key);

  static const stepTitleBarHeight = 40.0;
  static const buttonHeight = 48.0; // Same as an extended floatingActionButton
  static const buttonSpacing = 16.0;
  static const bottomButtonContainerHeight = buttonHeight + buttonSpacing * 2;

  @override
  State<StatefulWidget> createState() => PropertyUploaderState();
}

class PropertyUploaderState extends State<PropertyUploader> {
  final GlobalKey _stepperKey = GlobalKey();
  final PageController _pageController = PageController(initialPage: 0);
  final _totalSteps = 4;
  int _activeStep = 0;
  double _stepTitleBarTopMargin = 0.0;
  bool _isButtonEnabled = true;

  late double _buttonWidth;

  final int durationPerProperty = 900; // 15 minutes

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
            VisitSchedulingScreen.buttonSpacing * 3) /
        2;
    var stepIconColor = Theme.of(context).colorScheme.onPrimary;

    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        return Scaffold(
            appBar: AppBar(
                title: Text(S.of(context).add_property),
                leading: const CloseButton()),
            body: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomIconStepper(
                    key: _stepperKey,
                    icons: [
                      Icon(Icons.apartment, color: stepIconColor),
                      Icon(Icons.camera_alt, color: stepIconColor),
                      Icon(Icons.format_list_bulleted_add,
                          color: stepIconColor),
                      Icon(Icons.check, color: stepIconColor)
                    ],
                    activeStep: _activeStep,
                    activeStepBorderWidth: 2,
                    activeStepColor: Theme.of(context).colorScheme.primary,
                    enableNextPreviousButtons: false,
                    enableStepTapping: false,
                    stepRadius: VisitSchedulingScreen.buttonSpacing * 3 / 2,
                    showIsStepCompleted: true,
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
                        Center(child: Text('1')),
                        Center(child: Text('2')),
                        Center(child: Text('3')),
                        Center(child: Text('4')),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: VisitSchedulingScreen.stepTitleBarHeight,
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
                        style: AppTheme.getStepTitleTextStyle(context))),
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: isKeyboardVisible ? null : _getBottomButtons())
            ]));
      },
    );
  }

  String _getStepTitle() {
    switch (_activeStep) {
      case 0:
        return S.of(context).property_info;
      case 1:
        return S.of(context).add_photos;
      case 2:
        return S.of(context).create_listing;
      case 3:
        return S.of(context).confirm;
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

  void _confirm() {
    // todo
  }

  Widget _getBottomButtons() {
    return Container(
        height: VisitSchedulingScreen.buttonHeight +
            VisitSchedulingScreen.buttonSpacing * 2,
        width: double.infinity,
        padding: const EdgeInsets.all(VisitSchedulingScreen.buttonSpacing),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0)
            ])),
        child: Stack(
          children: [
            Container(
                alignment: Alignment.bottomLeft,
                child: OutlinedButton.icon(
                  icon: Icon(_activeStep == 0 ? Icons.undo : Icons.arrow_back),
                  label: Text(_activeStep == 0
                      ? S.of(context).reset
                      : S.of(context).back),
                  style: OutlinedButton.styleFrom(
                      minimumSize: Size(
                          _buttonWidth, VisitSchedulingScreen.buttonHeight),
                      shape: const StadiumBorder(),
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor),
                  onPressed: () {
                    _isButtonEnabled
                        ? (_activeStep == 0
                            ? null // todo
                            : _previousStep())
                        : null;
                  },
                )),
            // Right: next or confirm button
            Container(
                alignment: Alignment.bottomRight,
                child: FilledButton.icon(
                  icon: Icon(_activeStep < _totalSteps - 1
                      ? Icons.arrow_forward
                      : Icons.check),
                  label: Text(_activeStep < _totalSteps - 1
                      ? S.of(context).next
                      : S.of(context).confirm),
                  style: FilledButton.styleFrom(
                      minimumSize: Size(
                          _buttonWidth, VisitSchedulingScreen.buttonHeight),
                      shape: const StadiumBorder()),
                  onPressed: () {
                    if (_isButtonEnabled) {
                      _activeStep == _totalSteps - 1 ? _confirm() : _nextStep();
                    }
                  },
                ))
          ],
        ));
  }
}
