import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:tner_client/remodeling/remodeling_contacts.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/remodeling_options.dart';

import '../shared_preferences_helper.dart';

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

  // For options
  bool _remodelingOptionsAtBottom = false;

  // For date picker
  late DateTime _datePicked;
  final _firstAvailableDay = 2;
  final _schedulingRange = 30;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _datePicked = DateTime(now.year, now.month, now.day + _firstAvailableDay);
  }

  @override
  Widget build(BuildContext context) {
    // TODO backpressed warning: quit scheduling?
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.schedule_remodeling)),
        floatingActionButton: Visibility(
            visible:
                _activeStep == 0 && _remodelingOptionsAtBottom ? true : false,
            child: FloatingActionButton.extended(
              onPressed: () {
                _nextStep();
                // todo perform check and retrieve data
              },
              label: Text(AppLocalizations.of(context)!.next),
              icon: const Icon(Icons.arrow_forward),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconStepper(
              icons: [
                Icon(Icons.style,
                    color: Theme.of(context).colorScheme.onSecondary),
                Icon(Icons.calendar_today,
                    color: Theme.of(context).colorScheme.onSecondary),
                Icon(Icons.contact_phone,
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(_getStepTitle(),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).colorScheme.secondary))),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  RemodelingOptionsWidget(
                      selectionMap: widget.selectionMap,
                      callBack: (value) {
                        setState(() {
                          _remodelingOptionsAtBottom = value;
                        });
                      }),
                  _remodelingDatePickerWidget(),
                  const RemodelingContactsWidget(),
                  _remodelingConfirmationWidget()
                ],
              ),
            ),
            //_bottomButtons() //todo cause next focus scrolling to break
          ],
        ));
  }

  String _getStepTitle() {
    switch (_activeStep) {
      case 0:
        return AppLocalizations.of(context)!.remodeling_options;
      case 1:
        return AppLocalizations.of(context)!.pick_a_day;
      case 2:
        return AppLocalizations.of(context)!.remodeling_address_and_contacts;
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

  Widget _remodelingDatePickerWidget() {
    final now = DateTime.now();
    final firstDate =
        DateTime(now.year, now.month, now.day + _firstAvailableDay);
    final lastDate = DateTime(
        firstDate.year, firstDate.month, firstDate.day + _schedulingRange);
    if (_datePicked.isBefore(firstDate)) {
      _datePicked = firstDate;
    }
    return ListView(
        // note: ListView with CalendarDatePicker has 4.0 internal padding on
        // all sides, thus these values are offset
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
        primary: false,
        children: [
          Card(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: CalendarDatePicker(
                    initialDate: _datePicked,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    onDateChanged: (DateTime value) {
                      setState(() {
                        _datePicked = value;
                      });
                    })),
          ),
          _remodelingDateCard(),
        ]);
  }

  Widget _remodelingConfirmationWidget() {
    return ListView(
      primary: false,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [_remodelingDateCard()],
    );
  }

  Widget _remodelingDateCard() {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            direction: Axis.vertical,
            spacing: 8.0,
            children: [
              Text(
                AppLocalizations.of(context)!.remodeling_start_date,
                style: Theme.of(context).textTheme.caption,
              ),
              Text(
                DateFormat.yMMMMEEEEd(
                        SharedPreferencesHelper().getLocale().languageCode)
                    .format(_datePicked),
                style: Theme.of(context).textTheme.subtitle1,
              )
            ],
          )),
    );
  }

  Widget _bottomButtons() {
    // todo should not go up when keyboard shows
    if (_activeStep == 0) {
      return Container();
    } else {
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
                    : AppLocalizations.of(context)!.confirm_remodeling),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                        MediaQuery.of(context).size.width / 2 - 24.0, 48.0),
                    shape: const StadiumBorder()),
                onPressed: () {
                  setState(() {
                    if (_activeStep == _totalSteps - 1) {
                      // todo send order
                    } else {
                      _nextStep();
                    }
                  });
                },
              )
            ],
          ));
    }
  }
}
