import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import 'package:puzzle_hack/extensions.dart';
import 'package:puzzle_hack/ui/home.dart';

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
              darkTheme: ThemeData(
                brightness: Brightness.dark,
                canvasColor: const Color(0xFF121212),
                backgroundColor: const Color(0xFF121212),
                cardColor: const Color(0xFF1E1E1E),
              ),
              home: Home(),
            ));
  }
}
