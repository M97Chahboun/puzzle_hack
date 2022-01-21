import 'package:flutter/material.dart';
import 'package:puzzle_hack/utils/tile_texture.dart';
import 'package:puzzle_hack/extensions.dart';

class TileImage extends StatelessWidget {
  const TileImage({Key? key, required this.color}) : super(key: key);
  final String color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          global.currentTile = color;
          global.restart.v = !global.restart.v;
        },
        child: color != "number"
            ? SizedBox(
                height: 60.0,
                width: 60.0,
                child: Image.asset(TileTexture.getColor(color)),
              )
            : Container(
                height: 60.0,
                width: 60.0,
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Text(
                    "N",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ));
  }
}
