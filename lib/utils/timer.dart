import 'dart:async';

import 'package:mc/mc.dart';

class PuzzleTimer extends McValue {
  int millseconds = 0;
  int seconds = 0;
  int minutes = 0;
  Timer timer =
      Timer.periodic(const Duration(milliseconds: 10), (Timer timer) {})
        ..cancel();

  PuzzleTimer(value) : super(value);
  void startTimer() {
    const oneSec = Duration(milliseconds: 10);
    timer = Timer.periodic(oneSec, (Timer timer) {
      if (millseconds < 0) {
        timer.cancel();
      } else {
        millseconds = millseconds + 1;
        if (millseconds > 100) {
          seconds += 1;
          millseconds = 0;
          if (seconds > 59) {
            minutes += 1;
            seconds = 0;
          }
        }
      }
      rebuildWidget();
    });
  }

  void reset() {
    //  timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {});
    minutes = 0;
    seconds = 0;
    millseconds = 0;
    rebuildWidget();
  }

  int get total => millseconds + seconds + minutes;

  void pause() {
    timer.cancel();
  }
}
