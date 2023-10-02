import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import 'package:shared_puzzle/utils/controller.dart';
import 'package:shared_puzzle/utils/timer.dart';

import 'empty.dart';

class Singleton {
  static final Singleton _singleton = Singleton._internal();

  Empty empty = Empty();
  List<int> correctOrder = List.generate(16, (index) => index + 1);
  List<int> currentOrder = [];
  List<int> initShuffle = [];
  String currentTile = "number";
  final McValue<bool> restart = false.mini;
  final McValue<bool> replay = false.mini;
  final McValue<bool> upload = false.mini;
  final McValue<bool> takeFocus = true.mini;
  final PuzzleTimer timer = PuzzleTimer(0);
  final double addX = 0.5;
  final double addY = 0.5;
  McValue<List<String>> log = McValue([]);
  McValue<int> moves = 0.mini;
  McValue<int> tiles = 15.mini;
  List<CardControlller> controller =
      List.generate(16, (index) => CardControlller(() {}, () {}, () {}, () {}));
  McValue<ThemeMode> themeMode = ThemeMode.system.mini;
  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
}
