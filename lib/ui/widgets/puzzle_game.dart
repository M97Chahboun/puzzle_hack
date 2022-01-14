import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import 'package:puzzle_hack/ui/widgets/puzzle_card.dart';
import 'package:puzzle_hack/extensions.dart';
import 'package:puzzle_hack/utils/empty.dart';

class PuzzleGame extends StatelessWidget {
  const PuzzleGame({
    Key? key,
  }) : super(key: key);

  final double col = 4;

  @override
  Widget build(BuildContext context) {
    return McMV(
      context.s.restart,
      () {
        const double initX = -1.25;
        double initY = -1.0;
        double x = initX;
        double y = initY;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    McMV(
                        context.s.moves,
                        () => Text(context.s.moves.v.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(fontWeight: FontWeight.bold))),
                    Text(" Moves |",
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(fontWeight: FontWeight.bold)),
                    McMV(context.s.timer, () {
                      String sec = context.s.timer.seconds.two.toString();
                      String min = context.s.timer.minutes.two.toString();
                      String hr = context.s.timer.hours.two.toString();
                      return Row(
                        children: [
                          const Icon(
                            Icons.timer,
                            size: 40.0,
                          ),
                          Text(
                            "$sec:$min:$hr",
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
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 511, maxWidth: 511),
                  child: SizedBox(
                    height: context.width,
                    width: context.width,
                    child: Stack(
                        children: context.s.correctOrder.map((index) {
                      context.s.currentOrder.add(index);
                      if (x == (context.s.addX * col) + initX) {
                        x = initX;
                        y += context.s.addY;
                      }
                      x += context.s.addY;
                      if (index != context.s.correctOrder.last) {
                        return PuzzleCard(x, y, index);
                      } else {
                        context.s.empty = Empty(
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
