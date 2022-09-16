import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/remodeling/scheduling/imaging/camera_widget.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/FileHelper.dart';

class RemodelingImageWizard extends StatefulWidget {
  const RemodelingImageWizard({Key? key, required this.item}) : super(key: key);

  final RemodelingItem item;

  @override
  State<StatefulWidget> createState() => RemodelingImageWizardState();
}

class RemodelingImageWizardState extends State<RemodelingImageWizard> {
  final List<File> _imageList = [];
  late List<ImagingInstruction> _instructionList;
  int _pictureIndex = 0;
  bool _cameraOn = false;

  @override
  Widget build(BuildContext context) {
    _instructionList =
        RemodelingItemHelper.getImagingInstructions(widget.item, context);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop()),
          title: Text(S.of(context).take_pictures)),
      floatingActionButton: Visibility(
        visible: !_cameraOn,
        child: FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              _cameraOn = true;
            });
          },
          label: Text(S.of(context).start_taking_picture),
          icon: const Icon(Icons.camera_alt),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(children: [
        _cameraOn
            ? CameraWidget(onFinish: (image) async {
                if (image != null) {
                  FileHelper.moveToSchedulerCache(File(image.path))
                      .then((newImage) {
                    _imageList.add(newImage);
                    _pictureIndex++;
                    setState(() => _cameraOn = false);
                    if (_pictureIndex == _instructionList.length) {
                      Navigator.of(context).pop(_imageList);
                    }
                  });
                } else {
                  setState(() => _cameraOn = false);
                }
              })
            : _pictureIndex <
                    _instructionList.length // Avoid index out of bound
                ? _getInstructions()
                : Container(),
      ]),
    );
  }

// todo add a "select from gallery" button for each image taking step (needs read and write permission)

  Widget _getInstructions() {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                    '${S.of(context).step} '
                    '${_pictureIndex + 1}/${_instructionList.length}',
                    style: AppTheme.getStepTitleTextStyle(context))),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                _instructionList[_pictureIndex].description,
                style: AppTheme.getHeadline6TextStyle(context),
              ),
            ),
            Image(image: _instructionList[_pictureIndex].image)
          ],
        ));
  }
}
