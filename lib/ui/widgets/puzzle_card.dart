import 'dart:async';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    controlle.add(CardControl(toRight, toLeft, toUp, toDown));
    super.initState();
  }

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
            if (!global.timer.timer.isActive &&
                !correct.isSameOrder(global.currentOrder)) {
              global.timer.startTimer();
            }
            if (global.timer.timer.isActive) {
              horizontalSwipe(details, context);
            }
          },
          onVerticalDragEnd: (details) {
            if (!global.timer.timer.isActive &&
                !correct.isSameOrder(global.currentOrder)) {
              global.timer.startTimer();
            }
            if (global.timer.timer.isActive) {
              verticalSwipe(details, context);
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
                  borderRadius: BorderRadius.all(Radius.circular(9.0))),
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
    setState(() {});
    setLog("down");
    changeOrder();
    global.empty = global.empty.copyWith(
      y: widget.y - global.addY,
    );
    global.moves.v++;
  }

  void toUp() {
    widget.y -= global.addY;
    setState(() {});
    setLog("up");
    changeOrder();
    global.empty = global.empty.copyWith(
      y: widget.y + global.addY,
    );
    global.moves.v++;
  }

  void toLeft() {
    widget.x += -global.addX;
    setState(() {});
    setLog("left");
    changeOrder();
    global.empty = global.empty.copyWith(x: widget.x + global.addX);
    global.moves.v++;
  }

  void toRight() {
    widget.x += global.addX;
    setState(() {});
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
    setState(() {});
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      widget.x -= 0.01;
      setState(() {});
      currentCurve = Curves.bounceInOut;
      timer.cancel();
    });
  }

  void shakeY() {
    widget.y += 0.01;
    currentCurve = const ShakeCurve();
    setState(() {});
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      widget.y -= 0.01;
      setState(() {});
      currentCurve = Curves.bounceInOut;
      timer.cancel();
    });
  }

  void setLog(String to) {
    String sec = global.timer.millseconds.two.toString();
    String min = global.timer.seconds.two.toString();
    String hr = global.timer.minutes.two.toString();
    global.log.v.add("${widget.value}:$to:$sec|$min|$hr");
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

class CardControl {
  final Function right;
  final Function left;
  final Function up;
  final Function down;

  CardControl(this.right, this.left, this.up, this.down);
}

List<CardControl> controlle = [];
