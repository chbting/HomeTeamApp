import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:path/path.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/ui/custom_im_stepper/first_stepper/icon_stepper.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/file_helper.dart';
import 'package:tner_client/utils/keyboard_visibility_builder.dart';

import 'remodeling_confirmation.dart';
import 'remodeling_contacts.dart';
import 'remodeling_images.dart';
import 'remodeling_inherited_data.dart';
import 'remodeling_options.dart';

class RemodelingScheduler extends StatefulWidget {
  const RemodelingScheduler({Key? key}) : super(key: key);

  static const stepTitleBarHeight = 40.0;
  static const buttonHeight = 48.0; // Same as an extended floatingActionButton
  static const buttonSpacing = 16.0;
  static const bottomButtonContainerHeight = buttonHeight + buttonSpacing * 2;

  @override
  State<RemodelingScheduler> createState() => RemodelingSchedulerState();
}

class RemodelingSchedulerState extends State<RemodelingScheduler> {
  final GlobalKey _stepperKey = GlobalKey();
  final GlobalKey<RemodelingContactsWidgetState> _contactsWidgetKey =
      GlobalKey<RemodelingContactsWidgetState>();
  final PageController _pageController = PageController(initialPage: 0);
  final _totalSteps = 4;
  double _stepTitleBarTopMargin = 0.0;
  bool _bottomButtonEnabled = true;

