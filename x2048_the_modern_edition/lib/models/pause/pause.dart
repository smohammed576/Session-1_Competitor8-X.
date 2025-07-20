import 'package:hive/hive.dart';
part 'pause.g.dart';

@HiveType(typeId: 1)
class Pause extends HiveObject{
  @HiveField(0)
  List<List<int>> grid;
  
  @HiveField(1)
  int score;

  Pause({required this.grid, required this.score});
}