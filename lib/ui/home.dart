import 'package:flutter/material.dart';
import 'package:puzzle_hack/extensions.dart';
import 'package:puzzle_hack/ui/widgets/history.dart';
import 'package:puzzle_hack/ui/widgets/puzzle_game.dart';
import 'package:puzzle_hack/utils/responsive.dart';

class Home extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print(context.height);
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () => shuffle(context),
        child: const Icon(Icons.shuffle),
      ),
      appBar: context.isMobile
          ? AppBar(
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
              showReplayButton: false,
            )
          : null,
      body: Responsive(
          mobile: SizedBox(
              width: context.width,
              child: Column(
                children: [
                  const PuzzleGame(),
                  if (context.height >= 771)
                    Flexible(
                        child: History(
                      showReplayButton: false,
                    ))
                ],
              )),
          another: Row(
            children: [Flexible(child: History()), const PuzzleGame()],
          )),
    );
  }

  void shuffle(BuildContext context) {
    context.s.currentOrder.clear();
    context.s.correctOrder.remove(16);
    context.s.correctOrder.shuffle();
    context.s.correctOrder.insert(15, 16);
    context.s.initShuffle = context.s.correctOrder;
    context.s.moves.v = 0;
    context.s.timer.reset();
    context.s.timer.pause();
    context.s.restart.rebuildWidget();
  }
}
