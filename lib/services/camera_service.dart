import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class CameraService {

  Future<CameraDescription> getCameras() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    return cameras.first;
  }

}