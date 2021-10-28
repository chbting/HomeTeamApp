import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_pricing.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduling_data.dart';

class RemodelingOptionsWidget extends StatefulWidget {
  const RemodelingOptionsWidget(
      {Key? key,
      required this.selectionMap,
      required this.data,
      required this.callBack})
      : super(key: key);

  final Map<RemodelingItem, bool> selectionMap;
  final RemodelingSchedulingData data;
  final Function callBack;

  @override
  State<RemodelingOptionsWidget> createState() =>
      RemodelingOptionsWidgetState();
}

class RemodelingOptionsWidgetState extends State<RemodelingOptionsWidget>
    with AutomaticKeepAliveClientMixin {
  int _activeOption = 0;
  final List<RemodelingItem> _selectedItemList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        widget.callBack(true);
      });
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
                _notifyIsRemodelingOptionsAtBottom(_stepList.length);
              });
            }
          },
          onStepContinue: () {
            if (_activeOption < _stepList.length - 1) {
              setState(() {
                _activeOption++;
                _notifyIsRemodelingOptionsAtBottom(_stepList.length);
              });
            }
          },
          onStepTapped: (int index) {
            setState(() {
              _activeOption = index;
              _notifyIsRemodelingOptionsAtBottom(_stepList.length);
            });
          },
          steps: _stepList);
    }
  }

  void _notifyIsRemodelingOptionsAtBottom(int numberOfSteps) {
    if (_activeOption == numberOfSteps - 1) {
      widget.callBack(true);
    } else {
      widget.callBack(false);
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
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.area_sq_ft,
            ),
            onChanged: (value) {
              value.isEmpty
                  ? widget.data.paintArea = null
                  : widget.data.paintArea = int.parse(value);
              setState(() {});
            },
          ),
        ),
        RadioListTile(
          title: Text(AppLocalizations.of(context)!.scrape_old_paint_yes),
          value: true,
          groupValue: widget.data.scrapeOldPaint,
          onChanged: (bool? value) {
            setState(() {
              widget.data.scrapeOldPaint = true;
            });
          },
        ),
        RadioListTile(
          title: Text(AppLocalizations.of(context)!.scrape_old_paint_no),
          value: false,
          groupValue: widget.data.scrapeOldPaint,
          onChanged: (bool? value) {
            setState(() {
              widget.data.scrapeOldPaint = false;
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
                    widget.data.paintArea == null ||
                            widget.data.scrapeOldPaint == null
                        ? '\$-'
                        : NumberFormat.currency(
                                locale: 'zh_HK', symbol: '\$', decimalDigits: 0)
                            .format(RemodelingPricing.getPaintingEstimate(
                                widget.data.paintArea!,
                                widget.data.scrapeOldPaint!)),
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.subtitle1)),
          ],
        )
      ],
    );
  }

  Widget _getWallCoveringsCardLayout() {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.area_sq_ft,
            ),
            onChanged: (value) {
              value.isEmpty
                  ? widget.data.wallCoveringsArea = null
                  : widget.data.wallCoveringsArea = int.parse(value);
              setState(() {});
            },
          ),
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
                    widget.data.wallCoveringsArea == null
                        ? '\$-'
                        : NumberFormat.currency(
                                locale: 'zh_HK', symbol: '\$', decimalDigits: 0)
                            .format(RemodelingPricing.getWallCoveringsEstimate(
                                widget.data.wallCoveringsArea!)),
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
                  ? widget.data.acInstallationCount = null
                  : widget.data.acInstallationCount = int.parse(value);
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
                    widget.data.acInstallationCount == null
                        ? '\$-'
                        : NumberFormat.currency(
                                locale: 'zh_HK', symbol: '\$', decimalDigits: 0)
                            .format(
                                widget.data.acInstallationCount! * 800), //TODO
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.subtitle1)),
          ],
        )
      ],
    );
  }

  TextStyle _getOptionTitleTextStyle() =>
      Theme.of(context).textTheme.subtitle1!;
}
