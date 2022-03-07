import 'package:flutter/material.dart';
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

  @override
  State<RemodelingSchedulingScreen> createState() =>
      RemodelingSchedulingScreenState();
}

class RemodelingSchedulingScreenState
    extends State<RemodelingSchedulingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final _totalSteps = 4;
  int _activeStep = 0;

  final RemodelingSchedulingData _data = RemodelingSchedulingData();

  // For options
  bool _remodelingOptionsAtBottom = false;

  @override
  void initState() {
    super.initState();
    widget.selectionMap.forEach((item, value) {
      if (value) {
        _data.selectedItemList.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO backpressed warning: quit scheduling?
    return KeyboardVisibilityBuilder(
      builder: (context, child, isKeyboardVisible) {
        return Scaffold(
            appBar: AppBar(
                title: Text(TextHelper.appLocalizations.schedule_remodeling)),
            floatingActionButton: Visibility(
                visible: _activeStep == 0 &&
                        _remodelingOptionsAtBottom &&
                        !isKeyboardVisible
                    ? true
                    : false,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    _nextStep();
                    // todo check data
                  },
                  label: Text(TextHelper.appLocalizations.next),
                  icon: const Icon(Icons.arrow_forward),
                )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconStepper(
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
                _bottomButtons(isKeyboardVisible)
              ],
            ));
      },
    );
  }

  String _getStepTitle() {
    switch (_activeStep) {
      case 0:
        return TextHelper.appLocalizations.remodeling_options;
      case 1:
        return TextHelper.appLocalizations.pick_a_day;
      case 2:
        return TextHelper.appLocalizations.remodeling_address_and_contacts;
      case 3:
        return TextHelper.appLocalizations.confirm;
      default:
        return '';
    }
  }

  void _nextStep() {
    if (_activeStep < _totalSteps - 1) {
      //FocusScope.of(context).unfocus(); // Close keyboard
      setState(() {
        _activeStep++;
      });
      _pageController.nextPage(
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    }
  }

  void _previousStep() {
    if (_activeStep > 0) {
      //FocusScope.of(context).unfocus(); // Close keyboard
      setState(() {
        _activeStep--;
      });
      _pageController.previousPage(
          duration: const Duration(milliseconds: 250), curve: Curves.easeIn);
    }
  }

  Widget _bottomButtons(bool isKeyboardVisible) {
    if (_activeStep == 0 || isKeyboardVisible) {
      return Container();
    } else {
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
                  _previousStep();
                },
              ),
              ElevatedButton.icon(
                icon: Icon(_activeStep < _totalSteps - 1
                    ? Icons.arrow_forward
                    : Icons.check),
                label: Text(_activeStep < _totalSteps - 1
                    ? TextHelper.appLocalizations.next
                    : TextHelper.appLocalizations.confirm_remodeling),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                        MediaQuery.of(context).size.width / 2 - 24.0, 48.0),
                    shape: const StadiumBorder()),
                onPressed: () {
                  if (_activeStep == _totalSteps - 1) {
                    // todo send order
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
