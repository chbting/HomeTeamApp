import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/utils/camera_helper.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({Key? key, required this.onFinish}) : super(key: key);

  final ValueSetter<File?> onFinish;

  @override
  State<CameraWidget> createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller;
  Future<void>? _controllerFuture;
  File? _image;

  final _fabBottomMargin = 16.0;

  @override
  void initState() {
    super.initState();
    try {
      _controller = CameraController(
          CameraHelper.cameras.first, ResolutionPreset.max, // todo aspect ratio
          enableAudio: false,
          imageFormatGroup: ImageFormatGroup.jpeg);
      _controllerFuture = _controller.initialize().catchError((Object e) {
        // On permission denied
        _controllerFuture = null;
      }).then((_) => _controller.setFlashMode(
          FlashMode.off)); // Turning flash off because it goes haywire
      // todo allow different orientation
    } on StateError catch (_) {
      // On no camera found
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //todo container or expanded?
        //color: Theme.of(context).scaffoldBackgroundColor,
        child: _controllerFuture == null
            ? Center(child: Text(S.of(context).cameras_not_available))
            : FutureBuilder<void>(
                future: _controllerFuture,
                builder: (context, snapshot) {
                  return _image == null
                      ? snapshot.connectionState == ConnectionState.done
                          ? _getCamera()
                          : const Center(child: CircularProgressIndicator())
                      : _getPictureViewer();
                },
              ));
  }

  Widget _getCamera() {
    // todo need a back button
    return Stack(
      children: [
        CameraPreview(_controller),
        Padding(
            padding: EdgeInsets.only(bottom: _fabBottomMargin),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton.large(
                    onPressed: () async {
                      try {
                        // Ensure that the camera is initialized.
                        await _controllerFuture;
                        final image = await _controller.takePicture();
                        _image = File(image.path);

                        if (!mounted) return;
                        setState(() {});
                      } catch (e) {
                        debugPrint('$e');
                      }
                    },
                    heroTag: 'shutter_button',
                    child: const Icon(Icons.camera))))
      ],
    );
  }

  Widget _getPictureViewer() {
    // Show the picture and ok and reject buttons
    return Stack(children: [
      Image.file(File(_image!.path)),
      Padding(
          padding: EdgeInsets.only(bottom: _fabBottomMargin),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton.large(
                      onPressed: () {
                        File(_image!.path).delete().then((_) {
                          setState(() {
                            _image = null;
                          });
                        });
                      },
                      heroTag: 'reject_button',
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      child: const Icon(Icons.clear)),
                  FloatingActionButton.large(
                      onPressed: () {
                        widget.onFinish(_image);
                      },
                      heroTag: 'ok_button',
                      child: const Icon(Icons.check))
                ],
              )))
    ]);
  }
}
