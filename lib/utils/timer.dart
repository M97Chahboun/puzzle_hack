import 'dart:async';

import 'package:mc/mc.dart';

class PuzzleTimer extends McValue {
  int seconds = 0;
  int minutes = 0;
  int hours = 0;
  Timer timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {})..cancel();

  PuzzleTimer(value) : super(value);
  void startTimer() {
    const oneSec = Duration(seconds: 1);

    timer = Timer.periodic(oneSec, (Timer timer) {
      if (seconds < 0) {
        timer.cancel();
      } else {
        seconds = seconds + 1;
        if (seconds > 59) {
          minutes += 1;
          seconds = 0;
          if (minutes > 59) {
            hours += 1;
            minutes = 0;
          }
        }
      }
      rebuildWidget();
    });
  }

  void reset() {
    //  timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {});
    hours = 0;
    minutes = 0;
    seconds = 0;
    rebuildWidget();
  }

  int get total => seconds + minutes + hours;

  void pause() {
    timer.cancel();
  }
}
