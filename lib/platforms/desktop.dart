
import 'package:flutter/material.dart';
import 'package:puzzle_hack/ui/widgets/history.dart';
import 'package:puzzle_hack/ui/widgets/moves.dart';
import 'package:puzzle_hack/ui/widgets/puzzle_game.dart';
import 'package:puzzle_hack/ui/widgets/tile_theme.dart';

class Desktop extends StatelessWidget {
  const Desktop({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: History()),
        const PuzzleGame(),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Puzzle Challenge",
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const Moves(),
              const SizedBox(
                height: 15.0,
              ),
              const TileTheme(),
              Expanded(
                  flex: 1, child: Image.asset("assets/images/dash.png")),
            ],
          ),
        ),
      ],
    );
  }
}

