import 'package:flutter/material.dart';
import 'package:puzzle_hack/services/firebase_helper.dart';
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
      pageBuilder: (context, animation, secondaryAnimation) =>
          const AppDialog(),
    );

class AppDialog extends StatelessWidget {
  /// {@macro app_dialog}
  const AppDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.isMobile
          ? EdgeInsets.symmetric(
              horizontal: context.width * 0.1, vertical: context.height * 0.3)
          : EdgeInsets.zero,
      child: SizedBox(
        width: context.width,
        height: context.height,
        child: Container(
          padding: EdgeInsets.all(context.isMobile ? 0.0 : 200.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 2, child: Image.asset("assets/images/dash.png")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PopUpButton(
                        title: "Share",
                        onTap: () {
                          FirebaseHelper.sharePuzzle()
                              .then((value) => print(value));
                        }),
                    const SizedBox(
                      width: 15.0,
                    ),
                    PopUpButton(title: "Exit", onTap: context.pop)
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            width: context.width * 0.81,
            height: context.height * 0.3,
          ),
        ),
      ),
    );
  }
}

class PopUpButton extends StatelessWidget {
  const PopUpButton({Key? key, required this.title, required this.onTap})
      : super(key: key);
  final String title;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(.5),
            shadowColor: MaterialStateProperty.all(Colors.black),
            backgroundColor:
                MaterialStateProperty.all(Theme.of(context).primaryColor)),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Theme.of(context).backgroundColor),
        ));
  }
}
