import 'package:flutter/animation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:x2048_the_modern_edition/models/highscore/highscore.dart';
import 'package:x2048_the_modern_edition/models/pause/pause.dart';
import 'package:x2048_the_modern_edition/models/tile.dart';
import 'package:collection/collection.dart';

// checken of kan swipen yk
bool canSwipe(List<Tile> tiles) {
  for (int i = 0; i < tiles.length; i++) {
    if (tiles[i].value == 0) {
      if (tiles.skip(i + 1).any((item) => item.value != 0)) {
        return true;
      }
    } else {
      Tile? nextNotNull = tiles
          .skip(i + 1)
          .firstWhereOrNull((item) => item.value != 0);
      if (nextNotNull != null && nextNotNull.value == tiles[i].value) {
        return true;
      }
    }
  }
  return false;
}

//de tiles mergen (wow wie had die verwacht hoho)
void mergeTiles(List<Tile> tiles, AnimationController animationController, void Function(int) addScore, hasBroken) {
  for (int i = 0; i < tiles.length; i++) {
    Iterable<Tile> check = tiles.skip(i).skipWhile((value) => value.value == 0);
    if (check.isNotEmpty) {
      Tile tile = check.first;
      Tile? merge = check.skip(1).firstWhereOrNull((item) => item.value != 0);
      if (merge == null || merge.value != tile.value) {
        merge = null;
      }
      if (tiles[i] != tile || merge != null) {
        int result = tile.value;
        tile.moveTo(animationController, tiles[i].x, tiles[i].y);
        if (merge != null) {
          result += merge.value;
          addScore(result);
          if(hasBroken){
            setHighscore(result);
          }
          merge.moveTo(animationController, tiles[i].x, tiles[i].y);
          merge.bounce(animationController);
          merge.changeNumber(animationController, result);
          merge.value = 0;
          tile.changeNumber(animationController, 0);
        }
        tile.value = 0;
        tiles[i].value = result;
      }
    }
  }
}

//oude grid opslaan voor undo function
List<List<Tile>> saveOld(List<List<Tile>> grid){
  return List.generate(4, (y) => List.generate(4, (x){
    Tile tile = grid[y][x];
    return Tile(x, y, tile.value);
  }));
}

void setHighscore(score) async{
  await Hive.openBox<Highscore>('highscore');
  final data = Hive.box<Highscore>('highscore');
  data.putAt(0, Highscore(score: score));
}

void removePaused() async{
  print('delete');
    await Hive.openBox<Pause>('pause');
    final data = Hive.box<Pause>('pause');
    if(data.isNotEmpty){
      data.deleteAt(0);
    }
  }