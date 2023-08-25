import 'dart:io';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';
import 'package:hometeam_client/utils/file_helper.dart';
import 'package:path/path.dart';

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
  final StandardStepperController _controller = StandardStepperController();
  final GlobalKey<RemodelingContactsWidgetState> _contactsWidgetKey =
      GlobalKey<RemodelingContactsWidgetState>();
  int _activeStep = 0;
  bool _submitting = false;


  @override
  Widget build(BuildContext context) {
    // TODO backPressed dialog to confirm exiting

    final steps = [
      EasyStep(
          icon: const Icon(Icons.apartment),
          title: S.of(context).property_info),
      EasyStep(
          icon: const Icon(Icons.camera_alt), title: S.of(context).add_photos),
      EasyStep(
          icon: const Icon(Icons.edit_note), title: S.of(context).lease_terms),
      EasyStep(
          icon: const Icon(Icons.format_list_bulleted_add),
          title: S.of(context).create_listing),
      EasyStep(icon: const Icon(Icons.check), title: S.of(context).confirm),
    ];
    final pages = [
      const RemodelingOptionsWidget(),
      const RemodelingImagesWidget(),
      RemodelingContactsWidget(key: _contactsWidgetKey),
      const RemodelingConfirmationWidget()
    ];
    return StandardStepper(
      controller: _controller,
      title: S.of(context).remodeling,
      onActiveStepChanged: (activeStep) =>
          setState(() => _activeStep = activeStep),
      steps: steps,
      pages: pages,
      leftButtonIcon:
          Icon(_activeStep == 0 ? Icons.restart_alt : Icons.arrow_back),
      leftButtonLabel:
          Text(_activeStep == 0 ? S.of(context).reset : S.of(context).back),
      onLeftButtonPressed: () {
        _activeStep == 0
            ? null //_propertyInfoPageController.resetForm()
            : _controller.previousStep();
      },
      rightButtonIcon: _activeStep == steps.length - 1
          ? _submitting
              ? SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                      color: Theme.of(context).colorScheme.onPrimary))
              : const Icon(Icons.check)
          : const Icon(Icons.arrow_forward),
      rightButtonLabel: Text(_activeStep == steps.length - 1
          ? S.of(context).submit
          : S.of(context).next),
      onRightButtonPressed: () {
        switch (_activeStep) {
          case 4:
            _submitting ? null : null; //_submit(context);
            break;
          default:
            _controller.nextStep();
            break;
        }
      },
    );
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

  void sendOrder() async {
    // 1. Send JSON order

    // 2. Send order images to cloud
    var files = await FileHelper.getCacheFiles(
        subDirectory: FileHelper.remodelingCache);
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
