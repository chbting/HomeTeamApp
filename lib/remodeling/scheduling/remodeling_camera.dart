import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/ui/theme.dart';
import 'package:tner_client/utils/camera_helper.dart';
import 'package:tner_client/utils/shared_preferences_helper.dart';

class RemodelingCameraScreen extends StatefulWidget {
  const RemodelingCameraScreen({Key? key}) : super(key: key);

  @override
  State<RemodelingCameraScreen> createState() => RemodelingCameraScreenState();
}

class RemodelingCameraScreenState extends State<RemodelingCameraScreen> {
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
    _controller
        .dispose(); //todo clean up images? probably save to a specific folder and clean up every time
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(S.of(context).take_pictures)),
        body: _controllerFuture == null
            ? Center(child: Text(S.of(context).cameras_not_available))
            : FutureBuilder<void>(
                future: _controllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (_image == null) {
                      return Stack(
                        children: [
                          CameraPreview(_controller),
                          Padding(
                              padding:
                                  EdgeInsets.only(bottom: _fabBottomMargin),
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: FloatingActionButton.large(
                                      onPressed: () async {
                                        try {
                                          // Ensure that the camera is initialized.
                                          await _controllerFuture;
                                          final image =
                                              await _controller.takePicture();
                                          _image = File(image.path);

                                          if (!mounted) return;
                                          setState(() {});
                                        } catch (e) {
                                          debugPrint(
                                              'Exception when taking pictures: $e');
                                        }
                                      },
                                      heroTag: 'picture_button',
                                      child: const Icon(Icons.photo_camera))))
                        ],
                      );
                    } else {
                      debugPrint(
                          '${Theme.of(context).colorScheme.onSecondary},${Theme.of(context).colorScheme.secondary}');
                      return Stack(children: [
                        Image.file(File(_image!.path)),
                        Padding(
                            padding: EdgeInsets.only(bottom: _fabBottomMargin),
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                        foregroundColor: SharedPreferencesHelper.isDarkMode()? Theme.of(context).colorScheme.onSecondary:
                                            AppTheme.getPrimaryColor(context), //todo light theme only
                                        child: const Icon(Icons.clear)),
                                    FloatingActionButton.large(
                                        onPressed: () {
                                          Navigator.pop(context, _image);
                                        },
                                        heroTag: 'accept_button',
                                        child: const Icon(Icons.check))
                                  ],
                                )))
                      ]);
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ));
  }
}
