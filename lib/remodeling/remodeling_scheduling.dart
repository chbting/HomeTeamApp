import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:im_stepper/stepper.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/remodeling_options.dart';

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

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // TODO backpressed warning: quit scheduling?
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.schedule_remodeling)),
        floatingActionButton: Visibility(
            visible: _activeStep == 3 ? true : false,
            child: FloatingActionButton.extended(
                icon: const Icon(Icons.check),
                label: Text(AppLocalizations.of(context)!.confirm_remodeling),
                onPressed: () {
                  //TODO send order
                })),
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
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.arrow_back),
                      label: Text(AppLocalizations.of(context)!.back),
                      onPressed: () {
                        setState(() {
                          _activeStep--;
                        });
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.contact_phone),
                      label:
                          Text(AppLocalizations.of(context)!.address_and_phone),
                      onPressed: () {
                        setState(() {
                          _activeStep++;
                        });
                      },
                    )
                  ],
                ))
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
            callBack: () {}); // TODO get options values
      case 1:
        return Column(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(AppLocalizations.of(context)!.pick_a_day),
            ),
          )
        ]);
      case 2:
        return Wrap(
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
}
