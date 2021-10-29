import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_pricing.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduling_data.dart';

class RemodelingOptionsWidget extends StatefulWidget {
  const RemodelingOptionsWidget(
      {Key? key, required this.data, required this.callBack})
      : super(key: key);

  final RemodelingSchedulingData data;
  final Function callBack;

  @override
  State<RemodelingOptionsWidget> createState() =>
      RemodelingOptionsWidgetState();
}

class RemodelingOptionsWidgetState extends State<RemodelingOptionsWidget>
    with AutomaticKeepAliveClientMixin {
  int _activeOption = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Return a Card for one item, a Stepper for multiple items
    if (widget.data.selectedItemList.length == 1) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        widget.callBack(true);
      });
      return _getSingleOptionWidget(widget.data.selectedItemList[0]);
    } else {
      List<Step> _stepList = [];
      for (var item in widget.data.selectedItemList) {
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
                FocusScope.of(context).unfocus();
                _activeOption--;
                _notifyIsRemodelingOptionsAtBottom(_stepList.length);
              });
            }
          },
          onStepContinue: () {
            if (_activeOption < _stepList.length - 1) {
              setState(() {
                FocusScope.of(context).unfocus();
                _activeOption++;
                _notifyIsRemodelingOptionsAtBottom(_stepList.length);
              });
            }
          },
          onStepTapped: (int index) {
            setState(() {
              if (_activeOption != index) {
                FocusScope.of(context).unfocus();
                _activeOption = index;
              }
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
    if (item == RemodelingItem.ac) {
      return _getAcCardLayout();
    }
    if (item == RemodelingItem.removals) {
      return _getRemovalsCardLayout();
    }
    if (item == RemodelingItem.suspendedCeiling) {
      return _getSuspendedCeilingCardLayout();
    }
    if (item == RemodelingItem.toiletReplacement) {
      return _getToiletReplacementCardLayout();
    }
    if (item == RemodelingItem.pestControl) {
      return _getPestControlCardLayout();
    }
    return Container();
  }

  Widget _getPaintingCardLayout() {
    return Wrap(children: [
      Padding(
        // todo painting color??
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
      _getEstimationWidget(RemodelingPricing.getPaintingEstimate(
          widget.data.paintArea, widget.data.scrapeOldPaint))
    ]);
  }

  Widget _getWallCoveringsCardLayout() {
    return Wrap(children: [
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
      _getEstimationWidget(RemodelingPricing.getWallCoveringsEstimate(
          widget.data.wallCoveringsArea))
    ]);
  }

  Widget _getAcCardLayout() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        // todo types and count
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
                ? widget.data.acCount = null
                : widget.data.acCount = int.parse(value);
            setState(() {});
          },
        ),
      ),
      _getEstimationWidget(RemodelingPricing.getAcEstimate())
    ]);
  }

  Widget _getRemovalsCardLayout() {
    return Container();
  }

  Widget _getSuspendedCeilingCardLayout() {
    return Container();
  }

  Widget _getToiletReplacementCardLayout() {
    return Container();
  }

  Widget _getPestControlCardLayout() {
    return Container();
  }

  Widget _getEstimationWidget(int? price) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(AppLocalizations.of(context)!.estimate,
                style: Theme.of(context).textTheme.subtitle1),
            Text(formatPrice(price),
                style: Theme.of(context).textTheme.subtitle1),
          ],
        ));
  }

  TextStyle _getOptionTitleTextStyle() =>
      Theme.of(context).textTheme.subtitle1!;
}
