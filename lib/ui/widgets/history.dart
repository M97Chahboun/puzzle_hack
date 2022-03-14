import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mc/mc.dart' show McMV, miniRebuild;
import 'package:puzzle_hack/utils/extensions.dart';

// ignore: must_be_immutable
class History extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  double? max;
  final bool showLast;
  final TextEditingController keyController = TextEditingController();

  History({Key? key, this.showLast = true, this.max}) : super(key: key);

  void _showLastItem() {
    if (showLast) {
      if (_scrollController.positions.isNotEmpty) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent + 100,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    max ??= context.height;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: max!),
      child: Container(
        height: context.height,
        width: context.width,
        color: Theme.of(context).backgroundColor,
        child: Stack(
          children: [
            McMV(
                global.log,
                () => ListView.builder(
                      controller: _scrollController,
                      dragStartBehavior: DragStartBehavior.down,
                      itemCount: global.log.v.length,
                      reverse: true,
                      itemBuilder: (BuildContext context, int index) {
                        List log = global.log.v[index].split(":");
                        String value = log[0];
                        String icon = log[1];
                        String time = log[2];
                        time = time.replaceAll("|", ":");
                        global.log.removeListener(miniRebuild, _showLastItem);
                        global.log.registerListener(miniRebuild, _showLastItem);

                        return TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.bounceOut,
                          builder: (BuildContext context, double? _value,
                              Widget? child) {
                            return Transform.translate(
                              offset: showLast
                                  ? Offset(0.0, _value! * 20)
                                  : Offset(_value! * 20, 0.0),
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                          radius: 10.0,
                                          child: Text(
                                            (index + 1).toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5!
                                                .copyWith(fontSize: 10.0),
                                          )),
                                      const SizedBox(
                                        width: 5.0,
                                      ),
                                      const Text("Move "),
                                      Container(
                                        height: 20.0,
                                        width: 20.0,
                                        color: Theme.of(context).primaryColor,
                                        child: Center(child: Text(value)),
                                      ),
                                      const Text(" to "),
                                      Icon(getIcon(icon),
                                          color: Theme.of(context)
                                              .iconTheme
                                              .color),
                                      const Text(" in "),
                                      Text(time)
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          tween: Tween<double>(begin: 1.0, end: 0.0),
                        );
                      },
                    )),
            if (context.isMobile && !showLast)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ),
          ],
        ),
      ),
    );
  }

  IconData? getIcon(String icon) {
    switch (icon) {
      case "right":
        return Icons.arrow_forward;
      case "left":
        return Icons.arrow_back;
      case "up":
        return Icons.arrow_upward;
      case "down":
        return Icons.arrow_downward;
    }
    return null;
  }
}
