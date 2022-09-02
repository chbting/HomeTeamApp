import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tner_client/generated/l10n.dart';
import 'package:tner_client/remodeling/scheduling/remodeling_scheduling_data.dart';
import 'package:tner_client/utils/camera_helper.dart';

class RemodelingCameraWidget extends StatefulWidget {
  const RemodelingCameraWidget({Key? key, required this.data})
      : super(key: key);

  final RemodelingSchedulingData data;

  @override
  State<RemodelingCameraWidget> createState() => RemodelingCameraWidgetState();
}

class RemodelingCameraWidgetState extends State<RemodelingCameraWidget> {
  CameraController? _controller;
  Future<void>? _controllerFuture;

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
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {// todo take picture button and next picture UI
    return _controllerFuture == null
        ? Center(child: Text(S.of(context).cameras_not_available))
        : FutureBuilder<void>(
            future: _controllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller!);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
  }
}
