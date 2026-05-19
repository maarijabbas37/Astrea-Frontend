import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // We have moved to a single high-end Brown Theme for a premium experience.
  // This provider is kept for future flexibility but currently defaults to Light (Brown) mode.
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    // Currently disabled to maintain the premium Brown look.
    // _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    // notifyListeners();
  }
}
