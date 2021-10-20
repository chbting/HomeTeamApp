import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
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
  List<Widget> _optionsList = [];

  // Painting Card
  int? _paintArea, _paintRooms;
  bool? _scrapeOldPaint;

  // Painting Card
  int? _wallCoveringsArea, _wallCoveringsRooms;
  bool? _removeOldWallCoverings;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _optionsList = [];

    // Painting Card
    if (widget.selectionMap[RemodelingOptions.paintingKey]!) {
      _optionsList.add(Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppLocalizations.of(context)!.painting,
                      style: _getItemTitleTextStyle())),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)!.area_sq_ft,
                      ),
                      onChanged: (value) {
                        value.isEmpty
                            ? _paintArea = null
                            : _paintArea = int.parse(value);
                        setState(() {});
                      },
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText:
                            AppLocalizations.of(context)!.number_of_rooms,
                      ),
                      onChanged: (value) {
                        value.isEmpty
                            ? _paintRooms = null
                            : _paintRooms = int.parse(value);
                        setState(() {});
                      },
                    ),
                  )),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Text(AppLocalizations.of(context)!.scrape_old_paint,
                      style: Theme.of(context).textTheme.subtitle1)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: Text(
                          AppLocalizations.of(context)!.scrape_old_paint_yes),
                      value: true,
                      groupValue: _scrapeOldPaint,
                      onChanged: (bool? value) {
                        setState(() {
                          _scrapeOldPaint = true;
                        });
                      },
                    ),
                  ),
                  Expanded(
                      child: RadioListTile(
                    title:
                        Text(AppLocalizations.of(context)!.scrape_old_paint_no),
                    value: false,
                    groupValue: _scrapeOldPaint,
                    onChanged: (bool? value) {
                      setState(() {
                        _scrapeOldPaint = false;
                      });
                    },
                  )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Text(AppLocalizations.of(context)!.estimate,
                          style: Theme.of(context).textTheme.subtitle1)),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Text(
                          _getPaintingEstimate() == null
                              ? '\$-'
                              : NumberFormat.currency(
                                      locale: 'zh_HK',
                                      symbol: '\$',
                                      decimalDigits: 0)
                                  .format(_getPaintingEstimate()),
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.subtitle1)),
                ],
              )
            ],
          ),
        ),
      ));
    }
    if (widget.selectionMap[RemodelingOptions.wallCoveringsKey]!) {
      _optionsList.add(Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppLocalizations.of(context)!.wallcoverings,
                      style: _getItemTitleTextStyle())),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)!.area_sq_ft,
                      ),
                      onChanged: (value) {
                        value.isEmpty
                            ? _wallCoveringsArea = null
                            : _wallCoveringsArea = int.parse(value);
                        setState(() {});
                      },
                    ),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText:
                            AppLocalizations.of(context)!.number_of_rooms,
                      ),
                      onChanged: (value) {
                        value.isEmpty
                            ? _wallCoveringsRooms = null
                            : _wallCoveringsRooms = int.parse(value);
                        setState(() {});
                      },
                    ),
                  )),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Text(AppLocalizations.of(context)!.scrape_old_paint,
                      style: Theme.of(context).textTheme.subtitle1)),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: Text(
                          AppLocalizations.of(context)!.scrape_old_paint_yes),
                      value: true,
                      groupValue: _removeOldWallCoverings,
                      onChanged: (bool? value) {
                        setState(() {
                          _removeOldWallCoverings = true;
                        });
                      },
                    ),
                  ),
                  Expanded(
                      child: RadioListTile(
                    title:
                        Text(AppLocalizations.of(context)!.scrape_old_paint_no),
                    value: false,
                    groupValue: _removeOldWallCoverings,
                    onChanged: (bool? value) {
                      setState(() {
                        _removeOldWallCoverings = false;
                      });
                    },
                  )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Text(AppLocalizations.of(context)!.estimate,
                          style: Theme.of(context).textTheme.subtitle1)),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Text(
                          _getWallCoveringsEstimate() == null
                              ? '\$-'
                              : NumberFormat.currency(
                                      locale: 'zh_HK',
                                      symbol: '\$',
                                      decimalDigits: 0)
                                  .format(_getWallCoveringsEstimate()),
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.subtitle1)),
                ],
              )
            ],
          ),
        ),
      ));
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

  int? _getPaintingEstimate() {
    if (_paintArea == null || _paintRooms == null || _scrapeOldPaint == null) {
      return null;
    } else {
      // TODO
      return _scrapeOldPaint!
          ? (_paintArea! + _paintRooms!) * 2
          : _paintArea! + _paintRooms!;
    }
  }

  int? _getWallCoveringsEstimate() {
    if (_wallCoveringsArea == null ||
        _wallCoveringsRooms == null ||
        _removeOldWallCoverings == null) {
      return null;
    } else {
      // TODO
      return _removeOldWallCoverings!
          ? (_wallCoveringsArea! + _wallCoveringsRooms!) * 2
          : _wallCoveringsArea! + _wallCoveringsRooms!;
    }
  }

  TextStyle _getItemTitleTextStyle() => Theme.of(context)
      .textTheme
      .headline6!
      .copyWith(color: Theme.of(context).colorScheme.secondary);
}
