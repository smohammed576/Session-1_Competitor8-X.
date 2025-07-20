import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:x2048_the_modern_edition/models/highscore/highscore.dart';
import 'package:x2048_the_modern_edition/models/pause/pause.dart';
import 'package:x2048_the_modern_edition/models/tile.dart';
import 'package:x2048_the_modern_edition/screens/home.dart';
import 'package:x2048_the_modern_edition/widgets/button.dart';

class GameOverScreen extends StatefulWidget {
  final int score;
  final int highscore;
  final List<List<Tile>>? grid;
  const GameOverScreen({
    super.key,
    required this.score,
    required this.highscore,
    this.grid,
  });

  @override
  State<GameOverScreen> createState() => _GameOverStateScreen();
}

class _GameOverStateScreen extends State<GameOverScreen> {
  List<List<int>>? grid;
  @override
  void initState() {
    super.initState();
    if (widget.grid != null) {
      grid = widget.grid!.map((x) => x.map((y) => y.value).toList()).toList();
    }
  }

  void setHighscore() async {
    await Hive.openBox<Highscore>('highscore');
    final data = Hive.box<Highscore>('highscore');
    data.putAt(0, Highscore(score: widget.score));
  }

  void savePaused() async {
    await Hive.openBox<Pause>('pause');
    final data = Hive.box<Pause>('pause');
    if (data.isEmpty) {
      data.add(Pause(grid: grid!, score: widget.score));
    } else {
      data.putAt(0, Pause(grid: grid!, score: widget.score));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Game Over!',
              style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Text(
              'Current Score:  ${widget.score}',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Highscore:  ${widget.highscore}',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 100),
            SizedBox(
              width: 400,
              height: 80,
              child: MainButton(
                text: 'Undo',
                fontsize: 40,
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            SizedBox(height: 40),
            SizedBox(
              width: 400,
              height: 80,
              child: MainButton(
                text: 'End Game',
                fontsize: 40,
                onTap: () {
                  if (widget.score > widget.highscore) {
                    setHighscore();
                  }
                  if (widget.grid != null) {
                    savePaused();
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                        highscore: Highscore(score: widget.highscore),
                        pause: widget.grid != null
                            ? Pause(grid: grid!, score: widget.score)
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
