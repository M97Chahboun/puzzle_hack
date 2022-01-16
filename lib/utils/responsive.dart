import 'package:flutter/material.dart';
import 'package:puzzle_hack/extensions.dart';
class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget another;

  const Responsive({
    Key? key,
    required this.mobile,
    required this.another,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = context.width;
    if (width >= 850) {
      return another;
    } else {
      return mobile;
    }
  }
}
