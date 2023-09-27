import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import 'package:puzzle_hack/firebase_options.dart';
import 'package:puzzle_hack/ui/home.dart';
import 'package:puzzle_hack/utils/extensions.dart';
import 'package:puzzle_hack/utils/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
              title: 'Share Puzzle',
              themeMode: global.themeMode.v,
              darkTheme: darkTheme,
              theme: lightTheme,
              home: Home(),
            ));
  }
}
