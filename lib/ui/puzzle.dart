import 'package:flutter/material.dart';
import 'package:puzzle_hack/extensions.dart';
import 'package:puzzle_hack/ui/widgets/history.dart';
import 'package:puzzle_hack/ui/widgets/puzzle_game.dart';
import 'package:puzzle_hack/utils/responsive.dart';

class Puzzle extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier start = ValueNotifier(false);
  Map<ShortcutActivator, VoidCallback>? bindings;
  Puzzle({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Focus(
        onKey: (FocusNode node, RawKeyEvent event) {
          KeyEventResult result = KeyEventResult.ignored;
          return result;
        },
        child: Scaffold(
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
          drawer: context.isMobile ? History() : null,
          body: Responsive(
              mobile: SizedBox(width: context.width, child: const PuzzleGame()),
              another: Row(
                children: [Flexible(child: History()), const PuzzleGame()],
              )),
        ));
  }

  void shuffle(BuildContext context) {
    global.currentOrder.clear();
    global.correctOrder.remove(16);
    global.correctOrder.shuffle();
    global.correctOrder.insert(15, 16);
    global.restart.v = !global.restart.v;
  }
}
