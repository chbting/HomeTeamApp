import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';

class RemodelingOptionsWidget extends StatefulWidget {
  const RemodelingOptionsWidget({Key? key, required this.selectionMap})
      : super(key: key);

  final Map<String, bool> selectionMap;

  @override
  State<RemodelingOptionsWidget> createState() =>
      RemodelingOptionsWidgetState();
}

class RemodelingOptionsWidgetState extends State<RemodelingOptionsWidget>
    with AutomaticKeepAliveClientMixin {
  int _activeOption = 0;
  final List<String> _selectedKeyList = [];

  // Painting Card
  int? _paintArea, _paintRooms;
  bool? _scrapeOldPaint;

  // Painting Card
  int? _wallCoveringsArea, _wallCoveringsRooms;
  bool? _removeOldWallCoverings;

  // AC Installation Card
  int? _acInstallationCount;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Initialize only once
    if(_selectedKeyList.isEmpty) {
      widget.selectionMap.forEach((key, value) {
        if (value) {
          _selectedKeyList.add(key);
        }
      });
    }

    if (_selectedKeyList.length == 1) {
      Widget layout = Container(); // default case
      if (_selectedKeyList[0] == RemodelingItems.paintingKey) {
        layout = _getPaintingCardLayout();
      }
      if (_selectedKeyList[0] == RemodelingItems.wallCoveringsKey) {
        layout = _getWallCoveringsCardLayout();
      }
      if (_selectedKeyList[0] == RemodelingItems.acInstallationKey) {
        layout = _getAcInstallationCardLayout();
      }
      // TODO
      // if (_selectedKeyList[0] == RemodelingItems.removalsKey) {
      //   layout = _getPaintingCardLayout();
      // }
      // if (_selectedKeyList[0] == RemodelingItems.suspendedCeilingKey) {
      //   layout = _getPaintingCardLayout();
      // }
      // if (_selectedKeyList[0] == RemodelingItems.toiletReplacementKey) {
      //   layout = _getPaintingCardLayout();
      // }
      // if (_selectedKeyList[0] == RemodelingItems.pestControlKey) {
      //   layout = _getPaintingCardLayout();
      // }
      return Column(children: [
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: _getSingleOptionCard(
                RemodelingItems.getRemodelingItemTitle(
                    _selectedKeyList[0], context),
                layout))
      ]);
    } else {
      List<Step> _stepList = [];
      if (widget.selectionMap[RemodelingItems.paintingKey]!) {
        _stepList.add(_getOptionStep(
            RemodelingItems.getRemodelingItemTitle(
                RemodelingItems.paintingKey, context),
            _getPaintingCardLayout()));
      }
      if (widget.selectionMap[RemodelingItems.wallCoveringsKey]!) {
        _stepList.add(_getOptionStep(
            RemodelingItems.getRemodelingItemTitle(
                RemodelingItems.wallCoveringsKey, context),
            _getWallCoveringsCardLayout()));
      }
      if (widget.selectionMap[RemodelingItems.acInstallationKey]!) {
        _stepList.add(_getOptionStep(
            RemodelingItems.getRemodelingItemTitle(
                RemodelingItems.acInstallationKey, context),
            _getAcInstallationCardLayout()));
      }

      if (widget.selectionMap[RemodelingItems.removalsKey]!) {}
      if (widget.selectionMap[RemodelingItems.suspendedCeilingKey]!) {}
      if (widget.selectionMap[RemodelingItems.toiletReplacementKey]!) {}
      if (widget.selectionMap[RemodelingItems.pestControlKey]!) {}

      return Stepper(
          currentStep: _activeOption,
          controlsBuilder: (BuildContext context,
              {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
            return Row(
              children: <Widget>[
                _activeOption < _stepList.length - 1
                    ? ElevatedButton(
                        onPressed: onStepContinue,
                        child: Text(AppLocalizations.of(context)!.next_option))
                    : Container(),
                _activeOption > 0
                    ? TextButton(
                        onPressed: onStepCancel,
                        child: Text(AppLocalizations.of(context)!.back),
                      )
                    : Container(),
              ],
            );
          },
          onStepCancel: () {
            if (_activeOption > 0) {
              setState(() {
                _activeOption -= 1;
              });
            }
          },
          onStepContinue: () {
            if (_activeOption < _stepList.length - 1) {
              setState(() {
                _activeOption += 1;
              });
            }
          },
          onStepTapped: (int index) {
            setState(() {
              _activeOption = index;
            });
          },
          steps: _stepList);
    }
  }

  Card _getSingleOptionCard(String title, Widget layout) {
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // todo needed?
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(title, style: _getOptionTitleTextStyle())),
                layout
              ],
            )));
  }

  Step _getOptionStep(String title, Widget layout) {
    return Step(
        title: Text(title, style: _getOptionTitleTextStyle()),
        content: Card(
            child: Padding(padding: const EdgeInsets.all(8.0), child: layout)));
  }

  Widget _getPaintingCardLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  labelText: AppLocalizations.of(context)!.number_of_rooms,
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
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                title: Text(AppLocalizations.of(context)!.scrape_old_paint_yes),
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
              title: Text(AppLocalizations.of(context)!.scrape_old_paint_no),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(AppLocalizations.of(context)!.estimate,
                    style: Theme.of(context).textTheme.subtitle1)),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                    _getPaintingEstimate() == null
                        ? '\$-'
                        : NumberFormat.currency(
                                locale: 'zh_HK', symbol: '\$', decimalDigits: 0)
                            .format(_getPaintingEstimate()),
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.subtitle1)),
          ],
        )
      ],
    );
  }

  Widget _getWallCoveringsCardLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  labelText: AppLocalizations.of(context)!.number_of_rooms,
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
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(AppLocalizations.of(context)!.scrape_old_paint,
                style: Theme.of(context).textTheme.subtitle1)),
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                title: Text(AppLocalizations.of(context)!.scrape_old_paint_yes),
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
              title: Text(AppLocalizations.of(context)!.scrape_old_paint_no),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(AppLocalizations.of(context)!.estimate,
                    style: Theme.of(context).textTheme.subtitle1)),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                    _getWallCoveringsEstimate() == null
                        ? '\$-'
                        : NumberFormat.currency(
                                locale: 'zh_HK', symbol: '\$', decimalDigits: 0)
                            .format(_getWallCoveringsEstimate()),
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.subtitle1)),
          ],
        )
      ],
    );
  }

  Widget _getAcInstallationCardLayout() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.count,
                ),
                onChanged: (value) {
                  value.isEmpty
                      ? _acInstallationCount = null
                      : _acInstallationCount = int.parse(value);
                  setState(() {});
                },
              ),
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
                        _acInstallationCount == null
                            ? '\$-'
                            : NumberFormat.currency(
                                    locale: 'zh_HK',
                                    symbol: '\$',
                                    decimalDigits: 0)
                                .format(_acInstallationCount! * 800), //TODO
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.subtitle1)),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextStyle _getOptionTitleTextStyle() =>
      Theme.of(context).textTheme.subtitle1!;

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
}
