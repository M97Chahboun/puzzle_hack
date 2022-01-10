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

Curve currentCurve = Curves.bounceInOut;

class _PuzzleCardState extends State<PuzzleCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: widget.y.isNegative ? null : widget.y,
      right: !widget.x.isNegative ? null : widget.x,
      bottom: !widget.y.isNegative ? null : widget.y,
      left: widget.x.isNegative ? null : widget.x - 50,
      duration: const Duration(milliseconds: 200),
      curve: currentCurve,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dx >
                details.velocity.pixelsPerSecond.dy) {
              if (Empty(y: widget.y, x: widget.x + 100) ==context.s.empty) {
                widget.x += 100;
                setState(() {});
                changeOrder();
               context.s.empty =context.s.empty.copyWith(
                  x: widget.x - 100,
                );
              } else {
                shakeX();
              }
            } else if (details.velocity.pixelsPerSecond.dx <
                details.velocity.pixelsPerSecond.dy) {
              if (Empty(y: widget.y, x: widget.x + -100) ==context.s.empty) {
                widget.x += -100;
                setState(() {});
                changeOrder();
               context.s.empty =context.s.empty.copyWith(x: widget.x + 100);
              } else {
                shakeX();
              }
            }
          },
          onVerticalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dx >
                details.velocity.pixelsPerSecond.dy) {
              if (Empty(y: widget.y + -100, x: widget.x) ==context.s.empty) {
                widget.y += -100;
                setState(() {});
                changeOrder();
               context.s.empty =context.s.empty.copyWith(
                  y: widget.y + 100,
                );
              } else {
                shakeY();
              }
            } else if (details.velocity.pixelsPerSecond.dx <
                details.velocity.pixelsPerSecond.dy) {
              if (Empty(y: widget.y + 100, x: widget.x) ==context.s.empty) {
                widget.y += 100;
                setState(() {});
                changeOrder();
               context.s.empty =context.s.empty.copyWith(
                  y: widget.y - 100,
                );
              } else {
                shakeY();
              }
            }
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 90.0, maxHeight: 90.0),
            child: Container(
              height: context.width * 0.18,
              width: context.width * 0.18,
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
    widget.x += 5;
    currentCurve = const ShakeCurve();
    setState(() {});
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      widget.x -= 5;
      setState(() {});
      currentCurve = Curves.bounceInOut;
      timer.cancel();
    });
  }

  void shakeY() {
    widget.y += 5;
    currentCurve = const ShakeCurve();
    setState(() {});
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      widget.y -= 5;
      setState(() {});
      currentCurve = Curves.bounceInOut;
      timer.cancel();
    });
  }

  void changeOrder() {
    int indexValue =context.s.currentOrder.indexOf(widget.value);
    int indexEmpty =context.s.currentOrder.indexOf(Singleton().empty.value);
   context.s.currentOrder
      ..remove(Singleton().empty.value)
      ..insert(indexValue,context.s.empty.value);
   context.s.currentOrder
      ..remove(widget.value)
      ..insert(indexEmpty, widget.value);
    List correct = List.generate(16, (index) => index + 1);
    if (Singleton().currentOrder.isSameOrder(correct)) {
      print("congrlmfzf");
    }
  }
}