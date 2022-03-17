import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tner_client/properties/property.dart';
import 'package:tner_client/properties/visit/properties_visit_argeement.dart';
import 'package:tner_client/properties/visit/properties_visit_confirmation.dart';
import 'package:tner_client/properties/visit/properties_visit_data.dart';
import 'package:tner_client/properties/visit/properties_visit_datepicker.dart';
import 'package:tner_client/properties/visit/properties_visit_starting_point.dart';
import 'package:tner_client/ui/custom_im_stepper/custom_icon_stepper.dart';
import 'package:tner_client/utils/keyboard_visibility_builder.dart';
import 'package:tner_client/utils/text_helper.dart';

class PropertiesVisitSchedulingScreen extends StatefulWidget {
  const PropertiesVisitSchedulingScreen(
      {Key? key, required this.selectedProperties})
      : super(key: key);

  final List<Property> selectedProperties;
  static const stepTitleBarHeight = 40.0;
  static const bottomButtonContainerHeight = 48.0 + 16.0 * 2;

  @override
  State<PropertiesVisitSchedulingScreen> createState() =>
      PropertiesVisitSchedulingScreenState();
}

class PropertiesVisitSchedulingScreenState
    extends State<PropertiesVisitSchedulingScreen> {
  final GlobalKey _stepperKey = GlobalKey();
  final PageController _pageController = PageController(initialPage: 0);
  final _totalSteps = 4;
  int _activeStep = 0;
  double _stepTitleBarTopMargin = 0.0;
  bool _isButtonEnabled = true;

  final PropertiesVisitData _data = PropertiesVisitData();

  @override
  void initState() {
    super.initState();
    _data.propertyList.addAll(widget.selectedProperties);
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      final box = _stepperKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        _stepTitleBarTopMargin = box.size.height - 1; // -1 rounding error?
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO backpressed warning: quit scheduling?
    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        return Scaffold(
            appBar: AppBar(
                title: Text(
                    TextHelper.appLocalizations.schedule_properties_visit)),
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
                    stepRadius: 24.0,
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
                        PropertiesVisitStartingPointWidget(data: _data),
                        PropertiesVisitDatePickerWidget(data: _data),
                        PropertiesVisitAgreementWidget(data: _data),
                        PropertiesVisitConfirmationWidget(data: _data)
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: PropertiesVisitSchedulingScreen.stepTitleBarHeight,
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
        return TextHelper.appLocalizations.pick_starting_point;
      case 1:
        return TextHelper.appLocalizations.pick_datetime;
      case 2:
        return TextHelper.appLocalizations.properties_visit_agreement;
      case 3:
        return TextHelper.appLocalizations.confirm;
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
    bool canCheckBiometrics, didAuthenticate;
    try {
      canCheckBiometrics = await localAuth.canCheckBiometrics;
    } on PlatformException {
      canCheckBiometrics = false;
    }

    if (canCheckBiometrics) {
      try {
        didAuthenticate = await localAuth.authenticate(
            localizedReason: TextHelper
                .appLocalizations.reason_sign_property_visit_agreement,
            biometricOnly: true);
      } on PlatformException {
        didAuthenticate = false;
      }

      if (didAuthenticate) {
        // case 1: successfully authenticated
        _data.agreementSigned = true;
        _nextStep();
      } else {
        // case 2: authentication failed
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                TextHelper.appLocalizations.biometric_authentication_failed)));
      }
    } else {
      // case 3: biometric authentication unavailable
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(TextHelper.appLocalizations
              .biometric_authentication_unavailable_agreement)));
      // todo button bar should move up when the snackBar shows
    }
  }

  void _confirm() {
    // todo
  }

  Widget _getBottomButtons() {
    switch (_activeStep) {
      case 0:
        return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: Text(TextHelper.appLocalizations.next),
              style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width / 2 - 24.0, 48.0),
                  shape: const StadiumBorder()),
              onPressed: () {
                _isButtonEnabled ? _nextStep() : null;
              },
            ));
      case 2:
        return Container(
            height: 48.0 + 48.0 + 16.0 * 3,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
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
                    alignment: Alignment.topCenter,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.fingerprint),
                      label: Text(TextHelper.appLocalizations.sign_now),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(
                              MediaQuery.of(context).size.width - 32.0, 48.0),
                          shape: const StadiumBorder()),
                      onPressed: () {
                        _isButtonEnabled ? _signWithBiometrics() : null;
                      },
                    )),
                Container(
                    alignment: Alignment.bottomLeft,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: Text(TextHelper.appLocalizations.back),
                      style: OutlinedButton.styleFrom(
                          minimumSize: Size(
                              MediaQuery.of(context).size.width / 2 - 24.0,
                              48.0),
                          // 48.0 is the height of extended fab
                          shape: const StadiumBorder(),
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor),
                      onPressed: () {
                        _isButtonEnabled ? _previousStep() : null;
                      },
                    )),
                Container(
                    alignment: Alignment.bottomRight,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.redo),
                      label: Text(TextHelper.appLocalizations.sign_later),
                      style: OutlinedButton.styleFrom(
                          minimumSize: Size(
                              MediaQuery.of(context).size.width / 2 - 24.0,
                              48.0),
                          // 48.0 is the height of extended fab
                          shape: const StadiumBorder(),
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor),
                      onPressed: () {
                        if (_isButtonEnabled) {
                          _data.agreementSigned = false;
                          _nextStep();
                        }
                      },
                    ))
              ],
            ));
      default:
        return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  label: Text(TextHelper.appLocalizations.back),
                  style: OutlinedButton.styleFrom(
                      minimumSize: Size(
                          MediaQuery.of(context).size.width / 2 - 24.0, 48.0),
                      // 48.0 is the height of extended fab
                      shape: const StadiumBorder()),
                  onPressed: () {
                    _isButtonEnabled ? _previousStep() : null;
                  },
                ),
                ElevatedButton.icon(
                  icon: Icon(_activeStep < _totalSteps - 1
                      ? Icons.arrow_forward
                      : Icons.check),
                  label: Text(_activeStep < _totalSteps - 1
                      ? TextHelper.appLocalizations.next
                      : TextHelper.appLocalizations.confirm),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(
                          MediaQuery.of(context).size.width / 2 - 24.0, 48.0),
                      shape: const StadiumBorder()),
                  onPressed: () {
                    if (_isButtonEnabled) {
                      _activeStep == _totalSteps - 1 ? _confirm() : _nextStep();
                    }
                  },
                )
              ],
            ));
    }
  }
}
