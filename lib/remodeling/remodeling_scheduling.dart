import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:im_stepper/stepper.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/remodeling_options.dart';

class RemodelingSchedulingScreen extends StatefulWidget {
  const RemodelingSchedulingScreen(
      {Key? key, required this.selectionMap, this.restorationId})
      : super(key: key);

  final Map<RemodelingItem, bool> selectionMap;
  final String? restorationId;

  @override
  State<RemodelingSchedulingScreen> createState() =>
      RemodelingSchedulingScreenState();
}

class RemodelingSchedulingScreenState extends State<RemodelingSchedulingScreen>
    with AutomaticKeepAliveClientMixin, RestorationMixin {
  int _activeStep = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day + 2));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    final DateTime now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day + 2);
    final lateDate =
        DateTime(firstDate.year, firstDate.month, firstDate.day + 30);
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: firstDate,
          lastDate: lateDate,
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
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
      case 0:
        return RemodelingOptionsWidget(
            selectionMap: widget.selectionMap,
            callBack: () {
              debugPrint('callback');
            }); // TODO get options values
      case 1:
        // showDatePicker(
        //     context: context,
        //     initialDate: firstDate,
        //     firstDate: firstDate,
        //     lastDate: lateDate);

        return Center(
          child: OutlinedButton(
            onPressed: () {
              _restorableDatePickerRouteFuture.present();
            },
            child: const Text('Open Date Picker'),
          ),
        );
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
        ); //TODO confirmation page
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
                // todo fab height
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
