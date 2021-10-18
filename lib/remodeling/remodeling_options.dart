import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/remodeling/remodeling_selections.dart';

import '../theme.dart';

class RemodelingOptionsScreen extends StatefulWidget {
  const RemodelingOptionsScreen({Key? key, required this.selectionMap})
      : super(key: key);

  final Map<String, bool> selectionMap;

  @override
  State<RemodelingOptionsScreen> createState() =>
      RemodelingOptionsScreenState();
}

class RemodelingOptionsScreenState extends State<RemodelingOptionsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<Widget> _optionsList = [];
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _optionsList = [];
    if (widget.selectionMap[RemodelingOptions.paintingKey]!) {
      _optionsList.add(Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.painting,
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.secondary),// TODO use custom function
                  )),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(),
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.area_sq_ft,
                        )),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        focusNode: myFocusNode,
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText:
                              AppLocalizations.of(context)!.number_of_rooms,
                        )),
                  )),
                ],
              ),
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      child: Text(
                          AppLocalizations.of(context)!.scrape_old_paint,
                          style: Theme.of(context).textTheme.subtitle1)),

                ],
              )
            ],
          ),
        ),
      ));
    }
    if (widget.selectionMap[RemodelingOptions.wallCoveringsKey]!) {
      //_optionsList.add(value);
    }
    if (widget.selectionMap[RemodelingOptions.acInstallationKey]!) {
      //_optionsList.add(value);
    }
    if (widget.selectionMap[RemodelingOptions.removalsKey]!) {
      //_optionsList.add(value);
    }
    if (widget.selectionMap[RemodelingOptions.suspendedCeilingKey]!) {
      //_optionsList.add(value);
    }
    if (widget.selectionMap[RemodelingOptions.toiletReplacementKey]!) {
      //_optionsList.add(value);
    }
    if (widget.selectionMap[RemodelingOptions.pestControlKey]!) {
      //_optionsList.add(value);
    }

    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.remodeling_options)),
        floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.arrow_forward),
            label: Text(AppLocalizations.of(context)!.next),
            onPressed: () {
              //TODO do checking and go to next page
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: ListView(
          padding: const EdgeInsets.only(
              left: 8.0, top: 8.0, right: 8.0, bottom: 72.0),
          primary: false,
          shrinkWrap: true,
          children: _optionsList,
        ));
  }
}

class PaintingOptionsWidget {}
