import 'package:flutter/material.dart';
import 'package:puzzle_hack/ui/widgets/history.dart';
import 'package:puzzle_hack/ui/widgets/puzzle_game.dart';

class Tablet extends StatelessWidget {
  const Tablet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: History()),
        const PuzzleGame(),
      ],
    );
  }
}

