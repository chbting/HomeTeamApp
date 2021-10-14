import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/remodeling/remodeling_selections.dart';

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

  final List<Widget> _optionsList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> _optionsList = []; //TODO state?
    if (widget.selectionMap[RemodelingOptions.paintingKey]!) {
      _optionsList.add(Card(
        //margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.painting,
                style: Theme.of(context).textTheme.headline6,
              ),
              Row(
                children: const [
                  Expanded(
                    child: TextField(keyboardType: TextInputType.number),
                  ),
                  Expanded(
                    child: TextField(keyboardType: TextInputType.number),
                  )
                ],
              ),
              Text(AppLocalizations.of(context)!.scrape_old_paint
              ,style: Theme.of(context).textTheme.subtitle1),
              Row()
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
              //TODO
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
