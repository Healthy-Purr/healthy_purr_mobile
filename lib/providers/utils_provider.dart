import 'package:flutter/material.dart';

class UtilsProvider extends ChangeNotifier {

  bool doNotShowAgain = true;

  void setToOff() {
    doNotShowAgain = false;
  }

}