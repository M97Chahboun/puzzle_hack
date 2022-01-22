import 'package:flutter/material.dart';
import 'package:puzzle_hack/ui/widgets/tile_image.dart';

class TileTheme extends StatelessWidget {
  const TileTheme({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          TileImage(
            color: "blue",
          ),
          TileImage(
            color: "yellow",
          ),
          TileImage(
            color: "green",
          ),
          TileImage(
            color: "number",
          ),
        ],
      ),
    );
  }
}
