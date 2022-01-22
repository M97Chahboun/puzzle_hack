import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import 'package:puzzle_hack/ui/widgets/puzzle_card.dart';
import 'package:puzzle_hack/extensions.dart';
import 'package:puzzle_hack/ui/widgets/theme_icon.dart';
import 'package:puzzle_hack/ui/widgets/tile_image.dart';
import 'package:puzzle_hack/ui/widgets/tile_theme.dart';
import 'package:puzzle_hack/ui/widgets/timer_widget.dart';
import 'package:puzzle_hack/utils/empty.dart';
import 'package:puzzle_hack/utils/responsive.dart';

import 'moves.dart';

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
                const TimerWidget(),
                if (context.isTablet || context.isMobile) ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Moves(),
                      TileTheme(),
                    ],
                  ),
                ],
                const SizedBox(height: 10.0),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 511, maxWidth: 511),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(18.0)),
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
