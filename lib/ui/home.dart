import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import 'package:puzzle_hack/extensions.dart';
import 'package:puzzle_hack/ui/widgets/history.dart';
import 'package:puzzle_hack/ui/widgets/moves.dart';
import 'package:puzzle_hack/ui/widgets/puzzle_game.dart';
import 'package:puzzle_hack/ui/widgets/theme_icon.dart';
import 'package:puzzle_hack/ui/widgets/tile_image.dart';
import 'package:puzzle_hack/ui/widgets/tile_theme.dart';
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
          tablet: Row(
            children: [
              Expanded(flex: 1, child: History()),
              const PuzzleGame(),
            ],
          ),
          desktop: Row(
            children: [
              Expanded(flex: 1, child: History()),
              const PuzzleGame(),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
