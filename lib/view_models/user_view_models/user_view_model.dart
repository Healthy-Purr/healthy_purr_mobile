import 'package:flutter/material.dart';
import '../../models/model.dart';
import 'package:healthy_purr_mobile_app/services/service.dart';


class UserViewModel{

  ImageProvider? _userImage;

  ImageProvider getUserImage() {
    return _userImage!;
  }

  Future<void> setUserImage() async {

    _userImage = null;

    ImageProvider image = await UserService().getUserImage(UserSession().id!);

    _userImage = image;

  }

}