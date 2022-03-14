import 'package:flutter/material.dart';
import 'package:puzzle_hack/utils/extensions.dart';
import 'package:puzzle_hack/utils/tile_texture.dart';

class TileImage extends StatelessWidget {
  const TileImage({Key? key, required this.color}) : super(key: key);
  final String color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          global.currentTile = color;
          global.correctOrder = List.from(global.currentOrder);
          global.restart.v = !global.restart.v;
        },
        child: color != "number"
            ? Container(
                height: 60.0,
                width: 60.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage(TileTexture.getColor(color))),
                    borderRadius: const BorderRadius.all(Radius.circular(9.0))),
              )
            : Container(
                height: 60.0,
                width: 60.0,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(9.0))),
                child: Center(
                  child: Text(
                    "N",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ),
              ));
  }
}
