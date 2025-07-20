import 'package:flutter/material.dart';
import 'package:x2048_the_modern_edition/constants/colors.dart';
import 'package:x2048_the_modern_edition/models/tile.dart';

class GameTile extends StatelessWidget{
  final double tileSize;
  final Tile tile;
  final bool isEmpty;
  const GameTile({super.key, required this.tileSize, required this.tile, required this.isEmpty});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: isEmpty ? tile.animatedX!.value * tileSize : tile.x * tileSize,
      top: isEmpty ? tile.animatedY!.value * tileSize : tile.y * tileSize,
      width: tileSize,
      height: tileSize,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isEmpty ? AppColors.empty : AppColors.values['${tile.animatedValue!.value > 2048 ? 'other' : tile.animatedValue!.value}']
          ),
          width: isEmpty ? tileSize - 10 * 2 : (tileSize - 4 * 2) * tile.scale!.value,
          height: isEmpty ? tileSize - 10 * 2 : (tileSize - 4 * 2) * tile.scale!.value,
          child: isEmpty ? null : Center(
            child: Text('${tile.animatedValue!.value}', style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: tile.animatedValue!.value <= 8 ? AppColors.greycolor : AppColors.whitecolor
            ),),
          ),
        ),
      ),
    );
  }
}