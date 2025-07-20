import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:x2048_the_modern_edition/constants/colors.dart';
import 'package:x2048_the_modern_edition/models/highscore/highscore.dart';
import 'package:x2048_the_modern_edition/models/pause/pause.dart';
import 'package:x2048_the_modern_edition/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();
  Hive.registerAdapter(HighscoreAdapter());
  Hive.registerAdapter(PauseAdapter());
  await Hive.openBox<Highscore>('highscore');
  await Hive.openBox<Pause>('pause');
  final data = Hive.box<Highscore>('highscore');
  final pausedGrid = Hive.box<Pause>('pause');
  if (data.isEmpty) {
    data.add(Highscore(score: 0));
  }
  if (pausedGrid.isEmpty) {}

  runApp(
    MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: AppColors.background),
    ),
  );
}
