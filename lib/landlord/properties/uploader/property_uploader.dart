import 'package:easy_stepper/easy_stepper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/landlord/properties/uploader/lease_terms.dart';
import 'package:hometeam_client/landlord/properties/uploader/property_info.dart';
import 'package:hometeam_client/shared/listing_inherited_data.dart';
import 'package:hometeam_client/shared/ui/form_controller.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';
import 'package:hometeam_client/utils/file_helper.dart';

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
      const Text('2'), //PropertyImagesWidget(),
      LeaseTermsWidget(controller: _leaseTermsWidgetController),
      const Center(child: Text('4')),
      const Center(child: Text('5'))
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
      rightButtonIcon: Icon(
          _activeStep == steps.length - 1 ? Icons.check : Icons.arrow_forward),
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
            _confirm();
            break;
          default:
            _controller.nextStep();
            break;
        }
      },
    );
  }

  void _confirm() {
    var listing = ListingInheritedData.of(context)!.listing;
    Property property = ListingInheritedData.of(context)!.property;
    //todo push a property, it should receive an id

    debugPrint('submitting');
    DatabaseReference ref = FirebaseDatabase.instance.ref('property/');
    // ref.set(property.toJson()).onError((error, stackTrace) {
    //   debugPrint('error $error');
    // }).then((value) {
    //   //todo show snackBar with property submitted and an option to view it
    //   debugPrint('submitted');
    // });
  }
}
