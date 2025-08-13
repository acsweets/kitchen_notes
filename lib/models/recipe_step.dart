import 'package:hive/hive.dart';

part 'recipe_step.g.dart';

@HiveType(typeId: 2)
class RecipeStep {
  @HiveField(0)
  int order;

  @HiveField(1)
  String description;

  @HiveField(2)
  List<String> images;

  RecipeStep({
    required this.order,
    required this.description,
    this.images = const [],
  });
}