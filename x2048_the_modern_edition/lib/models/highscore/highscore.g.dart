// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'highscore.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HighscoreAdapter extends TypeAdapter<Highscore> {
  @override
  final int typeId = 0;

  @override
  Highscore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Highscore(
      score: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Highscore obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.score);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HighscoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
