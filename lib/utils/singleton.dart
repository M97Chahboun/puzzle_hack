import 'empty.dart';

class Singleton {
  static final Singleton _singleton = Singleton._internal();

  Empty empty = Empty();
  List correctOrder = List.generate(16, (index) => index + 1);
  List<int> currentOrder = [];
  final double addX = 0.5;
  final double addY = 0.5;
  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
}
