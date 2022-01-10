import 'empty.dart';

class Singleton {
  static final Singleton _singleton = Singleton._internal();

Empty empty = Empty();
List correctOrder = List.generate(16, (index) => index + 1);
List<int> currentOrder = [];
  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
}