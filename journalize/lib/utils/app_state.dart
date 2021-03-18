import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  AppFont currentApp = AppFont.system;

  void setFont(AppFont font) {
    currentApp = font;
    notifyListeners();
  }
}

enum AppFont {
  system,
  dosis,
  exo,
}
