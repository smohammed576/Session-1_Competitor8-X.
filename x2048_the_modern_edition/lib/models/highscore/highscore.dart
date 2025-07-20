import 'package:hive/hive.dart';

part 'highscore.g.dart';

@HiveType(typeId: 0)

class Highscore extends HiveObject{
  @HiveField(0)
  int score;

  Highscore({required this.score});
}