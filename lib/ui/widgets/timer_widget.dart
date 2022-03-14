import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import 'package:puzzle_hack/ui/widgets/theme_icon.dart';
import 'package:puzzle_hack/utils/extensions.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: McMV(global.timer, () {
        String millsec = global.timer.millseconds.two.toString();
        String sec = global.timer.seconds.two.toString();
        String min = global.timer.minutes.two.toString();
        return Row(
          children: [
            McMV(global.timer, () {
              return Icon(
                Icons.timer,
                color: global.timer.timer.isActive
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                size: 30.0,
              );
            }),
            Text(
              "$min:$sec:$millsec",
              style: Theme.of(context)
                  .textTheme
                  .headline5!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            if (!context.isMobile) const ThemeIcon(),
          ],
        );
      }),
    );
  }
}
