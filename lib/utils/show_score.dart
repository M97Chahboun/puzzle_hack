import 'package:flutter/material.dart';
import 'package:puzzle_hack/utils/extensions.dart';

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
  String barrierLabel = '',
}) =>
    showGeneralDialog<T>(
      transitionBuilder: (context, animation, secondaryAnimation, widget) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.decelerate,
        );

        return ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1).animate(curvedAnimation),
          child: FadeTransition(
            opacity: curvedAnimation,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 650),
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      barrierColor: const Color(0x66000000),
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => AppDialog(
        child: child,
      ),
    );

class AppDialog extends StatelessWidget {
  /// {@macro app_dialog}
  const AppDialog({
    Key? key,
    required this.child,
  }) : super(key: key);

  /// The content of this dialog.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      height: context.height,
      child: Padding(
        padding: const EdgeInsets.all(200.0),
        child: Container(
            width: context.width * 0.81,
            height: context.height * 0.3,
            color: Colors.yellow),
      ),
    );
  }
}
