import 'package:flutter/foundation.dart';

class OrientationProvider extends ChangeNotifier {
  String _orientation = "mobile";
  int _pagesIndex = 0;
  set orientation(String or) {
    _orientation = or;
    notifyListeners();
  }

  set pageIndex(int i) {
    if (i > 0 || i < 2) {
      _pagesIndex = i;
      print(i);
      notifyListeners();
    }
  }

  void reset() {
    _pagesIndex = 0;
    _orientation = "mobile";
  }

  int get getIndex => _pagesIndex;

  String get getOrientation => _orientation;
}
