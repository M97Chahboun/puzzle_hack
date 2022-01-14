import 'package:flutter/material.dart';

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
    final Size _size = MediaQuery.of(context).size;
    if (_size.width >= 850) {
      return another;
    } else {
      return mobile;
    }
  }
}
