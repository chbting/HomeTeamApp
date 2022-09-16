import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/camera_helper.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({Key? key, required this.onFinish}) : super(key: key);

  final ValueSetter<File?> onFinish;

  @override
  State<CameraWidget> createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  final _pictureAspectRatio = 4 / 3;
  late CameraController _controller;
  Future<void>? _controllerFuture;
  File? _image;
  bool _processing = false;

  final _fabBottomMargin = 16.0;

  @override
  void initState() {
    super.initState();
    try {
      var camera = CameraHelper.getBackCamera();
      if (camera == null) throw Exception('No back camera');

      /// Wait for the official package to enable the 4:3 aspect ratio
      _controller = CameraController(camera, ResolutionPreset.max,
          enableAudio: false, imageFormatGroup: ImageFormatGroup.jpeg);
      _controllerFuture = _controller.initialize().catchError((Object e) {
        // On permission denied
        _controllerFuture = null;
      }).then((_) {
        // Turning flash off because it goes haywire in the current package
        _controller.setFlashMode(FlashMode.off);
        // todo allow different orientation
        //  _controller.unlockCaptureOrientation();
      });
    } on Exception catch (e) {
      debugPrint('$e');
      _controllerFuture = null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: _controllerFuture == null
            ? Center(child: Text(S.of(context).cameras_not_available))
            : FutureBuilder<void>(
                future: _controllerFuture,
                builder: (context, snapshot) {
                  return _image == null
                      ? snapshot.connectionState == ConnectionState.done
                          ? _getCamera(context)
                          : const Center(child: CircularProgressIndicator())
                      : _getPictureViewer();
                },
              ));
  }

  Widget _getCamera(BuildContext context) {
    // todo need a back button
    var size = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        // Fit camera preview to custom aspect ratio
        SizedBox(
          width: size,
          height: size * _pictureAspectRatio,
          child: ClipRect(
            child: OverflowBox(
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: SizedBox(
                  width: size,
                  height: size * _controller.value.aspectRatio,
                  child: Stack(
                    children: [
                      CameraPreview(_controller),
                      _processing
                          ? Align(
                              alignment: Alignment.center,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(S.of(context).processing,
                                          style: AppTheme.getHeadline6TextStyle(
                                              context)),
                                    ),
                                    const CircularProgressIndicator()
                                  ]))
                          : const SizedBox()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(bottom: _fabBottomMargin),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton.large(
                    onPressed: () async {
                      try {
                        // Ensure that the camera is initialized.
                        setState(() => _processing = true);
                        await _controllerFuture;
                        final image = await _controller.takePicture();

                        // todo Resize picture
                        _image = File(image.path);

                        if (!mounted) return;
                        setState(() => _processing = false);
                      } catch (e) {
                        debugPrint('$e');
                      }
                    },
                    heroTag: 'shutter_button',
                    child: const Icon(Icons.camera)))) //SizedBox()
      ],
    );
  }

  Widget _getPictureViewer() {
    // Show the picture and ok and reject buttons
    return Stack(children: [
      Image.file(File(_image!.path)), //todo size to fill
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
