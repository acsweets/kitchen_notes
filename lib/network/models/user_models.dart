class UserProfile {
  final int id;
  final String username;
  final String email;
  final String? avatar;
  final String? bio;
  final int followersCount;
  final int followingCount;
  final int recipesCount;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    this.avatar,
    this.bio,
    required this.followersCount,
    required this.followingCount,
    required this.recipesCount,
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'],
    username: json['username'],
    email: json['email'],
    avatar: json['avatar'],
    bio: json['bio'],
    followersCount: json['followersCount'] ?? 0,
    followingCount: json['followingCount'] ?? 0,
    recipesCount: json['recipesCount'] ?? 0,
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class UpdateProfileRequest {
  final String? avatar;
  final String? bio;

  UpdateProfileRequest({this.avatar, this.bio});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (avatar != null) data['avatar'] = avatar;
    if (bio != null) data['bio'] = bio;
    return data;
  }
}

class UserListResponse {
  final List<UserSummary> content;
  final int totalElements;
  final int totalPages;
  final int size;
  final int number;

  UserListResponse({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.number,
  });

  factory UserListResponse.fromJson(Map<String, dynamic> json) => UserListResponse(
    content: (json['content'] as List).map((item) => UserSummary.fromJson(item)).toList(),
    totalElements: json['totalElements'],
    totalPages: json['totalPages'],
    size: json['size'],
    number: json['number'],
  );
}

class UserSummary {
  final int id;
  final String username;
  final String? avatar;
  final String? bio;
  final int followersCount;
  final int recipesCount;
  final bool isFollowing;

  UserSummary({
    required this.id,
    required this.username,
    this.avatar,
    this.bio,
    required this.followersCount,
    required this.recipesCount,
    required this.isFollowing,
  });

  factory UserSummary.fromJson(Map<String, dynamic> json) => UserSummary(
    id: json['id'],
    username: json['username'],
    avatar: json['avatar'],
    bio: json['bio'],
    followersCount: json['followersCount'] ?? 0,
    recipesCount: json['recipesCount'] ?? 0,
    isFollowing: json['isFollowing'] ?? false,
  );
}

class UserStats {
  final int totalRecipes;
  final int totalLikes;
  final int totalCollections;
  final int totalFollowers;
  final int totalFollowing;
  final double averageRating;

  UserStats({
    required this.totalRecipes,
    required this.totalLikes,
    required this.totalCollections,
    required this.totalFollowers,
    required this.totalFollowing,
    required this.averageRating,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) => UserStats(
    totalRecipes: json['totalRecipes'] ?? 0,
    totalLikes: json['totalLikes'] ?? 0,
    totalCollections: json['totalCollections'] ?? 0,
    totalFollowers: json['totalFollowers'] ?? 0,
    totalFollowing: json['totalFollowing'] ?? 0,
    averageRating: (json['averageRating'] ?? 0.0).toDouble(),
  );
}