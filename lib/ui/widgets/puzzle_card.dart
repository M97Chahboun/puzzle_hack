import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import 'package:puzzle_hack/utils/controller.dart';
import 'package:puzzle_hack/utils/empty.dart';
import 'package:puzzle_hack/utils/shake_curve.dart';
import 'package:puzzle_hack/utils/singleton.dart';
import 'package:puzzle_hack/extensions.dart';

// ignore: must_be_immutable
class PuzzleCard extends StatefulWidget {
  double x;
  double y;
  final int value;
  PuzzleCard(
    this.x,
    this.y,
    this.value, {
    Key? key,
  }) : super(key: key);

  @override
  State<PuzzleCard> createState() => _PuzzleCardState();
}

class _PuzzleCardState extends State<PuzzleCard> {
  Curve currentCurve = Curves.bounceInOut;
  final List<int> correct = List.generate(16, (index) => index + 1);
  void addController() {
    global.controller[widget.value] =
        (CardControlller(toRight, toLeft, toUp, toDown));
  }

  @override
  void initState() {
    global.controller[widget.value] =
        (CardControlller(toRight, toLeft, toUp, toDown));
    global.restart.registerListener(miniRebuild, addController);
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   global.controller[widget.value] =
  //       (CardControlller(toRight, toLeft, toUp, toDown));
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      alignment: Alignment(widget.x, widget.y),
      duration: const Duration(milliseconds: 200),
      curve: currentCurve,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (!global.replay.v) {
              if (!global.timer.timer.isActive &&
                  !correct.isSameOrder(global.currentOrder)) {
                global.timer.startTimer();
              }
              if (global.timer.timer.isActive) {
                horizontalSwipe(details, context);
              }
            }
          },
          onVerticalDragEnd: (details) {
            if (!global.replay.v) {
              if (!global.timer.timer.isActive &&
                  !correct.isSameOrder(global.currentOrder)) {
                global.timer.startTimer();
              }
              if (global.timer.timer.isActive) {
                verticalSwipe(details, context);
              }
            }
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(
                maxWidth: 90.0,
                maxHeight: 90.0,
                minHeight: 52.0,
                minWidth: 52.0),
            child: Container(
              height: context.width * 0.16,
              width: context.width * 0.16,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(9.0))),
              alignment: Alignment.center,
              child: Text(
                widget.value.toString(),
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void verticalSwipe(DragEndDetails details, BuildContext context) {
    if (details.velocity.pixelsPerSecond.dx >
        details.velocity.pixelsPerSecond.dy) {
      if (Empty(y: widget.y - global.addY, x: widget.x) == global.empty) {
        toUp();
      } else {
        shakeY();
      }
    } else if (details.velocity.pixelsPerSecond.dx <
        details.velocity.pixelsPerSecond.dy) {
      if (Empty(y: widget.y + global.addY, x: widget.x) == global.empty) {
        toDown();
      } else {
        shakeY();
      }
    }
  }

  void horizontalSwipe(DragEndDetails details, BuildContext context) {
    if (details.velocity.pixelsPerSecond.dx >
        details.velocity.pixelsPerSecond.dy) {
      if (Empty(y: widget.y, x: widget.x + global.addX) == global.empty) {
        toRight();
      } else {
        shakeX();
      }
    } else if (details.velocity.pixelsPerSecond.dx <
        details.velocity.pixelsPerSecond.dy) {
      if (Empty(y: widget.y, x: widget.x + -global.addX) == global.empty) {
        toLeft();
      } else {
        shakeX();
      }
    }
  }

  void toDown() {
    widget.y += global.addY;
    if (mounted) setState(() {});
    setLog("down");
    changeOrder();
    global.empty = global.empty.copyWith(
      y: widget.y - global.addY,
    );
    global.moves.v++;
  }

  void toUp() {
    widget.y -= global.addY;
    if (mounted) setState(() {});
    setLog("up");
    changeOrder();
    global.empty = global.empty.copyWith(
      y: widget.y + global.addY,
    );
    global.moves.v++;
  }

  void toLeft() {
    widget.x += -global.addX;
    if (mounted) setState(() {});
    setLog("left");
    changeOrder();
    global.empty = global.empty.copyWith(x: widget.x + global.addX);
    global.moves.v++;
  }

  void toRight() {
    widget.x += global.addX;
    if (mounted) setState(() {});
    setLog("right");
    changeOrder();
    global.empty = global.empty.copyWith(
      x: widget.x - global.addX,
    );
    global.moves.v++;
  }

  void shakeX() {
    widget.x += 0.01;
    currentCurve = const ShakeCurve();
    if (mounted) setState(() {});
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      widget.x -= 0.01;
      if (mounted) setState(() {});
      currentCurve = Curves.bounceInOut;
      timer.cancel();
    });
  }

  void shakeY() {
    widget.y += 0.01;
    currentCurve = const ShakeCurve();
    if (mounted) setState(() {});
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      widget.y -= 0.01;
      if (mounted) setState(() {});
      currentCurve = Curves.bounceInOut;
      timer.cancel();
    });
  }

  void setLog(String to) {
    String millsec = global.timer.millseconds.two.toString();
    String sec = global.timer.seconds.two.toString();
    String min = global.timer.minutes.two.toString();
    global.log.v.add("${widget.value}:$to:$millsec|$sec|$min");
    global.log.rebuildWidget();
  }

  void changeOrder() {
    int indexValue = global.currentOrder.indexOf(widget.value);
    int indexEmpty = global.currentOrder.indexOf(Singleton().empty.value);
    global.currentOrder
      ..remove(Singleton().empty.value)
      ..insert(indexValue, global.empty.value);
    global.currentOrder
      ..remove(widget.value)
      ..insert(indexEmpty, widget.value);
    if (Singleton().currentOrder.isSameOrder(correct) &&
        global.timer.timer.isActive) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          global.timer.pause();
          return AlertDialog(
            content: Text("Good job"),
          );
        },
      );
    }
  }
}