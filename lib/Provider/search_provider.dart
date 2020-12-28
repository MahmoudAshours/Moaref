import 'package:flutter/foundation.dart';

class SearchProvider extends ChangeNotifier {
  bool show = true;
  void animateSearch(animate) {
    show = animate;
    notifyListeners();
  }
}
