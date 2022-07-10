import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_pricing.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduler.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduling_data.dart';
import 'package:tner_client/ui/custom_stepper.dart' as custom;
import 'package:tner_client/utils/text_helper.dart';

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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.callBack(true);
      });
      return _getSingleOptionWidget(widget.data.selectedItemList[0]);
    } else {
      List<custom.Step> stepList = [];
      for (var item in widget.data.selectedItemList) {
        stepList.add(_getOptionStep(item));
      }
      // todo use form to validate
      return custom.Stepper(
          // Minus the internal paddings of the stepper
          padding: const EdgeInsets.only(
              top: RemodelingSchedulingScreen.stepTitleBarHeight - 16.0,
              bottom: RemodelingSchedulingScreen.bottomButtonContainerHeight -
                  24.0),
          currentStep: _activeOption,
          controlsBuilder:
              (BuildContext context, custom.ControlsDetails details) {
            return Row(
              children: <Widget>[
                _activeOption < stepList.length - 1
                    ? ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: Text(TextHelper.appLocalizations.next_option))
                    : Container(),
                _activeOption > 0
                    ? TextButton(
                        onPressed: details.onStepCancel,
                        child: Text(TextHelper.appLocalizations.back))
                    : Container(),
              ],
            );
          },
          onStepCancel: () {
            if (_activeOption > 0) {
              setState(() {
                FocusScope.of(context).unfocus();
                _activeOption--;
                _notifyIsRemodelingOptionsAtBottom(stepList.length);
              });
            }
          },
          onStepContinue: () {
            if (_activeOption < stepList.length - 1) {
              setState(() {
                FocusScope.of(context).unfocus();
                _activeOption++;
                _notifyIsRemodelingOptionsAtBottom(stepList.length);
              });
            }
          },
          onStepTapped: (int index) {
            setState(() {
              if (_activeOption != index) {
                FocusScope.of(context).unfocus();
                _activeOption = index;
              }
              _notifyIsRemodelingOptionsAtBottom(stepList.length);
            });
          },
          steps: stepList);
    }
  }

  void _notifyIsRemodelingOptionsAtBottom(int numberOfSteps) {
    (_activeOption == numberOfSteps - 1)
        ? widget.callBack(true)
        : widget.callBack(false);
  }

  Widget _getSingleOptionWidget(RemodelingItem item) {
    String title = getRemodelingItemTitle(item);
    return SingleChildScrollView(
        padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: RemodelingSchedulingScreen.stepTitleBarHeight - 4.0,
            bottom:
                RemodelingSchedulingScreen.bottomButtonContainerHeight - 4.0),
        primary: false,
        child: Card(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child:
                              Text(title, style: _getOptionTitleTextStyle())),
                      _getLayoutByRemodelingItem(item)
                    ]))));
  }

  custom.Step _getOptionStep(RemodelingItem item) {
    String title = getRemodelingItemTitle(item);
    return custom.Step(
        title: Text(title, style: _getOptionTitleTextStyle()),
        content: Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
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
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: TextHelper.appLocalizations.area_sq_ft,
          ),
          onChanged: (value) {
            setState(() {
              value.isEmpty
                  ? widget.data.paintArea = null
                  : widget.data.paintArea = int.parse(value);
            });
          },
        ),
      ),
      RadioListTile(
        title: Text(TextHelper.appLocalizations.scrape_old_paint_yes),
        value: true,
        groupValue: widget.data.scrapeOldPaint,
        onChanged: (bool? value) {
          setState(() {
            widget.data.scrapeOldPaint = true;
          });
        },
      ),
      RadioListTile(
        title: Text(TextHelper.appLocalizations.scrape_old_paint_no),
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
            labelText: TextHelper.appLocalizations.area_sq_ft,
          ),
          onChanged: (value) {
            setState(() {
              value.isEmpty
                  ? widget.data.wallCoveringsArea = null
                  : widget.data.wallCoveringsArea = int.parse(value);
            });
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
            labelText: TextHelper.appLocalizations.count,
          ),
          onChanged: (value) {
            setState(() {
              value.isEmpty
                  ? widget.data.acCount = null
                  : widget.data.acCount = int.parse(value);
            });
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
    return Container(height: 150.0); // for debugging
  }

  Widget _getEstimationWidget(int? price) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(TextHelper.appLocalizations.estimate,
                style: Theme.of(context).textTheme.subtitle1),
            Text(formatPrice(price),
                style: Theme.of(context).textTheme.subtitle1),
          ],
        ));
  }

  TextStyle _getOptionTitleTextStyle() =>
      Theme.of(context).textTheme.subtitle1!;
}
