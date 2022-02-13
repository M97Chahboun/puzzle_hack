import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'extensions.dart';

class PuzzleKeyboardHandler extends StatefulWidget {
  /// {@macro puzzle_keyboard_handler}
  const PuzzleKeyboardHandler({Key? key, required this.child})
      : super(key: key);
  final Widget child;

  @override
  State createState() => _PuzzleKeyboardHandlerState();
}

class _PuzzleKeyboardHandlerState extends State<PuzzleKeyboardHandler> {
  // The node used to request the keyboard focus.
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    // List list = [2,3,6,7,10,11,14,15];
    // int xEmpty = global.currentOrder.indexOf(16);
    // int yEmpty = global.currentOrder.indexOf(16) + 3;
    if (event is RawKeyDownEvent) {
      print(global.currentOrder);
      int right = global.currentOrder.indexOf(16);
      int down = global.currentOrder.indexOf(16) - 3;
      int left = global.currentOrder.indexOf(16) + 1;
      int up = global.currentOrder.indexOf(16) + 4;

      final physicalKey = event.data.physicalKey;
      if (physicalKey == PhysicalKeyboardKey.arrowDown) {
        if (!down.isNegative && 16 > down) global.controller[down].down();
      } else if (physicalKey == PhysicalKeyboardKey.arrowUp) {
        if (!up.isNegative && 16 > up) global.controller[up].up();
      } else if (physicalKey == PhysicalKeyboardKey.arrowRight) {
        if (!right.isNegative && 16 > right) global.controller[right].right();
      } else if (physicalKey == PhysicalKeyboardKey.arrowLeft) {
        if (!left.isNegative && 16 > left) global.controller[left].left();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      child: Builder(
        builder: (context) {
          if (!_focusNode.hasFocus) {
            FocusScope.of(context).requestFocus(_focusNode);
          }
          return widget.child;
        },
      ),
    );
  }
}
