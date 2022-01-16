import 'package:flutter/material.dart';
import 'package:puzzle_hack/extensions.dart';
import 'package:puzzle_hack/ui/widgets/history.dart';
import 'package:puzzle_hack/ui/widgets/puzzle_game.dart';
import 'package:puzzle_hack/ui/widgets/theme_icon.dart';
import 'package:puzzle_hack/utils/responsive.dart';

class Home extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () => shuffle(context),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.shuffle),
      ),
      appBar: context.isMobile
          ? AppBar(
              actions: const [
                ThemeIcon(),
              ],
              leading: IconButton(
                  onPressed: () {
                    scaffoldKey.currentState!.openDrawer();
                  },
                  icon: const Icon(Icons.menu)),
            )
          : null,
      drawer: context.isMobile
          ? History(
              showLast: false,
              showReplayButton: true,
            )
          : null,
      body: Responsive(
          mobile: SizedBox(
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
                              showReplayButton: false,
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
                  : const PuzzleGame()),
          another: Row(
            children: [
              Flexible(child: History()),
              Stack(
                children: const [
                  PuzzleGame(),
                  Align(
                    alignment: Alignment.topLeft,
                    child: ThemeIcon(),
                  )
                ],
              )
            ],
          )),
    );
  }

  void shuffle(BuildContext context) {
    global.currentOrder.clear();
    global.correctOrder.remove(16);
    global.correctOrder.shuffle();
    global.correctOrder.insert(15, 16);
    global.initShuffle = global.correctOrder;
    global.moves.v = 0;
    global.timer.reset();
    global.timer.pause();
    global.log.v = [];
    global.restart.rebuildWidget();
  }
}
