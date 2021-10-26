import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
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

class RemodelingSchedulingScreenState extends State<RemodelingSchedulingScreen>
    with AutomaticKeepAliveClientMixin {
  int _activeStep = 0;

  // For date picker
  late DateTime _datePicked;
  final _firstAvailableDay = 2;
  final _schedulingRange = 30;

  // For contacts
  String address = '';
  String _phoneNumber = '';
  late TextEditingController _phoneNumberFieldController;

  @override
  bool get wantKeepAlive => true; //todo needed?

  @override
  void initState() {
    super.initState();
    _phoneNumberFieldController  = TextEditingController(text: _phoneNumber);
    DateTime now = DateTime.now();
    _datePicked = DateTime(now.year, now.month, now.day + _firstAvailableDay);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TODO backpressed warning: quit scheduling?
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.schedule_remodeling)),
        floatingActionButton: Visibility(
            visible: _activeStep == 0 ? true : false,
            child: FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  _activeStep++;
                });
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
                Icon(Icons.construction,
                    color: Theme.of(context).colorScheme.onSecondary),
                Icon(Icons.calendar_today,
                    color: Theme.of(context).colorScheme.onSecondary),
                Icon(Icons.contact_phone,
                    color: Theme.of(context).colorScheme.onSecondary),
                Icon(Icons.list,
                    color: Theme.of(context).colorScheme.onSecondary)
              ],
              activeStep: _activeStep,
              activeStepBorderWidth: 0,
              activeStepBorderPadding: 0,
              activeStepColor: Theme.of(context).colorScheme.secondary,
              enableNextPreviousButtons: false,
              stepRadius: 24.0,
              steppingEnabled: true,
              lineColor: Colors.grey,
              onStepReached: (index) {
                setState(() {
                  _activeStep = index;
                });
              },
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(_getStepTitle(),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).colorScheme.secondary))),
            Expanded(
              child: _getActiveStepWidget(),
            ),
            _getBottomButtons()
          ],
        ));
  }

  String _getStepTitle() {
    switch (_activeStep) {
      case 0:
        return AppLocalizations.of(context)!.options;
      case 1:
        return AppLocalizations.of(context)!.pick_a_day;
      case 2:
        return AppLocalizations.of(context)!.address_and_phone;
      case 3:
        return AppLocalizations.of(context)!.confirm;
      default:
        return '';
    }
  }

  Widget _getActiveStepWidget() {
    switch (_activeStep) {
      case 0: //todo get destroy when tapped away
        return RemodelingOptionsWidget(
            selectionMap: widget.selectionMap,
            restorationId: 'remodeling_options',
            callBack: () {
              debugPrint('callback'); // TODO get input values
            });
      case 1:
        final now = DateTime.now();
        final firstDate =
            DateTime(now.year, now.month, now.day + _firstAvailableDay);
        final lastDate = DateTime(
            firstDate.year, firstDate.month, firstDate.day + _schedulingRange);
        if (_datePicked.isBefore(firstDate)) {
          _datePicked = firstDate;
        }
        return ListView(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            children: [
              Card(
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
              Card(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 16.0),
                    child: Wrap(
                      direction: Axis.vertical,
                      spacing: 16.0,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.remodeling_start_date,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text(
                          DateFormat.yMMMMEEEEd(SharedPreferencesHelper()
                                  .getLocale()
                                  .languageCode)
                              .format(_datePicked),
                          style: Theme.of(context).textTheme.subtitle1,
                        )
                      ],
                    )),
              )
            ]);
      case 2:
        return ListView(
          primary: false,
          children: [
            Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    runSpacing: 16.0,
                    children: [
                      TextField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: AppLocalizations.of(context)!
                                  .remodeling_address,
                              icon: const Icon(Icons.location_pin))),
                      // todo district selector
                      TextField(
                          keyboardType: TextInputType.phone,
                          maxLength: 8,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          controller: _phoneNumberFieldController,
                          onChanged: (value) {
                            _phoneNumber = value; //todo
                          },
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText:
                                  AppLocalizations.of(context)!.contact_number,
                              hintText: '',
                              // todo and format
                              helperText: AppLocalizations.of(context)!
                                  .hong_kong_number_only,
                              icon: const Icon(Icons.phone)))
                    ],
                  ),
                ))
          ],
        );
      case 3:
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            // TODO
          ],
        );
      default:
        return Container();
    }
  }

  Widget _getBottomButtons() {
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
                  setState(() {
                    if (_activeStep > 0) {
                      _activeStep--;
                    }
                  });
                },
              ),
              ElevatedButton.icon(
                icon: Icon(_activeStep < 3 ? Icons.arrow_forward : Icons.check),
                label: Text(_activeStep < 3
                    ? AppLocalizations.of(context)!.next
                    : AppLocalizations.of(context)!.confirm_remodeling),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                        MediaQuery.of(context).size.width / 2 - 24.0, 48.0),
                    shape: const StadiumBorder()),
                onPressed: () {
                  setState(() {
                    if (_activeStep != 0) {
                      // prevent quick tab crashes
                      if (_activeStep < 3) {
                        _activeStep++;
                      } else {
                        // todo send order
                      }
                    }
                  });
                },
              )
            ],
          ));
    }
  }
}
