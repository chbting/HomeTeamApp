import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/properties/property.dart';
import 'package:tner_client/properties/visit/property_visit_agreement.dart';
import 'package:tner_client/properties/visit/property_visit_confirmation.dart';
import 'package:tner_client/properties/visit/property_visit_data.dart';
import 'package:tner_client/properties/visit/property_visit_datepicker.dart';
import 'package:tner_client/properties/visit/property_visit_sequencer.dart';
import 'package:tner_client/ui/custom_im_stepper/custom_icon_stepper.dart';
import 'package:tner_client/utils/keyboard_visibility_builder.dart';

class PropertyVisitSchedulingScreen extends StatefulWidget {
  const PropertyVisitSchedulingScreen(
      {Key? key, required this.selectedProperties})
      : super(key: key);

  final List<Property> selectedProperties;
  static const stepTitleBarHeight = 40.0;
  static const buttonHeight = 48.0; // Same as an extended floatingActionButton
  static const buttonSpacing = 16.0;
  static const bottomButtonContainerHeight = buttonHeight + buttonSpacing * 2;

  @override
  State<PropertyVisitSchedulingScreen> createState() =>
      PropertyVisitSchedulingScreenState();
}

class PropertyVisitSchedulingScreenState
    extends State<PropertyVisitSchedulingScreen> {
  final GlobalKey _stepperKey = GlobalKey();
  final PageController _pageController = PageController(initialPage: 0);
  final _totalSteps = 4;
  int _activeStep = 0;
  double _stepTitleBarTopMargin = 0.0;
  bool _isButtonEnabled = true;

  late double _buttonWidth;
  late double _biometricButtonWidth;

  final PropertyVisitData _data = PropertyVisitData();

  @override
  void initState() {
    super.initState();
    _data.propertyList.addAll(widget.selectedProperties);
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
            PropertyVisitSchedulingScreen.buttonSpacing * 3) /
        2;
    _biometricButtonWidth = MediaQuery.of(context).size.width -
        PropertyVisitSchedulingScreen.buttonSpacing * 2;

    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        return Scaffold(
            appBar:
                AppBar(title: Text(S.of(context).schedule_properties_visit)),
            body: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomIconStepper(
                    key: _stepperKey,
                    icons: [
                      Icon(Icons.place,
                          color: Theme.of(context).colorScheme.onSecondary),
                      Icon(Icons.calendar_today,
                          color: Theme.of(context).colorScheme.onSecondary),
                      Icon(Icons.article,
                          color: Theme.of(context).colorScheme.onSecondary),
                      Icon(Icons.check,
                          color: Theme.of(context).colorScheme.onSecondary)
                    ],
                    activeStep: _activeStep,
                    activeStepBorderWidth: 2,
                    activeStepColor: Theme.of(context).colorScheme.secondary,
                    enableNextPreviousButtons: false,
                    enableStepTapping: false,
                    stepRadius:
                        PropertyVisitSchedulingScreen.buttonSpacing * 3 / 2,
                    showStepCompleted: true,
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
                        PropertyVisitSequencerWidget(data: _data),
                        PropertyVisitDatePickerWidget(data: _data),
                        PropertyVisitAgreementWidget(data: _data),
                        PropertyVisitConfirmationWidget(data: _data)
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: PropertyVisitSchedulingScreen.stepTitleBarHeight,
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
                  child: isKeyboardVisible ? null : _getBottomButtons())
            ]));
      },
    );
  }

  String _getStepTitle() {
    switch (_activeStep) {
      case 0:
        return S.of(context).pick_starting_point;
      case 1:
        return S.of(context).pick_datetime;
      case 2:
        return S.of(context).properties_visit_agreement;
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

  void _signWithBiometrics() async {
    final LocalAuthentication localAuth = LocalAuthentication();
    bool canCheckBiometrics = false;
    bool didAuthenticate = false;
    try {
      canCheckBiometrics = await localAuth.canCheckBiometrics;
    } on PlatformException {
      canCheckBiometrics = false;
    } finally {
      if (canCheckBiometrics) {
        try {
          didAuthenticate = await localAuth.authenticate(
              localizedReason:
                  S.of(context).reason_sign_property_visit_agreement,
              options: const AuthenticationOptions(biometricOnly: true));
        } on PlatformException {
          didAuthenticate = false;
        } finally {
          if (didAuthenticate) {
            // case 1: successfully authenticated
            _data.agreementSigned = true;
            _nextStep();
          } else {
            // case 2: authentication failed
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(S.of(context).biometric_authentication_failed)));
          }
        }
      } else {
        // case 3: biometric authentication unavailable
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                S.of(context).biometric_authentication_unavailable_agreement)));
        // todo button bar should move up when the snackBar shows
      }
    }
  }

  void _confirm() {
    // todo
  }

  Widget _getBottomButtons() {
    return Container(
        height: _activeStep == 2
            ? PropertyVisitSchedulingScreen.buttonHeight * 2 +
                PropertyVisitSchedulingScreen.buttonSpacing * 3
            : PropertyVisitSchedulingScreen.buttonHeight +
                PropertyVisitSchedulingScreen.buttonSpacing * 2,
        width: double.infinity,
        padding:
            const EdgeInsets.all(PropertyVisitSchedulingScreen.buttonSpacing),
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
            // Top: biometric authentication button
            Container(
                alignment: Alignment.topCenter,
                child: _activeStep == 2
                    ? ElevatedButton.icon(
                        icon: const Icon(Icons.fingerprint),
                        label: Text(S.of(context).sign_now),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(_biometricButtonWidth,
                                PropertyVisitSchedulingScreen.buttonHeight),
                            shape: const StadiumBorder()),
                        onPressed: () {
                          _isButtonEnabled ? _signWithBiometrics() : null;
                        },
                      )
                    : null),
            // Left: back button
            Container(
                alignment: Alignment.bottomLeft,
                child: _activeStep == 0
                    ? Container()
                    : OutlinedButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        label: Text(S.of(context).back),
                        style: OutlinedButton.styleFrom(
                            minimumSize: Size(_buttonWidth,
                                PropertyVisitSchedulingScreen.buttonHeight),
                            shape: const StadiumBorder(),
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor),
                        onPressed: () {
                          _isButtonEnabled ? _previousStep() : null;
                        },
                      )),
            // Right: next or confirm button
            Container(
                alignment: _activeStep == 0
                    ? Alignment.bottomCenter
                    : Alignment.bottomRight,
                child: _activeStep == 2
                    ? OutlinedButton.icon(
                        icon: const Icon(Icons.redo),
                        label: Text(S.of(context).sign_later),
                        style: OutlinedButton.styleFrom(
                            minimumSize: Size(_buttonWidth,
                                PropertyVisitSchedulingScreen.buttonHeight),
                            shape: const StadiumBorder(),
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor),
                        onPressed: () {
                          if (_isButtonEnabled) {
                            _data.agreementSigned = false;
                            _nextStep();
                          }
                        },
                      )
                    : ElevatedButton.icon(
                        icon: Icon(_activeStep < _totalSteps - 1
                            ? Icons.arrow_forward
                            : Icons.check),
                        label: Text(_activeStep < _totalSteps - 1
                            ? S.of(context).next
                            : S.of(context).confirm),
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(_buttonWidth,
                                PropertyVisitSchedulingScreen.buttonHeight),
                            shape: const StadiumBorder()),
                        onPressed: () {
                          if (_isButtonEnabled) {
                            _activeStep == _totalSteps - 1
                                ? _confirm()
                                : _nextStep();
                          }
                        },
                      ))
          ],
        ));
  }
}