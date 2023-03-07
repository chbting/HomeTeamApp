import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/scheduler.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/tenant/rentals/visit/visit_agreement.dart';
import 'package:hometeam_client/tenant/rentals/visit/visit_data.dart';
import 'package:hometeam_client/utils/keyboard_visibility_builder.dart';

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
  final Duration _transitionDuration = const Duration(milliseconds: 250);

  int _activeStep = 0;
  double _stepTitleBarTopMargin = 0.0;
  bool _isButtonEnabled = true;

  late int _totalSteps;
  late double _buttonWidth;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final stepper =
          _stepperKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        _stepTitleBarTopMargin = stepper.size.height - 1; // -1 rounding error?
        debugPrint('top margin:$_stepTitleBarTopMargin');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO backpressed warning: quit scheduling?
    final steps = [
      EasyStep(
          icon: const Icon(Icons.apartment),
          title: S.of(context).property_info),
      EasyStep(
          icon: const Icon(Icons.camera_alt), title: S.of(context).add_photos),
      EasyStep(
          icon: const Icon(Icons.format_list_bulleted_add),
          title: S.of(context).create_listing),
      EasyStep(icon: const Icon(Icons.check), title: S.of(context).confirm),
    ];
    _totalSteps = steps.length;
    _buttonWidth = (MediaQuery.of(context).size.width -
            PropertyUploader.buttonSpacing * 3) /
        2;

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
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: EasyStepper(
                        key: _stepperKey,
                        steps: steps,
                        activeStep: _activeStep,
                        borderThickness: 8.0,
                        padding: 0.0,
                        lineLength: 48.0,
                        lineSpace: 6.0,
                        enableStepTapping: false,
                        showLoadingAnimation: false,
                        lineColor: Theme.of(context).colorScheme.onSurface,
                        finishedStepIconColor:
                            Theme.of(context).colorScheme.onPrimary,
                        stepAnimationCurve: Curves.bounceOut,
                        stepAnimationDuration: _transitionDuration,
                        onStepReached: (index) =>
                            setState(() => _activeStep = index)),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        VisitAgreementWidget(
                            data: VisitData(
                                properties: [],
                                optimizedPath: [],
                                selectedPath: [],
                                travelMap: {})),
                        const Center(child: Text('2')),
                        const Center(child: Text('3')),
                        const Center(child: Text('4')),
                      ],
                    ),
                  ),
                ],
              ),
              // Container(
              //   width: double.infinity,
              //   height: VisitSchedulingScreen.stepTitleBarHeight,
              //   margin: EdgeInsets.only(top: _stepTitleBarTopMargin),
              //   decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //           begin: Alignment.bottomCenter,
              //           end: const Alignment(0.0, 0.5),
              //           colors: [
              //         Theme.of(context)
              //             .scaffoldBackgroundColor
              //             .withOpacity(0.0),
              //         Theme.of(context).scaffoldBackgroundColor
              //       ])),
              // ),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: isKeyboardVisible ? null : _getBottomButtons())
            ]));
      },
    );
  }

  void _nextStep() {
    if (_activeStep < _totalSteps - 1) {
      _isButtonEnabled = false;
      setState(() {
        _activeStep++;
      });
      _pageController
          .nextPage(duration: _transitionDuration, curve: Curves.easeIn)
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
          .previousPage(duration: _transitionDuration, curve: Curves.easeIn)
          .whenComplete(() => _isButtonEnabled = true);
    }
  }

  void _confirm() {
    // todo
  }

  Widget _getBottomButtons() {
    return Container(
        height:
            PropertyUploader.buttonHeight + PropertyUploader.buttonSpacing * 2,
        width: double.infinity,
        padding: const EdgeInsets.all(PropertyUploader.buttonSpacing),
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
                      minimumSize:
                          Size(_buttonWidth, PropertyUploader.buttonHeight),
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
                  icon: Icon(_activeStep == _totalSteps - 1
                      ? Icons.check
                      : Icons.arrow_forward),
                  label: Text(_activeStep == _totalSteps - 1
                      ? S.of(context).confirm
                      : S.of(context).next),
                  style: FilledButton.styleFrom(
                      minimumSize:
                          Size(_buttonWidth, PropertyUploader.buttonHeight),
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
