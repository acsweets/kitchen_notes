import 'package:hive/hive.dart';

part 'recommendation.g.dart';

@HiveType(typeId: 6)
class Recommendation {
  @HiveField(0)
  String id;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String recipeId;

  @HiveField(3)
  String type; // 'ingredient_match', 'expiry_alert', 'personal', 'trending'

  @HiveField(4)
  double score;

  @HiveField(5)
  Map<String, dynamic> reason;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  bool isClicked;

  Recommendation({
    required this.id,
    required this.userId,
    required this.recipeId,
    required this.type,
    required this.score,
    required this.reason,
    required this.createdAt,
    this.isClicked = false,
  });
}