// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeAdapter extends TypeAdapter<Recipe> {
  @override
  final int typeId = 3;

  @override
  Recipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipe(
      id: fields[0] as String,
      name: fields[1] as String,
      categoryId: fields[2] as String,
      coverImage: fields[3] as String?,
      ingredients: (fields[4] as List).cast<Ingredient>(),
      steps: (fields[5] as List).cast<RecipeStep>(),
      cookCount: fields[6] as int,
      rating: fields[7] as double,
      createdAt: fields[8] as DateTime,
      updatedAt: fields[9] as DateTime,
      isFavorite: fields[10] as bool,
      notes: fields[11] as String,
      authorId: fields[12] as String?,
      images: (fields[13] as List).cast<String>(),
      tags: (fields[14] as List).cast<String>(),
      likesCount: fields[15] as int,
      collectionsCount: fields[16] as int,
      isPublic: fields[17] as bool,
      difficulty: fields[18] as String,
      prepTime: fields[19] as int,
      cookTime: fields[20] as int,
      servings: fields[21] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Recipe obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.coverImage)
      ..writeByte(4)
      ..write(obj.ingredients)
      ..writeByte(5)
      ..write(obj.steps)
      ..writeByte(6)
      ..write(obj.cookCount)
      ..writeByte(7)
      ..write(obj.rating)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.isFavorite)
      ..writeByte(11)
      ..write(obj.notes)
      ..writeByte(12)
      ..write(obj.authorId)
      ..writeByte(13)
      ..write(obj.images)
      ..writeByte(14)
      ..write(obj.tags)
      ..writeByte(15)
      ..write(obj.likesCount)
      ..writeByte(16)
      ..write(obj.collectionsCount)
      ..writeByte(17)
      ..write(obj.isPublic)
      ..writeByte(18)
      ..write(obj.difficulty)
      ..writeByte(19)
      ..write(obj.prepTime)
      ..writeByte(20)
      ..write(obj.cookTime)
      ..writeByte(21)
      ..write(obj.servings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
