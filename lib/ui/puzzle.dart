import 'package:flutter/material.dart';
import 'package:puzzle_hack/extensions.dart';
import 'package:puzzle_hack/utils/empty.dart';

import 'widgets/card.dart';

class Puzzle extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final ValueNotifier start = ValueNotifier(false);

  Puzzle({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
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
        body: context.width < 800
            ? puzzle(context)
            : Row(
                children: [
                  Flexible(
                      child: Container(
                    color: Colors.blue,
                  )),
                  puzzle(context)
                ],
              ));
  }

  Widget puzzle(BuildContext context) {
    return ValueListenableBuilder(
      builder: (context, _, __) {
        double x = 0;
        double y = 80;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500.0, minHeight: 968),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: context.height * 0.8,
                    width: context.width,
                    child: Stack(
                        children: context.s.correctOrder.map((index) {
                      context.s.currentOrder.add(index);
                      if (x == 400) {
                        x = 0;
                        y += 100;
                      }
                      x += 100;
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
                  SizedBox(
                    height: 60.0,
                    width: 120,
                    child: ElevatedButton(
                        onPressed: () {
                          context.s.currentOrder.clear();
                          context.s.correctOrder.remove(16);
                          context.s.correctOrder.shuffle();
                          context.s.correctOrder.insert(15, 16);
                          start.value = !start.value;
                        },
                        child: const Text("Shuffle")),
                  )
                ],
              ),
            ),
          ),
        );
      },
      valueListenable: start,
    );
  }
}
