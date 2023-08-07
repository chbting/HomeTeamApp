import 'dart:async';
import 'dart:io';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/json_model/property.dart';
import 'package:hometeam_client/landlord/properties/uploader/lease_terms.dart';
import 'package:hometeam_client/landlord/properties/uploader/property_images.dart';
import 'package:hometeam_client/landlord/properties/uploader/property_info.dart';
import 'package:hometeam_client/landlord/properties/uploader/property_uploader_confirmation.dart';
import 'package:hometeam_client/shared/property_uploader_inherited_data.dart';
import 'package:hometeam_client/shared/ui/form_controller.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';
import 'package:hometeam_client/utils/file_helper.dart';
import 'package:hometeam_client/utils/firebase_path.dart';
import 'package:path/path.dart';

class PropertyUploader extends StatefulWidget {
  const PropertyUploader({Key? key}) : super(key: key);

  static const stepTitleBarHeight = 40.0;
  static const buttonHeight = 48.0; // Same as an extended floatingActionButton
  static const buttonSpacing = 16.0;
  static const bottomButtonContainerHeight = buttonHeight + buttonSpacing * 2;

  @override
  State<StatefulWidget> createState() => PropertyUploaderState();
}

class PropertyUploaderState extends State<PropertyUploader> {
  final StandardStepperController _controller = StandardStepperController();
  final PropertyInfoPageController _propertyInfoPageController =
      PropertyInfoPageController();
  final FormController _leaseTermsPageController = FormController();
  int _activeStep = 0;
  bool _submitting = false;

  @override
  void dispose() {
    //todo this may not run if user swipe close the app
    FileHelper.clearCache(child: FileHelper.propertyUploaderCache);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      PropertyInfoPage(controller: _propertyInfoPageController),
      const PropertyImagesPage(), //todo make it video base
      LeaseTermsPage(controller: _leaseTermsPageController),
      const Center(child: Text('4')),
      const PropertyUploaderConfirmationPage()
    ];

    return StandardStepper(
      controller: _controller,
      title: S.of(context).add_property,
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
            ? _propertyInfoPageController.resetForm()
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
          case 0:
            if (_propertyInfoPageController.validate()) {
              _controller.nextStep();
            } else {
              StandardStepper.showSnackBar(context,
                  S.of(context).msg_please_fill_in_the_required_information);
            }
            break;
          case 2:
            if (_leaseTermsPageController.validate()) {
              _controller.nextStep();
            } else {
              StandardStepper.showSnackBar(context,
                  S.of(context).msg_please_fill_in_the_required_information);
            }
            break;
          case 4:
            _submitting ? null : _submit(context);
            break;
          default:
            _controller.nextStep();
            break;
        }
      },
    );
  }

  void _submit(BuildContext context) async {
    setState(() => _submitting = true);
    Property property = PropertyUploaderInheritedData.of(context)!.property;
    Listing listing = PropertyUploaderInheritedData.of(context)!.listing;

    // Generate property & listing IDs
    DatabaseReference propertyRef =
        FirebaseDatabase.instance.ref(FirebasePath.properties).push();
    DatabaseReference listingRef =
        FirebaseDatabase.instance.ref(FirebasePath.listings).push();

    if (propertyRef.key == null || listingRef.key == null) {
      setState(() => _submitting = false);
      StandardStepper.showSnackBar(
          context, S.of(context).property_upload_error);
    } else {
      var propertyJson = property.toJson();
      var listingJson = listing.toJson();

      try {
        // todo upload to a provisional table instead
        await propertyRef.set(propertyJson);
        await listingRef.set(listingJson);
        await _uploadImages(property, propertyRef.key!);
      } on FirebaseException catch (e) {
        _onUploadError(context, e);
        return;
      }

      if (mounted) {
        setState(() => _submitting = false);
        Navigator.of(context).pop(true);
      }
    }
  }

  void _onUploadError(BuildContext context, dynamic error) {
    debugPrint('_onUploadError $error'); //todo
    StandardStepper.showSnackBar(context, S.of(context).property_upload_error);
    setState(() => _submitting = false);
  }

  Future<void> _uploadImages(Property property, String propertyId) {
    Completer<void> completer = Completer();
    Map<File, Reference> refMap = {};
    Reference storageRef = FirebaseStorage.instance
        .ref(FirebasePath.getPropertyImagesPath(propertyId));

    // Get a reference for every image to be uploaded
    property.rooms.forEach((roomType, roomList) {
      for (var room in roomList) {
        for (var image in room.images) {
          refMap[image] = storageRef.child(basename(image.path));
        }
      }
    });
    //todo upload video
    int count = 0;
    refMap.forEach((image, reference) {
      reference.putFile(image).then((_) {
        count++;
        debugPrint('uploaded image $count of ${refMap.length}');
        count == refMap.length ? completer.complete() : null;
      }).catchError((e) {
        debugPrint('Has an error: ${e.toString()}'); //todo how to handle a single image/multiple images upload failure?
      });
    });
    return completer.future;
  }
}