  late RemodelingInheritedData _data;
  late double _buttonWidth;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final box = _stepperKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        _stepTitleBarTopMargin = box.size.height - 1; // -1 rounding error?
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO backPressed dialog to confirm exiting
    _buttonWidth = (MediaQuery.of(context).size.width -
            RemodelingScheduler.buttonSpacing * 3) /
        2;
    return KeyboardVisibilityBuilder(
        builder: (context, child, isKeyboardVisible) {
      _data = RemodelingInheritedData.of(context)!;
      var stepIconColor = Theme.of(context).colorScheme.onSecondary;

      return Scaffold(
          appBar: AppBar(
              title: Text(S.of(context).schedule_remodeling),
              leading: const CloseButton()),
          body: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomIconStepper(
                  key: _stepperKey,
                  icons: [
                    Icon(Icons.style, color: stepIconColor),
                    Icon(Icons.image, color: stepIconColor),
                    Icon(Icons.contact_phone, color: stepIconColor),
                    Icon(Icons.check, color: stepIconColor)
                  ],
                  activeStep: _data.uiState.activeStep,
                  activeStepBorderWidth: 2,
                  activeStepColor: Theme.of(context).colorScheme.secondary,
                  enableNextPreviousButtons: false,
                  enableStepTapping: false,
                  showIsStepCompleted: true,
                  stepRadius: 24.0,
                  lineColor: Theme.of(context).colorScheme.onSurface,
                  onStepReached: (index) {
                    setState(() {
                      _data.setActiveStep(index);
                    });
                  },
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      const RemodelingOptionsWidget(),
                      const RemodelingImagesWidget(),
                      RemodelingContactsWidget(key: _contactsWidgetKey),
                      const RemodelingConfirmationWidget()
                    ],
                  ),
                ),
              ],
            ),
            // Header
            Container(
              width: double.infinity,
              height: RemodelingScheduler.stepTitleBarHeight,
              margin: EdgeInsets.only(top: _stepTitleBarTopMargin),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: const Alignment(0.0, 0.5),
                      colors: [
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0),
                    Theme.of(context).scaffoldBackgroundColor
                  ])),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: Text(_getStepTitle(context, _data.uiState.activeStep),
                      style: AppTheme.getStepTitleTextStyle(context))),
            ),
            // Bottom buttons
            ValueListenableBuilder<bool>(
                valueListenable: _data.uiState.showBottomButtons,
                builder: (context, showBottomButtons, child) {
                  return Container(
                      alignment: Alignment.bottomCenter,
                      child: !isKeyboardVisible && showBottomButtons
                          ? _getBottomButtons(context)
                          : null);
                })
          ]));
    });
  }

  @override
  void dispose() {
    //todo this may not run if user swipe close the app
    FileHelper.clearCache(child: FileHelper.remodelingCache);
    super.dispose();
  }

  String _getStepTitle(BuildContext context, int stepNumber) {
    switch (stepNumber) {
      case 0:
        return S.of(context).remodeling_options;
      case 1:
        return S.of(context).add_photos;
      case 2:
        return S.of(context).remodeling_address_and_contacts;
      case 3:
        return S.of(context).confirm;
      default:
        return '';
    }
  }

  void _nextStep() {
    var activeStep = _data.uiState.activeStep;
    if (activeStep < _totalSteps - 1) {
      _bottomButtonEnabled = false;
      setState(() {
        _data.setActiveStep(activeStep + 1);
      });
      _pageController
          .nextPage(
              duration: const Duration(milliseconds: 250), curve: Curves.easeIn)
          .whenComplete(() => _bottomButtonEnabled = true);
    }
  }

  void _previousStep() {
    var activeStep = _data.uiState.activeStep;
    if (activeStep > 0) {
      _bottomButtonEnabled = false;
      setState(() {
        _data.setActiveStep(activeStep - 1);
      });
      _pageController
          .previousPage(
              duration: const Duration(milliseconds: 250), curve: Curves.easeIn)
          .whenComplete(() => _bottomButtonEnabled = true);
    }
  }

  Widget _getBottomButtons(BuildContext context) {
    return Container(
        height: RemodelingScheduler.bottomButtonContainerHeight,
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0)
            ])),
        child: Padding(
            padding: const EdgeInsets.all(RemodelingScheduler.buttonSpacing),
            child: Row(
              mainAxisAlignment: _data.uiState.activeStep == 0
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                // Left button
                _data.uiState.activeStep == 0
                    ? Container()
                    : OutlinedButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        label: Text(S.of(context).back),
                        style: OutlinedButton.styleFrom(
                            minimumSize: Size(
                                _buttonWidth, RemodelingScheduler.buttonHeight),
                            shape: const StadiumBorder(),
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor),
                        onPressed: () {
                          _bottomButtonEnabled ? _previousStep() : null;
                        }),
                //Right button
                ValueListenableBuilder<bool>(
                    valueListenable: _data.uiState.rightButtonEnabled,
                    builder: (context, rightButtonEnabled, child) {
                      return ElevatedButton.icon(
                          icon: Icon(_data.uiState.activeStep < _totalSteps - 1
                              ? Icons.arrow_forward
                              : Icons.check),
                          label: Text(_data.uiState.activeStep < _totalSteps - 1
                              ? S.of(context).next
                              : S.of(context).confirm_remodeling),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                                _buttonWidth, RemodelingScheduler.buttonHeight),
                            shape: const StadiumBorder(),
                          ),
                          onPressed: !rightButtonEnabled
                              ? null // This null greys out the button
                              : () {
                                  // The check here won't grey out the button
                                  if (_bottomButtonEnabled) {
                                    switch (_data.uiState.activeStep) {
                                      case 2:
                                        _contactsWidgetKey.currentState!
                                                .validate()
                                            ? _nextStep()
                                            : null;
                                        break;
                                      case 3:
                                        // todo clearly notify the user that the order has been received
                                        sendOrder();
                                        // temp images are removed via dispose()
                                        break;
                                      default:
                                        _data.uiState.activeStep <
                                                _totalSteps - 1
                                            ? _nextStep()
                                            : null;
                                        break;
                                    }
                                  }
                                });
                    })
              ],
            )));
  }

  void sendOrder() async {
    // 1. Send JSON order

    // 2. Send order images to cloud
    var files =
        await FileHelper.getCacheFiles(child: FileHelper.remodelingCache);
    // todo need to match the images to which remodeling pic

    // remodeling_order_images/{uid}/{orderId}/
    final storageRef =
        FirebaseStorage.instance.ref('remodeling_order_images/dev');
    Map<File, Reference> refMap = {};

    for (var image in files) {
      //todo bug: will upload old cached files
      refMap[image] = storageRef.child(basename(image.path));
    }

    try {
      refMap.forEach((image, reference) async {
        debugPrint('Uploading $image to $reference'); //todo debug line
        await reference.putFile(image);
      });
    } on FirebaseException catch (e) {
      debugPrint(e.toString()); //todo notify user upload has failed
    }
  }
}
