import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import 'package:puzzle_hack/extensions.dart';

class History extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {  
    return Container(
      color: Colors.blue,
      child: McMV(
          context.s.log,
          () => ListView.builder(
                controller: _scrollController,
                dragStartBehavior: DragStartBehavior.down,
                itemCount: context.s.log.v.length,
                reverse: true,
                itemBuilder: (BuildContext context, int index) {
                  if (!context.isMobile) {
                    _scrollController.jumpTo(
                      _scrollController.position.maxScrollExtent,
                    );
                  }
                  return FittedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          Text(
                            context.s.log.v[index],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )),
    );
  }
}
