import 'package:flutter/material.dart';

class RegisterProvider extends ChangeNotifier {

  bool loader = false;
  bool isHiddenPassword = true;

  void updateLoader(bool newLoader) {
    loader = newLoader;
    notifyListeners();
  }

  void updateHiddenState(bool isHidden) {
    isHiddenPassword = isHidden;
    notifyListeners();
  }

}