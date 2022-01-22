import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import 'package:puzzle_hack/extensions.dart';

class Moves extends StatelessWidget {
  const Moves({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return McMV(global.moves, () {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(global.moves.v.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.bold)),
          Text(" Moves |",
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.bold)),
          Text(global.tiles.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.bold)),
          Text(" Tiles",
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.bold)),
        ],
      );
    });
  }
}
