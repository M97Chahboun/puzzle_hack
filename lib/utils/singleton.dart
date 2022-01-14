import 'package:puzzle_hack/utils/timer.dart';

import 'empty.dart';
import 'package:mc/mc.dart';

class Singleton {
  static final Singleton _singleton = Singleton._internal();

  Empty empty = Empty();
  List<int> correctOrder = List.generate(16, (index) => index + 1);
  List<int> currentOrder = [];
  List<int> initShuffle = [];
  final McValue<bool> restart = false.mini;
  final PuzzleTimer timer = PuzzleTimer(0);
  final double addX = 0.5;
  final double addY = 0.5;
  McValue<List<String>> log = McValue([]);
  McValue<int> moves = 0.mini;
  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
}
