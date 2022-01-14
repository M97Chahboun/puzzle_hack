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
            if (!context.s.timer.timer.isActive &&
                !correct.isSameOrder(context.s.currentOrder)) {
              context.s.timer.startTimer();
            }
            if (context.s.timer.timer.isActive) {
              horizontalSwipe(details, context);
            }
          },
          onVerticalDragEnd: (details) {
            if (!context.s.timer.timer.isActive &&
                !correct.isSameOrder(context.s.currentOrder)) {
              context.s.timer.startTimer();
            }
            if (context.s.timer.timer.isActive) {
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
              alignment: Alignment.center,
              color: Theme.of(context).primaryColor,
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
      if (Empty(y: widget.y - context.s.addY, x: widget.x) == context.s.empty) {
        toUp();
      } else {
        shakeY();
      }
    } else if (details.velocity.pixelsPerSecond.dx <
        details.velocity.pixelsPerSecond.dy) {
      if (Empty(y: widget.y + context.s.addY, x: widget.x) == context.s.empty) {
        toDown();
      } else {
        shakeY();
      }
    }
  }

  void horizontalSwipe(DragEndDetails details, BuildContext context) {
    if (details.velocity.pixelsPerSecond.dx >
        details.velocity.pixelsPerSecond.dy) {
      if (Empty(y: widget.y, x: widget.x + context.s.addX) == context.s.empty) {
        toRight();
      } else {
        shakeX();
      }
    } else if (details.velocity.pixelsPerSecond.dx <
        details.velocity.pixelsPerSecond.dy) {
      if (Empty(y: widget.y, x: widget.x + -context.s.addX) ==
          context.s.empty) {
        toLeft();
      } else {
        shakeX();
      }
    }
  }

  void toDown() {
    widget.y += context.s.addY;
    setState(() {});
    setLog("down");
    changeOrder();
    context.s.empty = context.s.empty.copyWith(
      y: widget.y - context.s.addY,
    );
    context.s.moves.v++;
  }

  void toUp() {
    widget.y -= context.s.addY;
    setState(() {});
    setLog("up");
    changeOrder();
    context.s.empty = context.s.empty.copyWith(
      y: widget.y + context.s.addY,
    );
    context.s.moves.v++;
  }

  void toLeft() {
    widget.x += -context.s.addX;
    setState(() {});
    setLog("left");
    changeOrder();
    context.s.empty = context.s.empty.copyWith(x: widget.x + context.s.addX);
    context.s.moves.v++;
  }

  void toRight() {
    widget.x += context.s.addX;
    setState(() {});
    setLog("right");
    changeOrder();
    context.s.empty = context.s.empty.copyWith(
      x: widget.x - context.s.addX,
    );
    context.s.moves.v++;
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
    String sec = context.s.timer.seconds.two.toString();
    String min = context.s.timer.minutes.two.toString();
    String hr = context.s.timer.hours.two.toString();
    context.s.log.v.add("${widget.value}:$to:$sec|$min|$hr");
    context.s.log.rebuildWidget();
  }

  void changeOrder() {
    int indexValue = context.s.currentOrder.indexOf(widget.value);
    int indexEmpty = context.s.currentOrder.indexOf(Singleton().empty.value);
    context.s.currentOrder
      ..remove(Singleton().empty.value)
      ..insert(indexValue, context.s.empty.value);
    context.s.currentOrder
      ..remove(widget.value)
      ..insert(indexEmpty, widget.value);
    if (Singleton().currentOrder.isSameOrder(correct) &&
        context.s.timer.timer.isActive) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          context.s.timer.pause();
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
