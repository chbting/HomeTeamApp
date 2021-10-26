import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';

class RemodelingOptionsWidget extends StatefulWidget {
  const RemodelingOptionsWidget(
      {Key? key, required this.selectionMap, required this.restorationId, required this.callBack})
      : super(key: key);

  final Map<RemodelingItem, bool> selectionMap;
  final String restorationId;
  final Function callBack;

  @override
  State<RemodelingOptionsWidget> createState() =>
      RemodelingOptionsWidgetState();
}

class RemodelingOptionsWidgetState extends State<RemodelingOptionsWidget> with RestorationMixin{
  int _activeOption = 0;
  final List<RemodelingItem> _selectedItemList = [];

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // TODO: implement restoreState
    registerForRestoration(RestorableInt(456), 'paint_area_textField');
    debugPrint('restore');//
  }

  // Painting Card
  int? _paintArea;
  bool? _scrapeOldPaint;

  // Painting Card
  int? _wallCoveringsArea;

  // AC Installation Card
  int? _acInstallationCount;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize only once
    if (_selectedItemList.isEmpty) {
      widget.selectionMap.forEach((item, value) {
        if (value) {
          _selectedItemList.add(item);
        }
      });
    }

    // Return a Card for one item, a Stepper for multiple items
    if (_selectedItemList.length == 1) {
      return _getSingleOptionWidget(_selectedItemList[0]);
    } else {
      List<Step> _stepList = [];
      for (var item in _selectedItemList) {
        _stepList.add(_getOptionStep(item));
      }
      // TODO add total estimation
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
                        child: Text(AppLocalizations.of(context)!.back))
                    : Container(),
              ],
            );
          },
          onStepCancel: () {
            if (_activeOption > 0) {
              setState(() {
                _activeOption--;
              });
            }
          },
          onStepContinue: () {
            if (_activeOption < _stepList.length - 1) {
              setState(() {
                _activeOption++;
                widget.callBack;
              });
            }
          },
          onStepTapped: (int index) {
            setState(() {
              _activeOption = index;
              widget.callBack;
            });
          },
          steps: _stepList);
    }
  }

  Widget _getSingleOptionWidget(RemodelingItem item) {
    String title = getRemodelingItemTitle(item, context);
    return ListView(
      primary: false,
      children: [
        Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(title, style: _getOptionTitleTextStyle())),
                    _getLayoutByRemodelingItem(item)
                  ],
                )))
      ],
    );
  }

  Step _getOptionStep(RemodelingItem item) {
    String title = getRemodelingItemTitle(item, context);
    return Step(
        title: Text(title, style: _getOptionTitleTextStyle()),
        content: Card(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: _getLayoutByRemodelingItem(item))));
  }

  Widget _getLayoutByRemodelingItem(RemodelingItem item) {
    if (item == RemodelingItem.painting) {
      return _getPaintingCardLayout();
    }
    if (item == RemodelingItem.wallCoverings) {
      return _getWallCoveringsCardLayout();
    }
    if (item == RemodelingItem.acInstallation) {
      return _getAcInstallationCardLayout();
    }
    // todo
    if (item == RemodelingItem.removals) {}
    if (item == RemodelingItem.suspendedCeiling) {}
    if (item == RemodelingItem.toiletReplacement) {}
    if (item == RemodelingItem.pestControl) {}
    return Container();
  }

  Widget _getPaintingCardLayout() {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            restorationId: 'paint_area_textField',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.area_sq_ft,
            ),
            onChanged: (value) {
              value.isEmpty ? _paintArea = null : _paintArea = int.parse(value);
              setState(() {});
            },
          ),
        ),
        RadioListTile(
          title: Text(AppLocalizations.of(context)!.scrape_old_paint_yes),
          value: true,
          groupValue: _scrapeOldPaint,
          onChanged: (bool? value) {
            setState(() {
              _scrapeOldPaint = true;
            });
          },
        ),
        RadioListTile(
          title: Text(AppLocalizations.of(context)!.scrape_old_paint_no),
          value: false,
          groupValue: _scrapeOldPaint,
          onChanged: (bool? value) {
            setState(() {
              _scrapeOldPaint = false;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(AppLocalizations.of(context)!.estimate,
                    style: Theme.of(context).textTheme.subtitle1)),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
        TextField(
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
    return Column(
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(AppLocalizations.of(context)!.estimate,
                    style: Theme.of(context).textTheme.subtitle1)),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Text(
                    _acInstallationCount == null
                        ? '\$-'
                        : NumberFormat.currency(
                                locale: 'zh_HK', symbol: '\$', decimalDigits: 0)
                            .format(_acInstallationCount! * 800), //TODO
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.subtitle1)),
          ],
        )
      ],
    );
  }

  TextStyle _getOptionTitleTextStyle() =>
      Theme.of(context).textTheme.subtitle1!;

  int? _getPaintingEstimate() {
    if (_paintArea == null || _scrapeOldPaint == null) {
      return null;
    } else {
      if (_scrapeOldPaint!) {
        if (_paintArea! < 500) {
          return 28000;
        }
        if (_paintArea! < 600) {
          return 38000;
        }
        if (_paintArea! < 700) {
          return 46000;
        }
        if (_paintArea! < 800) {
          return 55000;
        }
      } else {
        if (_paintArea! < 500) {
          return 16000;
        }
        if (_paintArea! < 600) {
          return 19000;
        }
        if (_paintArea! < 700) {
          return 22000;
        }
        if (_paintArea! < 800) {
          return 26500;
        }
      }
    }
  }

  // TODO
  int? _getWallCoveringsEstimate() {
    if (_wallCoveringsArea == null) {
      return null;
    } else {
      return 100;
    }
  }
}
