import 'package:flutter/material.dart';
import 'package:puzzle_hack/ui/widgets/history.dart';
import 'package:puzzle_hack/ui/widgets/puzzle_game.dart';
import 'package:puzzle_hack/utils/extensions.dart';

class Mobile extends StatelessWidget {
  const Mobile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: context.width,
        height: context.height,
        child: context.height >= 770
            ? Wrap(
                runAlignment: WrapAlignment.spaceBetween,
                alignment: WrapAlignment.center,
                children: [
                  const PuzzleGame(),
                  Column(
                    children: [
                      History(
                        max: 120,
                      ),
                      Container(
                        height: 20,
                        width: context.width,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              Theme.of(context).backgroundColor,
                              Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5)
                            ])),
                      ),
                    ],
                  ),
                ],
              )
            : const PuzzleGame());
  }
}
