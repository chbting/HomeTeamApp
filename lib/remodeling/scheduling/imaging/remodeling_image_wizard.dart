import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/ui/custom_im_stepper/first_stepper/number_stepper.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/ui/two_button_bar.dart';
import 'package:tner_client/utils/file_helper.dart';

/// if [retake] is true, returns after taking the picture indicated by
/// initialIndex
class RemodelingImageWizard extends StatefulWidget {
  const RemodelingImageWizard(
      {Key? key,
      required this.item,
      this.imageList,
      this.initialIndex = 0,
      this.retake = false})
      : super(key: key);

  final RemodelingItem item;
  final List<File>? imageList;
  final int initialIndex;
  final bool retake;

  @override
  State<StatefulWidget> createState() => RemodelingImageWizardState();
}

class RemodelingImageWizardState extends State<RemodelingImageWizard> {
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
        RemodelingItemHelper.getImagingInstructions(widget.item, context);
    assert(widget.initialIndex < _instructionList.length);

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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  _instructionList[_activeIndex].description,
                  style: AppTheme.getHeadline6TextStyle(context),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Image(image: _instructionList[_activeIndex].image)),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TwoButtonBar(
                leftButtonLabel: Text(S.of(context).select_from_gallery),
                leftButtonIcon: const Icon(Icons.collections),
                onLeftButtonPressed: () {
                  _getImageFromSource(ImageSource.gallery);
                },
                rightButtonLabel: Text(S.of(context).take_photo),
                rightButtonIcon: const Icon(Icons.camera_alt),
                onRightButtonPressed: () {
                  _getImageFromSource(ImageSource.camera);
                }),
          )
        ]));
  }

  void _getImageFromSource(ImageSource source) {
    _picker.pickImage(source: source).then((image) {
      if (image != null) {
        FileHelper.moveToSchedulerCache(File(image.path)).then((newFile) {
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
              setState(() {});
            }
          }
        });
      }
    });
  }
}
