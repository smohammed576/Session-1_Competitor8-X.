import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:x2048_the_modern_edition/constants/colors.dart';
import 'package:x2048_the_modern_edition/helpers/logic.dart';
import 'package:x2048_the_modern_edition/models/highscore/highscore.dart';
import 'package:x2048_the_modern_edition/models/pause/pause.dart';
import 'package:x2048_the_modern_edition/models/tile.dart';
import 'package:x2048_the_modern_edition/screens/gameover.dart';
import 'package:x2048_the_modern_edition/widgets/button.dart';
import 'package:collection/collection.dart';
import 'package:x2048_the_modern_edition/widgets/tile.dart';

class GameScreen extends StatefulWidget {
  final Pause? pause;
  const GameScreen({super.key, this.pause});

  @override
  State<GameScreen> createState() => _GameStateScreen();
}

class _GameStateScreen extends State<GameScreen> with TickerProviderStateMixin {
  late AnimationController animationController;
  late List<List<Tile>> grid;
  List<Tile> addNew = [];
  Iterable<Tile> get flattened => grid.expand((item) => item);
  Iterable<List<Tile>> get columns =>
      List.generate(4, (x) => List.generate(4, (y) => grid[y][x]));
  late int score;
  int? highscore;
  List<int> newNumber = [2, 2, 2, 2, 2, 2, 2, 2, 2, 4];
  List<List<Tile>>? oldGrid;
  int? oldScore;

  @override
  void initState() {
    super.initState();
    getHighscore();
    grid = (widget.pause != null
        ? widget.pause?.grid
              .asMap()
              .entries
              .map(
                (x) => x.value
                    .asMap()
                    .entries
                    .map((y) => Tile(y.key, x.key, y.value))
                    .toList(),
              )
              .toList()
        : List.generate(4, (y) => List.generate(4, (x) => Tile(x, y, 0))))!;
    score = widget.pause?.score ?? 0;
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        for (var item in addNew) {
          grid[item.y][item.x].value = item.value;
        }
        for (var item in flattened) {
          item.resetAnimations();
        }
        addNew.clear();
        Future.delayed(Duration(milliseconds: 10), () {
          if (gameOver()) {
            removePaused();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    GameOverScreen(score: score, highscore: highscore!),
              ),
            );
          }
        });
      }
    });
    newNumber.shuffle();
    if (widget.pause == null) {
      grid[1][2].value = newNumber[0];
      grid[3][2].value = newNumber[1];
    }

    for (var item in flattened) {
      item.resetAnimations();
    }
  }

  void getHighscore() async {
    await Hive.openBox<Highscore>('highscore');
    final data = Hive.box<Highscore>('highscore');
    setState(() {
      highscore = data.getAt(0)!.score;
    });
  }

  void addNewTile() {
    List<Tile> empty = flattened.where((item) => item.value == 0).toList();
    empty.shuffle();
    newNumber.shuffle();
    addNew.add(
      Tile(empty.first.x, empty.first.y, newNumber[0])
        ..appear(animationController),
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width - 40 * 2;
    double tileSize = (size - 4 * 2) / 4;
    List<Widget> stackItems = [];
    stackItems.addAll(
      flattened.map(
        (item) => GameTile(tileSize: tileSize, tile: item, isEmpty: true),
      ),
    );
    stackItems.addAll(
      [flattened, addNew]
          .expand((item) => item)
          .map(
            (item) => AnimatedBuilder(
              animation: animationController,
              builder: (context, child) => item.animatedValue!.value == 0
                  ? SizedBox()
                  : GameTile(tileSize: tileSize, tile: item, isEmpty: false),
            ),
          ),
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Score: $score',
                style: TextStyle(
                  fontSize: 25,
                  color: AppColors.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Highscore: $highscore',
                style: TextStyle(
                  fontSize: 25,
                  color: AppColors.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              MainButton(
                text: 'Undo',
                fontsize: 25,
                onTap: () {
                  if (oldGrid != null) {
                    setState(() {
                      grid = oldGrid!;
                      if (highscore == score) {
                        setHighscore(oldScore);
                        highscore = oldScore;
                      }
                      score = oldScore ?? 0;
                      addNew.clear();
                      for (var item in flattened) {
                        item.resetAnimations();
                      }
                    });
                  }
                },
              ),
              MainButton(
                text: 'Pause',
                fontsize: 25,
                onTap: () {
                  removePaused();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameOverScreen(
                        score: score,
                        highscore: highscore!,
                        grid: grid,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.grid,
          ),
          child: GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.velocity.pixelsPerSecond.dy < -250 && canSwipeUp()) {
                doSwipe(swipeUp);
              } else if (details.velocity.pixelsPerSecond.dy > 250 &&
                  canSwipeDown()) {
                doSwipe(swipeDown);
              }
            },
            onHorizontalDragEnd: (details) {
              if (details.velocity.pixelsPerSecond.dx < -1000 &&
                  canSwipeLeft()) {
                doSwipe(swipeLeft);
              } else if (details.velocity.pixelsPerSecond.dx > 1000 &&
                  canSwipeRight()) {
                doSwipe(swipeRight);
              }
            },
            onDoubleTap: () {
              final list = [swipeUp, swipeDown, swipeLeft, swipeRight];
              list.shuffle();
              if (list[0] == swipeUp) {
                if (canSwipeUp()) {
                  doSwipe(list[0]);
                }
              }
              if (list[0] == swipeDown) {
                if (canSwipeDown()) {
                  doSwipe(list[0]);
                }
              }
              if (list[0] == swipeLeft) {
                if (canSwipeLeft()) {
                  doSwipe(list[0]);
                }
              }
              if (list[0] == swipeRight) {
                if (canSwipeRight()) {
                  doSwipe(list[0]);
                }
              }
            },
            child: Stack(children: stackItems),
          ),
        ),
      ),
    );
  }

  bool brokeRecord() => score > highscore!;
  bool gameOver() {
    return !canSwipeUp() &&
        !canSwipeDown() &&
        !canSwipeLeft() &&
        !canSwipeRight();
  }

  bool canSwipeLeft() => grid.any(canSwipe);
  bool canSwipeRight() =>
      grid.map((item) => item.reversed.toList()).any(canSwipe);

  bool canSwipeUp() => columns.any(canSwipe);
  bool canSwipeDown() =>
      columns.map((item) => item.reversed.toList()).any(canSwipe);

  void doSwipe(void Function() swipeFn) {
    setState(() {
      oldGrid = saveOld(grid);
      oldScore = score;
      swipeFn();
      if (brokeRecord()) {
        highscore = score;
      }
      addNewTile();
      animationController.forward(from: 0);
    });
  }

  void swipeLeft() {
    for (var item in grid) {
      mergeTiles(
        item,
        animationController,
        (value) => score += value,
        brokeRecord(),
      );
    }
  }

  void swipeRight() => grid
      .map((item) => item.reversed.toList())
      .forEach(
        (item) => mergeTiles(
          item,
          animationController,
          (value) => score += value,
          brokeRecord(),
        ),
      );
  void swipeUp() {
    for (var item in columns) {
      mergeTiles(
        item,
        animationController,
        (value) => score += value,
        brokeRecord(),
      );
    }
  }

  void swipeDown() => columns
      .map((item) => item.reversed.toList())
      .forEach(
        (item) => mergeTiles(
          item,
          animationController,
          (value) => score += value,
          brokeRecord(),
        ),
      );
}
