import 'package:puzzle_hack/utils/singleton.dart';

class GetCorrectTiles {
  static void getCorrectTiles([bool start = false]) {
    List correct = List.generate(16, (index) => index+1);
    List current = start ? Singleton().initShuffle : Singleton().currentOrder;
    int result = 0;    
    for (var i = 0; i < 16; i++) {
      if (current[i] == correct[i]) {        
        result++;
      }
    }
    Singleton().tiles.v = result;
  }
}
