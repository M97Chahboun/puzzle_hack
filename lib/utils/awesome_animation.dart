import 'package:flutter/material.dart';

class AwesomeScale extends StatelessWidget {
  const AwesomeScale({Key? key, required this.child, this.millseconds = 1000})
      : super(key: key);
  final Widget child;
  final int millseconds;
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      child: child,
      curve: Curves.elasticOut,
      duration: Duration(milliseconds: millseconds),
      builder: (BuildContext context, double value, Widget? child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
    );
  }
}