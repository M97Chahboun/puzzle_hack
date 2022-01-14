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
            if (details.velocity.pixelsPerSecond.dx >
                details.velocity.pixelsPerSecond.dy) {
              if (Empty(y: widget.y, x: widget.x + context.s.addX) ==
                  context.s.empty) {
                widget.x += context.s.addX;
                setState(() {});
                setLog("right");
                changeOrder();
                context.s.empty = context.s.empty.copyWith(
                  x: widget.x - context.s.addX,
                );
              } else {
                shakeX();
              }
            } else if (details.velocity.pixelsPerSecond.dx <
                details.velocity.pixelsPerSecond.dy) {
              if (Empty(y: widget.y, x: widget.x + -context.s.addX) ==
                  context.s.empty) {
                widget.x += -context.s.addX;
                setState(() {});
                setLog("left");
                changeOrder();
                context.s.empty =
                    context.s.empty.copyWith(x: widget.x + context.s.addX);
              } else {
                shakeX();
              }
            }
          },
          onVerticalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dx >
                details.velocity.pixelsPerSecond.dy) {
              if (Empty(y: widget.y - context.s.addY, x: widget.x) ==
                  context.s.empty) {
                widget.y -= context.s.addY;
                setState(() {});
                setLog("up");
                changeOrder();
                context.s.empty = context.s.empty.copyWith(
                  y: widget.y + context.s.addY,
                );
              } else {
                shakeY();
              }
            } else if (details.velocity.pixelsPerSecond.dx <
                details.velocity.pixelsPerSecond.dy) {
              if (Empty(y: widget.y + context.s.addY, x: widget.x) ==
                  context.s.empty) {
                widget.y += context.s.addY;
                setState(() {});
                setLog("down");
                changeOrder();
                context.s.empty = context.s.empty.copyWith(
                  y: widget.y - context.s.addY,
                );
              } else {
                shakeY();
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
              alignment: Alignment.center,
              color: Colors.blue,
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
    context.s.log.v.add("Move ${widget.value} to $to");
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
    List correct = List.generate(16, (index) => index + 1);
    if (Singleton().currentOrder.isSameOrder(correct)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog();
        },
      );
    }
  }
}
