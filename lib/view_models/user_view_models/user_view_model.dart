import 'package:flutter/material.dart';
import '../../models/model.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';


class UserViewModel {

  ImageProvider? _userImage;

  ImageProvider getUserImage() {
    return _userImage!;
  }

  Future<void> setUserImage() async {

    ImageProvider image = await UserService().getUserImage(UserSession().id!);

    _userImage = image;

  }

}