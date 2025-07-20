import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:x2048_the_modern_edition/constants/colors.dart';
import 'package:x2048_the_modern_edition/models/highscore/highscore.dart';
import 'package:x2048_the_modern_edition/models/pause/pause.dart';
import 'package:x2048_the_modern_edition/screens/game.dart';
import 'package:x2048_the_modern_edition/widgets/button.dart';

class HomeScreen extends StatefulWidget {
  final Pause? pause;
  final Highscore? highscore;
  const HomeScreen({super.key, this.pause, this.highscore});

  @override
  State<HomeScreen> createState() => _HomeStateScreen();
}

class _HomeStateScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '2048 - The Modern Edition',
                style: TextStyle(
                  fontSize: 45,
                  color: AppColors.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              Text(
                widget.highscore != null ? 'Welcome back!' : 'Welcome!',
                style: TextStyle(
                  fontSize: 35,
                  color: AppColors.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              MainButton(
                text: widget.pause != null ? 'Resume Game' : 'New Game',
                fontsize: 30,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GameScreen(pause: widget.pause),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
