import 'dart:io';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/property.dart';
import 'package:hometeam_client/landlord/properties/uploader/lease_terms.dart';
import 'package:hometeam_client/landlord/properties/uploader/property_images.dart';
import 'package:hometeam_client/landlord/properties/uploader/property_info.dart';
import 'package:hometeam_client/landlord/properties/uploader/property_uploader_confirmation.dart';
import 'package:hometeam_client/shared/listing_inherited_data.dart';
import 'package:hometeam_client/shared/ui/form_controller.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';
import 'package:hometeam_client/utils/file_helper.dart';
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
  final PropertyInfoWidgetController _propertyInfoWidgetController =
      PropertyInfoWidgetController();
  final FormController _leaseTermsWidgetController = FormController();
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
      PropertyInfoWidget(controller: _propertyInfoWidgetController),
      const PropertyImagesWidget(), //todo make it video base
      LeaseTermsWidget(controller: _leaseTermsWidgetController),
      const Center(child: Text('4')),
      const PropertyUploaderConfirmationWidget()
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
            ? _propertyInfoWidgetController.resetForm()
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
            //todo
            //if (_propertyInfoWidgetController.validate()) {
            _controller.nextStep();
            // }
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

  void _submit(BuildContext context) {
    debugPrint('submitting');
    setState(() => _submitting = true);
    Property property = ListingInheritedData.of(context)!.property;
    //var listing = ListingInheritedData.of(context)!.listing;

    // Generate property ID
    DatabaseReference propertyRef =
        FirebaseDatabase.instance.ref('property/').push(); //todo
    if (propertyRef.key == null) {
      setState(() => _submitting = false);
      StandardStepper.showSnackBar(
          context, S.of(context).property_upload_error);
    } else {
      propertyRef.set(property.toJson()).then((_) {
        _uploadImages(property, propertyRef.key!); //todo should do notification about image upload
        Navigator.of(context).pop(true);
      }).catchError((error, stackTrace) {
        debugPrint('error $error'); //todo
        StandardStepper.showSnackBar(
            context, S.of(context).property_upload_error);
      }).whenComplete(() => setState(() => _submitting = false));
    }
  }

  void _uploadImages(Property property, String propertyId) async {
    Map<File, Reference> refMap = {};
    Reference storage =
        FirebaseStorage.instance.ref('images/property/$propertyId/');
    property.rooms.forEach((roomType, roomList) {
      for (var room in roomList) {
        for (var image in room.images) {
          refMap[image] = storage.child(basename(image.path));
        }
      }
    });
    // todo unique name DateTime.now().milisinceepoch
    //todo upload video
    try {
      refMap.forEach((image, reference) async {
        debugPrint('Uploading $image to $reference'); //todo debug line
        var imageUrl = await reference.putFile(image);
        debugPrint('imageUrl:$imageUrl, path:${imageUrl.ref.fullPath}');
        // todo save imageUrl to database in sequence
      });
    } on FirebaseException catch (e) {
      debugPrint(e.toString()); //todo notify user upload has failed
    }
  }
}
