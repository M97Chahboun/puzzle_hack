import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import 'package:puzzle_hack/extensions.dart';
import 'package:puzzle_hack/ui/widgets/theme_icon.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: McMV(global.timer, () {
        String sec = global.timer.seconds.two.toString();
        String min = global.timer.minutes.two.toString();
        String hr = global.timer.hours.two.toString();
        return Row(
          children: [
            const Icon(
              Icons.timer,
              size: 40.0,
            ),
            Text(
              "$hr:$min:$sec",
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            if (!context.isMobile) const ThemeIcon(),
          ],
        );
      }),
    );
  }
}
