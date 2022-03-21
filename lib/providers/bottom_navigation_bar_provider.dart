import 'package:flutter/material.dart';

class BottomNavigationBarProvider extends ChangeNotifier {
  late int pageIndex;

  void setPageIndex(int index) {
    pageIndex = index;
    notifyListeners();
  }
}