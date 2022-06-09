import 'package:flutter/material.dart';

class BottomNavigationBarProvider extends ChangeNotifier {
  int pageIndex = 0;

  void setPageIndex(int index) {
    pageIndex = index;
    notifyListeners();
  }
}