import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/FileHelper.dart';

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
  late int _pictureIndex;

  @override
  void initState() {
    assert((widget.retake && widget.imageList != null) ||
        (!widget.retake && widget.imageList == null));

    _pictureIndex = widget.initialIndex;
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
          title: Text(S.of(context).take_pictures)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var image = await _picker.pickImage(source: ImageSource.camera);
          if (image != null) {
            FileHelper.moveToSchedulerCache(File(image.path)).then((newFile) {
              if (widget.retake) {
                _imageList.removeAt(widget.initialIndex);
                _imageList.insert(widget.initialIndex, newFile);
                Navigator.of(context).pop(_imageList);
              } else {
                _imageList.add(newFile);
                _pictureIndex++;
                if (_pictureIndex == _instructionList.length) {
                  Navigator.of(context).pop(_imageList);
                } else {
                  setState(() {});
                }
              }
            });
          }
        },
        label: Text(S.of(context).start_taking_picture),
        icon: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _getInstruction(),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Image(image: _instructionList[_pictureIndex].image))
      ]),
    );
  }

  Widget _getInstruction() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                  '${S.of(context).step} '
                  '${_pictureIndex + 1}/${_instructionList.length}',
                  style: AppTheme.getStepTitleTextStyle(context))),
          Text(
            _instructionList[_pictureIndex].description,
            style: AppTheme.getHeadline6TextStyle(context),
          )
        ]));
  }

// todo add a "select from gallery" button for each image taking step (needs read and write permission)
}