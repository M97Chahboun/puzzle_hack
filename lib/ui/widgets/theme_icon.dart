import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import 'package:puzzle_hack/extensions.dart';

class ThemeIcon extends StatelessWidget {
  const ThemeIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return McMV(global.themeMode, () {
      bool isDark = Theme.of(context).brightness == Brightness.dark;
      return IconButton(
          onPressed: () {
            global.themeMode.v = isDark ? ThemeMode.light : ThemeMode.dark;
          },
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode));
    });
  }
}
