import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import 'package:puzzle_hack/ui/widgets/puzzle_card.dart';
import 'package:puzzle_hack/extensions.dart';
import 'package:puzzle_hack/utils/empty.dart';

class PuzzleGame extends StatefulWidget {
  const PuzzleGame({
    Key? key,
  }) : super(key: key);

  @override
  State<PuzzleGame> createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  final double col = 4;
  @override
  void initState() {
    if (global.currentOrder.isNotEmpty) {
      global.correctOrder = List.from(global.currentOrder);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return McMV(
      global.restart,
      () {
        global.currentOrder.clear();
        const double initX = -1.25;
        double initY = -0.75;
        double x = initX;
        double y = initY;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      McMV(
                          global.moves,
                          () => Text(global.moves.v.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(fontWeight: FontWeight.bold))),
                      Text(" Moves |",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontWeight: FontWeight.bold)),
                      McMV(global.timer, () {
                        String millsec =
                            global.timer.millseconds.two.toString();
                        String sec = global.timer.seconds.two.toString();
                        String min = global.timer.minutes.two.toString();
                        return Row(
                          children: [
                            const Icon(
                              Icons.timer,
                              size: 40.0,
                            ),
                            Text(
                              "$millsec:$sec:$min",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 511, maxWidth: 511),
                  child: Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).primaryColor)),
                    height: context.width,
                    width: context.width,
                    child: Stack(
                        children: global.correctOrder.map((index) {
                      global.currentOrder.add(index);
                      if (x == (global.addX * col) + initX) {
                        x = initX;
                        y += global.addY;
                      }
                      x += global.addY;
                      if (index != 16) {
                        return PuzzleCard(x, y, index);
                      } else {
                        global.empty = Empty(
                          x: x,
                          y: y,
                        );
                        return const SizedBox();
                      }
                    }).toList()),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}