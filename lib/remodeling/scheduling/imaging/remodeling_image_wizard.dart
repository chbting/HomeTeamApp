import 'dart:io';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:hometeam_client/generated/l10n.dart';
import 'package:hometeam_client/remodeling/remodeling_types.dart';
import 'package:hometeam_client/shared/ui/standard_stepper.dart';
import 'package:hometeam_client/theme/theme.dart';
import 'package:hometeam_client/utils/file_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

/// if [retake] is true, returns after taking the picture indicated by
/// initialIndex
class RemodelingImageWizard extends StatefulWidget {
  const RemodelingImageWizard(
      {Key? key,
      required this.type,
      this.imageList,
      this.initialIndex = 0,
      this.retake = false})
      : super(key: key);

  final RemodelingType type;
  final List<File>? imageList;
  final int initialIndex;
  final bool retake;

  @override
  State<StatefulWidget> createState() => RemodelingImageWizardState();
}

class RemodelingImageWizardState extends State<RemodelingImageWizard> {
  final StandardStepperController _controller = StandardStepperController();
  final ImagePicker _picker = ImagePicker();
  final List<File> _imageList = [];
  late List<ImagingInstruction> _instructionList;
  late int _activeIndex;

  @override
  void initState() {
    assert((widget.retake && widget.imageList != null) ||
        (!widget.retake && widget.imageList == null));

    _activeIndex = widget.initialIndex;
    if (widget.imageList != null) {
      _imageList.addAll(widget.imageList!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _instructionList =
        RemodelingTypeHelper.getImagingInstructions(widget.type, context);

    List<EasyStep> steps = [];
    List<Widget> pages = [];
    for (int i = 0; i < _instructionList.length; i++) {
      var imagingInstruction = _instructionList[i];
      steps.add(EasyStep(
          customStep: Text('${i + 1}',
              style: AppTheme.getTitleLargeTextStyle(context)?.copyWith(
                  color: _activeIndex > i
                      ? Theme.of(context).colorScheme.onPrimary
                      : _activeIndex == i
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface)),
          title: ''));
      pages.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            imagingInstruction.description,
            style: AppTheme.getTitleLargeTextStyle(context),
          ),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Image(image: imagingInstruction.image)),
      ]));
    }

    return StandardStepper(
      controller: _controller,
      title:
          widget.retake ? S.of(context).change_photo : S.of(context).add_photos,
      steps: steps,
      pages: pages,
      onActiveStepChanged: (activeStep) =>
          setState(() => _activeIndex = activeStep),
      leftButtonLabel: Text(S.of(context).select_from_gallery),
      leftButtonIcon: const Icon(Icons.collections),
      onLeftButtonPressed: () =>
          _getImageFromSource(context, ImageSource.gallery),
      rightButtonLabel: Text(S.of(context).take_photo),
      rightButtonIcon: const Icon(Icons.camera_alt),
      onRightButtonPressed: () =>
          _getImageFromSource(context, ImageSource.camera),
    );
  }

  void _getImageFromSource(BuildContext context, ImageSource source) {
    _picker.pickImage(source: source).then((image) {
      if (image != null) {
        // Standardize image names with enum type and step number
        // todo multiple ac's
        var imageName =
            '${widget.type.name}_${_activeIndex + 1}${extension(image.path)}';
        FileHelper.moveToCache(
                file: File(image.path),
                subDirectory: FileHelper.remodelingCache,
                newFileName: imageName)
            .then((newFile) {
          if (widget.retake) {
            _imageList.removeAt(widget.initialIndex);
            _imageList.insert(widget.initialIndex, newFile);
            Navigator.of(context).pop(_imageList);
          } else {
            _imageList.add(newFile);
            _activeIndex++;
            if (_activeIndex == _instructionList.length) {
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
