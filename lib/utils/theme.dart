import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  backgroundColor: Colors.white,
  iconTheme: const IconThemeData(color: Colors.blue),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  canvasColor: const Color(0xFF121212),
  backgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),
  iconTheme: const IconThemeData(color: Colors.white),
);
