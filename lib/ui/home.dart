import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mc/mc.dart' show McController, McMV, McValue, mergesRebuild;
import 'package:puzzle_hack/platforms/desktop.dart';
import 'package:puzzle_hack/platforms/mobile.dart';
import 'package:puzzle_hack/platforms/tablet.dart';
import 'package:puzzle_hack/ui/widgets/history.dart';
import 'package:puzzle_hack/ui/widgets/theme_icon.dart';
import 'package:puzzle_hack/utils/extensions.dart';
import 'package:puzzle_hack/utils/get_correct_tiles.dart';
import 'package:puzzle_hack/utils/responsive.dart';

class Home extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController keyController = TextEditingController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: () => shuffle(context),
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.shuffle),
          ),
          McMV(McValue.merge([global.replay, global.log]), () {
            return !global.upload.v
                ? FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      uploadLog(context);
                    },
                    child: const Icon(
                      Icons.upload,
                    ),
                  )
                : FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: global.log.v.isNotEmpty
                        ? () {
                            index = 0;
                            if (global.replay.v) {
                              global.replay.v = false;
                            } else {
                              replayGame(context);
                              global.replay.v = true;
                            }
                          }
                        : null,
                    child: Icon(
                      global.replay.v ? Icons.pause : Icons.play_arrow,
                    ),
                  );
          })
        ],
      ),
      appBar: context.isMobile
          ? AppBar(
              centerTitle: true,
              title: const Text("Puzzle Challenge").fitText,
              actions: const [
                ThemeIcon(),
              ],
              leading: IconButton(
                  onPressed: () {
                    scaffoldKey.currentState!.openDrawer();
                  },
                  icon: const Icon(Icons.history)),
            )
          : null,
      drawer: context.isMobile
          ? History(
              showLast: false,
            )
          : null,
      body: const Responsive(
          mobile: Mobile(), tablet: Tablet(), desktop: Desktop()),
    );
  }

  Future<dynamic> uploadLog(BuildContext context) {
    global.takeFocus.v = false;
    FocusNode keyNode =
        McController().add("keyFocus", FocusNode(), readOnly: true);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: IntrinsicHeight(
            child: IntrinsicWidth(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      autofocus: true,
                      focusNode: keyNode,
                      decoration: const InputDecoration(
                          hintText: "write log key",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)))),
                      controller: keyController,
                    ),
                    TextButton(
                        onPressed: () {
                          if (keyController.text.isNotEmpty) {
                            print(keyController.text);
                            try {
                              FirebaseFirestore.instance
                                  .collection('puzzles')
                                  .doc(keyController.text.trim())
                                  .get()
                                  .then((value) {
                                print(value.id);
                                global.correctOrder =
                                    List<int>.from(value.data()!["init"]);
                                global.currentOrder =
                                    List<int>.from(value.data()!["init"]);

                                global.log.v =
                                    List<String>.from(value.data()!["log"]);
                                global.upload.v = true;
                                global.restart.rebuildWidget();
                              }).whenComplete(() => context.pop());
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                        child: const Text("valid"))
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() => global.takeFocus.v = true);
  }

  void shuffle(BuildContext context) {
    global.currentOrder.clear();
    global.correctOrder.remove(16);
    //global.correctOrder.shuffle();
    global.correctOrder = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      16,
      15
    ];
    global.initShuffle = global.correctOrder;
    global.moves.v = 0;
    global.timer.reset();
    global.timer.pause();
    global.log.v = [];
    GetCorrectTiles.getCorrectTiles(true);
    global.upload.v = false;
    global.restart.rebuildWidget();
  }

  void replayGame(BuildContext context) {
    List<String> olderLog = global.log.v;
    global.log.v = [];
    global.timer.reset();
    if (!global.timer.isStarted) global.timer.startTimer();
    global.moves.v = 0;
    // global.currentOrder = List.from(global.initShuffle);
    // global.correctOrder = List.from(global.initShuffle);
    global.restart.rebuildWidget();
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      String e = olderLog[index];
      String value = e.split(":")[0];
      String to = e.split(":")[1];
      List<String> time = e.split(":")[2].split("|");

      int sec = time[0].i;
      int min = time[1].i;
      int hr = time[2].i;
      if (olderLog.first == e) move(to, value.i);

      if (sec + min + hr == global.timer.total && !(olderLog.first == e)) {
        move(to, value.i);
      }
      if (index == olderLog.length) {
        timer.cancel();
        global.timer.pause();
        global.replay.v = false;
        global.upload.v = false;
      }
    });
  }

  void move(String to, int cardIndex) {
    switch (to) {
      case "right":
        global.controller[cardIndex].right();
        break;
      case "left":
        global.controller[cardIndex].left();
        break;
      case "up":
        global.controller[cardIndex].up();
        break;
      case "down":
        global.controller[cardIndex].down();
        break;
    }

    index++;
  }
}
