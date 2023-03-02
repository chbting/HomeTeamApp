import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/ui/custom_im_stepper/first_stepper/number_stepper.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/ui/two_button_bar.dart';
import 'package:tner_client/utils/file_helper.dart';

import '../../remodeling_types.dart';

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
  bool _bottomButtonEnabled = true;
  final ImagePicker _picker = ImagePicker();
  final List<File> _imageList = [];
  late List<ImagingInstruction> _instructionList;
  late int _activeIndex;
  late PageController _pageController;

  @override
  void initState() {
    assert((widget.retake && widget.imageList != null) ||
        (!widget.retake && widget.imageList == null));

    _activeIndex = widget.initialIndex;
    if (widget.imageList != null) {
      _imageList.addAll(widget.imageList!);
    }
    _pageController = PageController(initialPage: widget.initialIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _instructionList =
        RemodelingTypeHelper.getImagingInstructions(widget.type, context);

    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop()),
            title: Text(widget.retake
                ? S.of(context).change_photo
                : S.of(context).add_photos)),
        body: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.retake
                  ? const SizedBox()
                  : CustomNumberStepper(
                      numbers: List<int>.generate(
                          _instructionList.length, (i) => i + 1),
                      numberStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary),
                      activeStep: _activeIndex,
                      activeStepBorderWidth: 2.0,
                      activeStepBorderPadding: 5.0,
                      activeStepColor: Theme.of(context).colorScheme.secondary,
                      enableNextPreviousButtons: false,
                      enableStepTapping: false,
                      showIsStepCompleted: true,
                      stepRadius: 20.0,
                      lineColor: Theme.of(context).colorScheme.onSurface,
                      onStepReached: (index) {
                        setState(() {
                          _activeIndex = index;
                        });
                      },
                    ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              _instructionList[index].description,
                              style: AppTheme.getTitleLargeTextStyle(context),
                            ),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child:
                                  Image(image: _instructionList[index].image)),
                        ]);
                  },
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TwoButtonBar(
                leftButtonLabel: Text(S.of(context).select_from_gallery),
                leftButtonIcon: const Icon(Icons.collections),
                onLeftButtonPressed: () => _bottomButtonEnabled
                    ? _getImageFromSource(context, ImageSource.gallery)
                    : null,
                rightButtonLabel: Text(S.of(context).take_photo),
                rightButtonIcon: const Icon(Icons.camera_alt),
                onRightButtonPressed: () => _bottomButtonEnabled
                    ? _getImageFromSource(context, ImageSource.camera)
                    : null),
          )
        ]));
  }

  void _nextStep() {
    setState(() {
      _bottomButtonEnabled = false;
    });
    _pageController
        .nextPage(
            duration: const Duration(milliseconds: 500), curve: Curves.easeIn)
        .whenComplete(() => _bottomButtonEnabled = true);
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
                child: FileHelper.remodelingCache,
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
              _nextStep();
            }
          }
        });
      }
    });
  }
}
