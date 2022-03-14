import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  backgroundColor: Colors.white,
  fontFamily: 'googleFont',
  iconTheme: const IconThemeData(color: Colors.blue),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  canvasColor: const Color(0xFF121212),
  fontFamily: 'googleFont',
  backgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),
  primaryColor: Colors.blue,
  iconTheme: const IconThemeData(color: Colors.white),
);
