import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import 'package:puzzle_hack/extensions.dart';
import 'package:puzzle_hack/ui/widgets/puzzle_card.dart';

class History extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  int index = 0;
  final bool showReplayButton;
  double? max;
  final bool showLast;
  final McValue<bool> replay = false.mini;

  History(
      {Key? key, this.showReplayButton = true, this.showLast = true, this.max})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    max ??= context.height;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: max!),
      child: Container(
        height: context.height,
        width: context.width,
        color: Theme.of(context).backgroundColor,
        child: Stack(
          children: [
            McMV(
                global.log,
                () => ListView.builder(
                      controller: _scrollController,
                      dragStartBehavior: DragStartBehavior.down,
                      itemCount: global.log.v.length,
                      reverse: true,
                      itemBuilder: (BuildContext context, int index) {
                        List log = global.log.v[index].split(":");
                        String value = log[0];
                        String icon = log[1];
                        String time = log[2];
                        time = time.replaceAll("|", ":");
                        global.log.registerListener(miniRebuild, () {
                          if (showLast) {
                            _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent + 100,
                            );
                          }
                        });

                        return TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.bounceOut,
                          builder: (BuildContext context, double? _value,
                              Widget? child) {
                            return Transform.translate(
                              offset: showLast
                                  ? Offset(0.0, _value! * 20)
                                  : Offset(_value! * 20, 0.0),
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                          radius: 10.0,
                                          child: Text(
                                            (index + 1).toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5!
                                                .copyWith(fontSize: 10.0),
                                          )),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      const Text("Move "),
                                      Container(
                                        height: 20.0,
                                        width: 20.0,
                                        color: Theme.of(context).primaryColor,
                                        child: Center(child: Text(value)),
                                      ),
                                      const Text(" to "),
                                      Icon(
                                        getIcon(icon),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const Text(" in "),
                                      Text(time)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          tween: Tween<double>(begin: 1.0, end: 0.0),
                        );
                      },
                    )),
            if (showReplayButton)
              Align(
                alignment: const Alignment(0, 0.9),
                child: McMV(replay, () {
                  return FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      index = 0;
                      if (replay.v) {
                        replay.v = false;
                      } else {
                        replayGame(context);
                        replay.v = true;
                      }
                    },
                    child: Icon(
                      replay.v ? Icons.pause : Icons.play_arrow,
                    ),
                  );
                }),
              )
          ],
        ),
      ),
    );
  }

  void replayGame(BuildContext context) {
    List<String> olderLog = global.log.v;
    global.log.v = [];
    global.timer.reset();
    global.moves.v = 0;
    global.currentOrder = List.from(global.initShuffle);
    global.restart.rebuildWidget();
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      String e = olderLog[index];
      String value = e.split(":")[0];
      String to = e.split(":")[1];
      int cardIndex = global.initShuffle.indexOf(value.i);
      List<String> time = e.split(":")[2].split("|");

      int millsec = time[0].i;
      int sec = time[1].i;
      int min = time[2].i;
      if (olderLog.first == e) move(to, cardIndex);

      if (millsec + sec + min == global.timer.total &&
          !(olderLog.first == e)) {
        move(to, cardIndex);
      }
      if (index == olderLog.length) {
        timer.cancel();
        global.timer.pause();
        replay.v = false;
      }
    });
  }

  void move(String to, int cardIndex) {
    switch (to) {
      case "right":
        controlle[cardIndex].right();
        break;
      case "left":
        controlle[cardIndex].left();
        break;
      case "up":
        controlle[cardIndex].up();
        break;
      case "down":
        controlle[cardIndex].down();
        break;
    }
    index++;
    //print(index);
  }

  IconData? getIcon(String icon) {
    switch (icon) {
      case "right":
        return Icons.arrow_forward;
      case "left":
        return Icons.arrow_back;
      case "up":
        return Icons.arrow_upward;
      case "down":
        return Icons.arrow_downward;
    }
  }
}
