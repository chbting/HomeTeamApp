import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/remodeling/remodeling_types.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_inherited_data.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_order.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_pricing.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduler.dart';
import 'package:tner_client/ui/custom_stepper.dart' as custom;

class RemodelingOptionsWidget extends StatefulWidget {
  const RemodelingOptionsWidget({Key? key}) : super(key: key);

  @override
  State<RemodelingOptionsWidget> createState() =>
      RemodelingOptionsWidgetState();
}

class RemodelingOptionsWidgetState extends State<RemodelingOptionsWidget>
    with AutomaticKeepAliveClientMixin {
  late RemodelingOrder _data;
  int _activeOption = 0;

  // Maintain the stepper position even after moved to the next step
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _data = RemodelingInheritedData.of(context)!.info;

    // Return a Card for one item, a Stepper for multiple items
    if (_data.remodelingItems.length == 1) {
      return _getSingleOptionWidget(_data.remodelingItems[0], context);
    } else {
      List<custom.Step> stepList = [];
      for (var item in _data.remodelingItems) {
        stepList.add(_getOptionStep(item, context));
      }
      // todo use form to validate
      // todo sometimes the nextStep button on scheduler is blocked (try to reproduce)
      return custom.Stepper(
          // Minus the internal paddings of the stepper
          padding: const EdgeInsets.only(
              top: RemodelingScheduler.stepTitleBarHeight - 16.0,
              bottom: RemodelingScheduler.bottomButtonContainerHeight - 24.0),
          currentStep: _activeOption,
          controlsBuilder:
              (BuildContext context, custom.ControlsDetails details) {
            return Row(
              children: <Widget>[
                _activeOption < stepList.length - 1
                    ? ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: Text(S.of(context).next_option))
                    : Container(),
                _activeOption > 0
                    ? TextButton(
                        onPressed: details.onStepCancel,
                        child: Text(S.of(context).back))
                    : Container(),
              ],
            );
          },
          onStepCancel: () {
            if (_activeOption > 0) {
              setState(() {
                FocusScope.of(context).unfocus();
                _activeOption--;
                _updateBottomButtonState();
              });
            }
          },
          onStepContinue: () {
            if (_activeOption < stepList.length - 1) {
              setState(() {
                FocusScope.of(context).unfocus();
                _activeOption++;
                _updateBottomButtonState();
              });
            }
          },
          onStepTapped: (int index) {
            setState(() {
              if (_activeOption != index) {
                FocusScope.of(context).unfocus();
                _activeOption = index;
              }
              _updateBottomButtonState();
            });
          },
          steps: stepList);
    }
  }

  void _updateBottomButtonState() {
    // Show the button only when the user is on the last option
    (_activeOption == _data.remodelingItems.length - 1)
        ? RemodelingInheritedData.of(context)!.uiState.showBottomButtons.value =
            true
        : RemodelingInheritedData.of(context)!.uiState.showBottomButtons.value =
            false;
  }

  Widget _getSingleOptionWidget(RemodelingItem item, BuildContext context) {
    String title = RemodelingTypeHelper.getItemName(item.type, context);
    return SingleChildScrollView(
        padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: RemodelingScheduler.stepTitleBarHeight - 4.0,
            bottom: RemodelingScheduler.bottomButtonContainerHeight - 4.0),
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

  custom.Step _getOptionStep(RemodelingItem item, BuildContext context) {
    String title = RemodelingTypeHelper.getItemName(item.type, context);
    return custom.Step(
        title: Text(title, style: _getOptionTitleTextStyle()),
        content: Card(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _getLayoutByRemodelingItem(item))));
  }

  Widget _getLayoutByRemodelingItem(RemodelingItem item) {
    switch (item.type) {
      case RemodelingType.painting:
        return _getPaintingCardLayout(item);
      case RemodelingType.wallCoverings:
        return _getWallCoveringsCardLayout(item);
      case RemodelingType.ac:
        return _getAcCardLayout(item);
      case RemodelingType.removals:
        return _getRemovalsCardLayout();
      case RemodelingType.suspendedCeiling:
        return _getSuspendedCeilingCardLayout();
      case RemodelingType.toiletReplacement:
        return _getToiletReplacementCardLayout();
      case RemodelingType.pestControl:
        return _getPestControlCardLayout();
    }
  }

  Widget _getPaintingCardLayout(RemodelingItem item) {
    item as RemodelingPainting;
    return Wrap(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: S.of(context).area_sq_ft,
          ),
          onChanged: (value) {
            setState(() {
              value.isEmpty
                  ? item.paintArea = 0
                  : item.paintArea = int.parse(value); //todo zero out total before user put in a value, validate
            });
          },
        ),
      ),
      RadioListTile(
        title: Text(S.of(context).scrape_old_paint_yes),
        value: true,
        groupValue: item.scrapeOldPaint,
        onChanged: (bool? value) {
          setState(() {
            item.scrapeOldPaint = true;
          });
        },
      ),
      RadioListTile(
        title: Text(S.of(context).scrape_old_paint_no),
        value: false,
        groupValue: item.scrapeOldPaint,
        onChanged: (bool? value) {
          setState(() {
            item.scrapeOldPaint = false;
          });
        },
      ),
      _getEstimationWidget(RemodelingPricing.getEstimate(
        RemodelingPainting(
            paintArea: item.paintArea, scrapeOldPaint: item.scrapeOldPaint),
      ))
    ]);
  }

  Widget _getWallCoveringsCardLayout(RemodelingItem item) {
    item as RemodelingWallCoverings;
    return Wrap(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: S.of(context).area_sq_ft,
          ),
          onChanged: (value) {
            setState(() {
              value.isEmpty ? item.area = 0 : item.area = int.parse(value);
            });
          },
        ),
      ),
      _getEstimationWidget(
          RemodelingPricing.getEstimate(RemodelingWallCoverings()))
    ]);
  }

  Widget _getAcCardLayout(RemodelingItem item) {
    item as RemodelingAC;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        // todo types and count
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: S.of(context).count,
          ),
          onChanged: (value) {
            setState(() {
              value.isEmpty
                  ? item.acCount = null
                  : item.acCount = int.parse(value);
            });
          },
        ),
      ),
      _getEstimationWidget(RemodelingPricing.getEstimate(RemodelingAC()))
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
            Text(S.of(context).estimate,
                style: Theme.of(context).textTheme.titleMedium),
            Text(formatPrice(price),
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ));
  }

  TextStyle _getOptionTitleTextStyle() =>
      Theme.of(context).textTheme.titleMedium!;
}
