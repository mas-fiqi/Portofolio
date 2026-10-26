import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // This portfolio is designed for dark mode only.
  // All colors, text, and backgrounds are optimized for the dark aesthetic.
  ThemeMode get themeMode => ThemeMode.dark;
  bool get isDarkMode => true;

  // No-op: theme cannot be toggled on this portfolio.
  void toggleTheme() {}
}
