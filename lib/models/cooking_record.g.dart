// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cooking_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CookingRecordAdapter extends TypeAdapter<CookingRecord> {
  @override
  final int typeId = 4;

  @override
  CookingRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CookingRecord(
      id: fields[0] as String,
      recipeId: fields[1] as String,
      recipeName: fields[2] as String,
      cookingDate: fields[3] as DateTime,
      rating: fields[4] as double,
      notes: fields[5] as String,
      images: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CookingRecord obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.recipeId)
      ..writeByte(2)
      ..write(obj.recipeName)
      ..writeByte(3)
      ..write(obj.cookingDate)
      ..writeByte(4)
      ..write(obj.rating)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.images);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CookingRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
