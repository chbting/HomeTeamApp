import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        return RemodelingOptionsWidget(selectionMap: widget.selectionMap);
      case 1:
        return Column(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(AppLocalizations.of(context)!.pick_a_day),
            ),
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
        ]);
      default:
        return Text('$_activeStep'); //TODO
    }
  }
}
