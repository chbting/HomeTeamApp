import 'package:camera/camera.dart';

class CameraHelper {
  static late List<CameraDescription> cameras;

  static ensureInitialized() async {
    cameras = await availableCameras();
  }
}
