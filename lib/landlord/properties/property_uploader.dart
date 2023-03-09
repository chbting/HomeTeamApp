import 'package:easy_stepper/easy_stepper.dart';
import 'package:hometeam_client/data/property.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/json_model/address.dart';
import 'package:hometeam_client/json_model/contract.dart';
import 'package:hometeam_client/json_model/listing.dart';
import 'package:hometeam_client/landlord/properties/property_info.dart';
import 'package:hometeam_client/ui/shared/standard_stepper.dart';

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

  final Property _property = Property(
      address: Address(),
      coverImage: const AssetImage(''), //todo default
      contract: Contract(),
      listing: Listing(title: ''));
  int _activeStep = 0;

  @override
  Widget build(BuildContext context) {
    final steps = [
      EasyStep(
          icon: const Icon(Icons.apartment),
          title: S.of(context).property_info),
      EasyStep(
          icon: const Icon(Icons.camera_alt), title: S.of(context).add_photos),
      EasyStep(
          icon: const Icon(Icons.format_list_bulleted_add),
          title: S.of(context).create_listing),
      EasyStep(icon: const Icon(Icons.check), title: S.of(context).confirm),
    ];
    final pages = [
      PropertyInfoWidget(
          property: _property, controller: _propertyInfoWidgetController),
      const Center(child: Text('2')),
      const Center(child: Text('3')),
      const Center(child: Text('4'))
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
      rightButtonIcon:
          Icon(_activeStep == 3 ? Icons.check : Icons.arrow_forward),
      rightButtonLabel:
          Text(_activeStep == 3 ? S.of(context).submit : S.of(context).next),
      onRightButtonPressed: () {
        switch (_activeStep) {
          case 0:
            if (_propertyInfoWidgetController.validate()) {
              _controller.nextStep();
            }
            break;
          case 3:
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
    // todo
  }
}
