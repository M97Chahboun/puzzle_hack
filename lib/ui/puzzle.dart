import 'package:flutter/material.dart';
import 'package:puzzle_hack/extensions.dart';
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
          print(event);
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
          drawer: context.isMobile
              ? Container(
                  color: Colors.blue,
                )
              : null,
          body: Responsive(
              mobile: SizedBox(
                  width: context.width, child: PuzzleGame(start: start)),
              another: Row(
                children: [
                  Flexible(
                      child: Container(
                    color: Colors.blue,
                  )),
                  PuzzleGame(start: start)
                ],
              )),
        ));
  }

  void shuffle(BuildContext context) {
    context.s.currentOrder.clear();
    context.s.correctOrder.remove(16);
    context.s.correctOrder.shuffle();
    context.s.correctOrder.insert(15, 16);
    start.value = !start.value;
  }
}
