import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/remodeling/remodeling_items.dart';
import 'package:tner_client/utils/camera_helper.dart';

class RemodelingCameraScreen extends StatefulWidget {
  const RemodelingCameraScreen({Key? key, required this.item})
      : super(key: key);

  final RemodelingItem item;

  @override
  State<RemodelingCameraScreen> createState() => RemodelingCameraScreenState();
}

class RemodelingCameraScreenState extends State<RemodelingCameraScreen> {
  CameraController? _controller;
  Future<void>? _controllerFuture;
  String? _imagePath;

  final _fabBottomMargin = 16.0;

  @override
  void initState() {
    super.initState();
    try {
      _controller = CameraController(
          CameraHelper.cameras.first, ResolutionPreset.veryHigh,
          enableAudio: false, imageFormatGroup: ImageFormatGroup.jpeg);
      _controllerFuture = _controller?.initialize().catchError((Object e) {
        // On permission denied
        _controllerFuture = null;
      });
    } on StateError catch (_) {
      // On no camera found
    }
  }

  @override
  void dispose() {
    _controller
        ?.dispose(); //todo clean up images? probably save to a specific folder and clean up every time
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build: $_imagePath');
    return Scaffold(
        appBar: AppBar(title: Text(S.of(context).take_pictures)),
        body: _controllerFuture == null
            ? Center(child: Text(S.of(context).cameras_not_available))
            : _imagePath != null
                ? Stack(children: [
                    Image.file(File(_imagePath!)),
                    Padding(
                        padding: EdgeInsets.only(bottom: _fabBottomMargin),
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FloatingActionButton.large(
                                    onPressed: () {
                                      File(_imagePath!).delete().then((value) {
                                        debugPrint('value:$value');
                                        setState(() {
                                          _imagePath ==
                                              null; //todo not setting to null
                                          debugPrint('imagePath:$_imagePath');
                                        });
                                      });
                                    },
                                    heroTag: 'decline_button',
                                    backgroundColor: Colors.white,
                                    child: const Icon(Icons.clear)),
                                FloatingActionButton.large(
                                    onPressed: () {
                                      // todo pop and return the file path to parent
                                    },
                                    heroTag: 'accept_button',
                                    child: const Icon(Icons.check))
                              ],
                            )))
                  ])
                : FutureBuilder<void>(
                    future: _controllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Stack(
                          children: [
                            CameraPreview(_controller!),
                            Visibility(
                                visible: _imagePath == null,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: _fabBottomMargin),
                                    child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: FloatingActionButton.large(
                                            onPressed: () async {
                                              try {
                                                // Ensure that the camera is initialized.
                                                await _controllerFuture;
                                                _controller?.setFlashMode(
                                                    FlashMode.off);
                                                final image = await _controller
                                                    ?.takePicture();

                                                debugPrint(
                                                    'image saved: ${image?.path}');

                                                if (!mounted) return;
                                                setState(() {
                                                  _imagePath = image?.path;
                                                }); // todo flash light still on after taking picture

                                                // todo allow different orientation?
                                              } catch (e) {
                                                debugPrint('$e');
                                              }
                                            },
                                            heroTag: 'picture_button',
                                            child: const Icon(
                                                Icons.photo_camera)))))
                          ],
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ));
  }
}
