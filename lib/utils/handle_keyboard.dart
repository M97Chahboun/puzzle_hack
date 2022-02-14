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
 final List<int> correct = List.generate(16, (index) => index + 1);
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
     
    if (!correct.isSameOrder(global.currentOrder)) {
      if (event is RawKeyDownEvent) {
        int right = global.currentOrder.indexOf(16) - 1;
        int down = global.currentOrder.indexOf(16) - 4;
        int left = global.currentOrder.indexOf(16) + 1;
        int up = global.currentOrder.indexOf(16) + 4;

        final physicalKey = event.data.physicalKey;
        if (physicalKey == PhysicalKeyboardKey.arrowDown) {
          if (!down.isNegative && 16 > down) {
            global.controller[global.currentOrder[down]].down();
          }
        } else if (physicalKey == PhysicalKeyboardKey.arrowUp) {
          if (!up.isNegative && 16 > up) {
            global.controller[global.currentOrder[up]].up();
          }
        } else if (physicalKey == PhysicalKeyboardKey.arrowRight) {
          if (!right.isNegative && 16 > right) {
            global.controller[global.currentOrder[right]].right();
          }
        } else if (physicalKey == PhysicalKeyboardKey.arrowLeft) {
          if (!left.isNegative && 16 > left) {
            global.controller[global.currentOrder[left]].left();
          }
        }
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
