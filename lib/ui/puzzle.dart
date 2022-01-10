import 'dart:math';

import 'package:flutter/material.dart';
import 'package:puzzle_hack/extensions.dart';

Empty empty = Empty();

class Puzzle extends StatelessWidget {
  double x = -1.25;
  double y = -1;
  List values = List.generate(16, (index) => index + 1)..shuffle(Random());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: const  BoxConstraints(maxWidth: 500.0),
        child: Center(
          child: SizedBox(
            height: context.height * 0.8,
            width: context.width,
            child: Stack(
                children: values.map((index) {
              if (x == 0.75) {
                x = -1.25;
                y += 0.3;
              }
              x += 0.5;
              if (index != values.last) {
                return Card(x, y, index.toString());
              } else {
                empty = Empty(x: x, y: y);
                return const SizedBox();
              }
            }).toList()),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Card extends StatefulWidget {
  double x;
  double y;
  final String value;
  Card(
    this.x,
    this.y,
    this.value, {
    Key? key,
  }) : super(key: key);

  @override
  State<Card> createState() => _CardState();
}

Curve currentCurve = Curves.bounceInOut;

class _CardState extends State<Card> {
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
              if (Empty(y: widget.y, x: widget.x + 0.5) == empty) {
                widget.x += 0.5;
                setState(() {});
                empty = empty.copyWith(x: widget.x - 0.5);
              } else {
                widget.x += 0.05;
                currentCurve = SineCurve();
                setState(() {});
              }
            } else if (details.velocity.pixelsPerSecond.dx <
                details.velocity.pixelsPerSecond.dy) {
              if (Empty(y: widget.y, x: widget.x + -0.5) == empty) {
                widget.x += -0.5;
                setState(() {});
                empty = empty.copyWith(x: widget.x + 0.5);
              }
            }
          },
          onVerticalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dx >
                details.velocity.pixelsPerSecond.dy) {
              if (Empty(y: widget.y + -0.3, x: widget.x) == empty) {
                widget.y += -0.3;
                setState(() {});
                empty = empty.copyWith(y: widget.y + 0.3);
              }
            } else if (details.velocity.pixelsPerSecond.dx <
                details.velocity.pixelsPerSecond.dy) {
              if (Empty(y: widget.y + 0.3, x: widget.x) == empty) {
                widget.y += 0.3;
                setState(() {});
                empty = empty.copyWith(y: widget.y - 0.3);
              }
            }
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 90.0, maxHeight: 90.0),
            child: Container(
              height: context.width * 0.18,
              width: context.width * 0.18,
              color:
                  widget.x == 1 && widget.y == -1 ? Colors.brown : Colors.blue,
              child: Text(
                widget.value,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Empty {
  final double? x;
  final double? y;

  Empty({this.x, this.y});
  Empty copyWith({double? x, double? y}) {
    return Empty(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  @override
  String toString() {
    return "x:$x,y:$y";
  }

  @override
  bool operator ==(Object other) =>
      other is Empty &&
      other.runtimeType == runtimeType &&
      other.x == x &&
      other.y == y;

  @override
  int get hashCode => (x! + y!).hashCode;
}

// 1. custom Curve subclass
class SineCurve extends Curve {
  SineCurve({this.count = 3});
  final double count;

  // 2. override transformInternal() method
  @override
  double transformInternal(double t) {
    return sin(count * 2 * pi * t);
  }
}
