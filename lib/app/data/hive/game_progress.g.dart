// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameProgressAdapter extends TypeAdapter<GameProgress> {
  @override
  final int typeId = 0;

  @override
  GameProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameProgress(
      highScore: fields[0] as int,
      lastScore: fields[1] as int,
      gamesPlayed: fields[2] as int,
      coins: fields[3] as int,
      difficulty: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, GameProgress obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.highScore)
      ..writeByte(1)
      ..write(obj.lastScore)
      ..writeByte(2)
      ..write(obj.gamesPlayed)
      ..writeByte(3)
      ..write(obj.coins)
      ..writeByte(4)
      ..write(obj.difficulty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
