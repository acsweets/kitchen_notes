import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 5)
class User {
  @HiveField(0)
  String id;

  @HiveField(1)
  String username;

  @HiveField(2)
  String email;

  @HiveField(3)
  String? avatar;

  @HiveField(4)
  String? bio;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  int followersCount;

  @HiveField(7)
  int followingCount;

  @HiveField(8)
  int recipesCount;

  @HiveField(9)
  List<String> achievements;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.avatar,
    this.bio,
    required this.createdAt,
    this.followersCount = 0,
    this.followingCount = 0,
    this.recipesCount = 0,
    this.achievements = const [],
  });
}