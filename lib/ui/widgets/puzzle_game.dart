import 'package:flutter/material.dart';
import 'package:puzzle_hack/ui/widgets/card.dart';
import 'package:puzzle_hack/extensions.dart';
import 'package:puzzle_hack/utils/empty.dart';
import 'package:puzzle_hack/utils/responsive.dart';

class PuzzleGame extends StatelessWidget {
  const PuzzleGame({
    Key? key,
    required this.start,
  }) : super(key: key);

  final double col = 4;
  final ValueNotifier start;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, _, __) {
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
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 511, maxWidth: 511),
                  child: Container(
                    color: Colors.black,
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
                        print("$index = $x");
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
      valueListenable: start,
    );
  }
}
