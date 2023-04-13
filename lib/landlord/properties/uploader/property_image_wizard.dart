import 'dart:io';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/shared/theme/theme.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';
import 'package:hometeam_client/utils/file_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

/// if [retake] is true, returns after taking the picture indicated by
/// imageIndex
class PropertyImagesWizard extends StatefulWidget {
  const PropertyImagesWizard(
      {Key? key,
      required this.roomKey,
      this.imageIndex = 0,
      this.retake = false})
      : super(key: key);

  final int roomKey;
  final int imageIndex;
  final bool retake;

  @override
  State<StatefulWidget> createState() => PropertyImagesWizardState();
}

class PropertyImagesWizardState extends State<PropertyImagesWizard> {
  bool _bottomButtonEnabled = true;
  final ImagePicker _picker = ImagePicker();
  final StandardStepperController _controller = StandardStepperController();
  final List<File> _imageList = [];
  late int _activeStep;
  late List<EasyStep> _steps;

  @override
  void initState() {
    _activeStep = widget.imageIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _steps = [
      EasyStep(
          icon: const Icon(Icons.apartment),
          title: S.of(context).property_info),
    ];
    final pages = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Text(
          'Imaging instructions go here',
          style: AppTheme.getTitleLargeTextStyle(context),
        ),
      ),
    ];

    // todo single instruction
    return StandardStepper(
      controller: _controller,
      title:
          widget.retake ? S.of(context).change_photo : S.of(context).add_photos,
      onActiveStepChanged: (activeStep) =>
          setState(() => _activeStep = activeStep),
      steps: _steps,
      pages: pages,
      leftButtonLabel: Text(S.of(context).select_from_gallery),
      leftButtonIcon: const Icon(Icons.collections),
      onLeftButtonPressed: () => _bottomButtonEnabled
          ? _getImageFromSource(context, ImageSource.gallery)
          : null,
      rightButtonLabel: Text(S.of(context).take_photo),
      rightButtonIcon: const Icon(Icons.camera_alt),
      onRightButtonPressed: () => _bottomButtonEnabled
          ? _getImageFromSource(context, ImageSource.camera)
          : null,
    );
  }

  void _getImageFromSource(BuildContext context, ImageSource source) {
    _picker.pickImage(source: source).then((image) {
      if (image != null) {
        // Standardize image names with enum type and step number
        //todo count
        int count = 1;
        var imageName = '${widget.roomKey}_$count${extension(image.path)}';
        FileHelper.moveToCache(
                file: File(image.path),
                child: FileHelper.propertyUploaderCache,
                newFileName: imageName)
            .then((newFile) {
          if (widget.retake) {
            // _imageList.removeAt(widget.imageIndex);
            // _imageList.insert(widget.imageIndex, newFile);
            Navigator.of(context).pop(_imageList);
          } else {
            _imageList.add(newFile);
            _activeStep++;
            if (_activeStep == _steps.length) {
              Navigator.of(context).pop(_imageList);
            } else {
              _controller.nextStep();
            }
          }
        });
      }
    });
  }
}

/// The image size should be 500x500 px
class ImagingInstruction {
  String description;
  AssetImage image;

  ImagingInstruction(this.description, this.image);
}
