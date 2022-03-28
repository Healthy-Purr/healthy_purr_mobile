import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class CameraViewModel extends ChangeNotifier{

  final List<File> _photos =  [];

  List<File> getPhotos() {
    return _photos;
  }

  addPhotoAfterShoot(File _photo){
    _photos.add(_photo);
    notifyListeners();
  }

  setPhotosFromGallery(List<XFile> photos){
    for(int i = 0; i < photos.length; i++){
      _photos.add(File(photos[i].path));
    }
    notifyListeners();
  }

}