import 'package:camera/camera.dart';

class CameraHelper {
  static late List<CameraDescription> cameras;

  static ensureInitialized() async {
    cameras = await availableCameras();
  }

  static CameraDescription? getBackCamera() {
    for (var camera in cameras) {
      if (camera.lensDirection == CameraLensDirection.back) {
        return camera;
      }
    }
    return null;
  }
}
