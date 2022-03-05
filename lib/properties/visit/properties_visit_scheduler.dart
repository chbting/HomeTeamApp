import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:im_stepper/stepper.dart';
import 'package:tner_client/properties/property.dart';
import 'package:tner_client/properties/visit/properties_visit_argeement.dart';
import 'package:tner_client/properties/visit/properties_visit_confirmation.dart';
import 'package:tner_client/properties/visit/properties_visit_data.dart';
import 'package:tner_client/properties/visit/properties_visit_datepicker.dart';
import 'package:tner_client/properties/visit/properties_visit_starting_point.dart';
import 'package:tner_client/utils/keyboard_visibility_builder.dart';

class PropertiesVisitSchedulingScreen extends StatefulWidget {
  const PropertiesVisitSchedulingScreen(
      {Key? key, required this.selectedProperties})
      : super(key: key);

  final List<Property> selectedProperties;

  @override
  State<PropertiesVisitSchedulingScreen> createState() =>
      PropertiesVisitSchedulingScreenState();
}

class PropertiesVisitSchedulingScreenState
    extends State<PropertiesVisitSchedulingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final _totalSteps = 4;
  int _activeStep = 0;

  final PropertiesVisitData _data = PropertiesVisitData();

  @override
  void initState() {
    super.initState();
    _data.propertyList.addAll(widget.selectedProperties);
  }

  @override
  Widget build(BuildContext context) {
    // TODO backpressed warning: quit scheduling?
    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        return Scaffold(
            appBar: AppBar(
                title: Text(
                    AppLocalizations.of(context)!.schedule_properties_visit)),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconStepper(
                  icons: [
                    Icon(Icons.place,
                        color: Theme.of(context).colorScheme.onSecondary),
                    Icon(Icons.calendar_today,
                        color: Theme.of(context).colorScheme.onSecondary),
                    Icon(Icons.description,
                        color: Theme.of(context).colorScheme.onSecondary),
                    Icon(Icons.grading,
                        color: Theme.of(context).colorScheme.onSecondary)
                  ],
                  activeStep: _activeStep,
                  activeStepBorderWidth: 0,
                  activeStepBorderPadding: 0,
                  activeStepColor: Theme.of(context).colorScheme.secondary,
                  enableNextPreviousButtons: false,
                  enableStepTapping: false,
                  stepRadius: 24.0,
                  lineColor: Colors.grey,
                  onStepReached: (index) {
                    setState(() {
                      _activeStep = index;
                    });
                  },
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Text(_getStepTitle(),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Theme.of(context).colorScheme.secondary))),
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
                _bottomButtons(isKeyboardVisible)
              ],
            ));
      },
    );
  }

  String _getStepTitle() {
    switch (_activeStep) {
      case 0:
        return AppLocalizations.of(context)!.pick_starting_point;
      case 1:
        return AppLocalizations.of(context)!.pick_datetime;
      case 2:
        return AppLocalizations.of(context)!.properties_visit_agreement;
      case 3:
        return AppLocalizations.of(context)!.confirm;
      default:
        return '';
    }
  }

  void _nextStep() {
    if (_activeStep < _totalSteps - 1) {
      FocusScope.of(context).unfocus(); // Close keyboard
      setState(() {
        _activeStep++;
      });
      _pageController.nextPage(
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    }
  }

  void _previousStep() {
    if (_activeStep > 0) {
      FocusScope.of(context).unfocus(); // Close keyboard
      setState(() {
        _activeStep--;
      });
      _pageController.previousPage(
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    }
  }

  void _confirm() {
    // todo
  }

  Widget _bottomButtons(bool isKeyboardVisible) {
    if (isKeyboardVisible) {
      return Container();
    } else {
      switch (_activeStep) {
        case 0:
          return Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(AppLocalizations.of(context)!.next),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                            MediaQuery.of(context).size.width / 2 - 24.0, 48.0),
                        shape: const StadiumBorder()),
                    onPressed: () {
                      setState(() {
                        _nextStep();
                      });
                    },
                  )));
        case 2:
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.fingerprint),
                    label: Text(AppLocalizations.of(context)!.sign_now),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                            MediaQuery.of(context).size.width - 32.0, 48.0),
                        shape: const StadiumBorder()),
                    onPressed: () {
                      _nextStep();
                    },
                  ),
                  Container(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        label: Text(AppLocalizations.of(context)!.back),
                        style: OutlinedButton.styleFrom(
                            minimumSize: Size(
                                MediaQuery.of(context).size.width / 2 - 24.0, 48.0),
                            // 48.0 is the height of extended fab
                            shape: const StadiumBorder()),
                        onPressed: () {
                          _previousStep();
                        },
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.redo),
                        label: Text(AppLocalizations.of(context)!.sign_later),
                        style: OutlinedButton.styleFrom(
                            minimumSize: Size(
                                MediaQuery.of(context).size.width / 2 - 24.0, 48.0),
                            // 48.0 is the height of extended fab
                            shape: const StadiumBorder()),
                        onPressed: () {
                          _nextStep();
                        },
                      ),
                    ],
                  )
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
                    label: Text(AppLocalizations.of(context)!.back),
                    style: OutlinedButton.styleFrom(
                        minimumSize: Size(
                            MediaQuery.of(context).size.width / 2 - 24.0, 48.0),
                        // 48.0 is the height of extended fab
                        shape: const StadiumBorder()),
                    onPressed: () {
                      _previousStep();
                    },
                  ),
                  ElevatedButton.icon(
                    icon: Icon(_activeStep < _totalSteps - 1
                        ? Icons.arrow_forward
                        : Icons.check),
                    label: Text(_activeStep < _totalSteps - 1
                        ? AppLocalizations.of(context)!.next
                        : AppLocalizations.of(context)!.confirm),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                            MediaQuery.of(context).size.width / 2 - 24.0, 48.0),
                        shape: const StadiumBorder()),
                    onPressed: () {
                      if (_activeStep == _totalSteps - 1) {
                        _confirm();
                      } else {
                        _nextStep();
                      }
                    },
                  )
                ],
              ));
      }
    }
  }
}
