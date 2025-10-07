import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  bool showResult = false;

  void goToResult() {
    showResult = true;
    notifyListeners();
  }

  void goToPrompt() {
    showResult = false;
    notifyListeners();
  }
}
