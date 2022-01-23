import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import 'package:puzzle_hack/utils/extensions.dart';
import 'package:puzzle_hack/ui/home.dart';
import 'package:puzzle_hack/utils/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return McMV(
        global.themeMode,
        () => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              themeMode: global.themeMode.v,
              darkTheme: darkTheme,
              theme: lightTheme,
              home: Home(),
            ));
  }
}
