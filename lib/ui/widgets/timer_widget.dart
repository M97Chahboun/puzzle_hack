import 'package:flutter/material.dart';
import 'package:mc/mc.dart';
import 'package:puzzle_hack/utils/extensions.dart';
import 'package:puzzle_hack/ui/widgets/theme_icon.dart';

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
            const Icon(
              Icons.timer,
              size: 40.0,
            ),
            Text(
              "$min:$sec:$millsec",
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
