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
  final bool showLast;
  final McValue<bool> replay = false.mini;

  History({Key? key, this.showReplayButton = true, this.showLast = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {  
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Stack(
        children: [
          McMV(
              context.s.log,
              () => ListView.builder(
                    controller: _scrollController,
                    dragStartBehavior: DragStartBehavior.down,
                    itemCount: context.s.log.v.length,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      List log = context.s.log.v[index].split(":");
                      String value = log[0];
                      String icon = log[1];
                      String time = log[2];
                      context.s.log.registerListener(miniRebuild, () {
                        if (showLast) {
                          _scrollController.jumpTo(
                            _scrollController.position.maxScrollExtent + 50,
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
                                      color: Colors.black54,
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
          Align(
            alignment: const Alignment(0, 0.9),
            child: McMV(replay, () {
              return FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () {
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
    );
  }

  void replayGame(BuildContext context) {
    List<String> olderLog = List.from(context.s.log.v);
    context.s.log.v.clear();
    context.s.timer.reset();
    context.s.moves.v = 0;
    context.s.currentOrder = context.s.initShuffle;
    context.s.restart.rebuildWidget();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      String e = olderLog[index];
      String value = e.split(":")[0];
      String to = e.split(":")[1];

      List<String> time = e.split(":")[2].split("|");

      int sec = time[0].i;
      int min = time[1].i;
      int hr = time[2].i;

      if (sec + min + hr == context.s.timer.total) move(to, value);
      if (index + 1 == olderLog.length) {
        timer.cancel();
        context.s.timer.pause();
        replay.v = false;
      }
      ;
    });
  }

  void move(String to, String value) {
    switch (to) {
      case "right":
        controlle[int.parse(value) - 1].right();
        break;
      case "left":
        controlle[int.parse(value) - 1].left();
        break;
      case "up":
        controlle[int.parse(value) - 1].up();
        break;
      case "down":
        controlle[int.parse(value) - 1].down();
        break;
    }
    index++;
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
