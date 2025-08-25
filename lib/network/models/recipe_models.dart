class RecipeListResponse {
  final List<RecipeSummary> content;
  final int totalElements;
  final int totalPages;
  final int size;
  final int number;

  RecipeListResponse({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.number,
  });

  factory RecipeListResponse.fromJson(Map<String, dynamic> json) => RecipeListResponse(
    content: (json['content'] as List).map((item) => RecipeSummary.fromJson(item)).toList(),
    totalElements: json['totalElements'],
    totalPages: json['totalPages'],
    size: json['size'],
    number: json['number'],
  );
}

class RecipeSummary {
  final int id;
  final String title;
  final String description;
  final int? categoryId;
  final List<String> images;
  final List<String> tags;
  final int likesCount;
  final int collectionsCount;
  final String difficulty;
  final int prepTime;
  final int cookTime;
  final int servings;
  final AuthorInfo author;
  final DateTime createdAt;

  RecipeSummary({
    required this.id,
    required this.title,
    required this.description,
    this.categoryId,
    required this.images,
    required this.tags,
    required this.likesCount,
    required this.collectionsCount,
    required this.difficulty,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.author,
    required this.createdAt,
  });

  factory RecipeSummary.fromJson(Map<String, dynamic> json) => RecipeSummary(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    categoryId: json['categoryId'],
    images: List<String>.from(json['images'] ?? []),
    tags: List<String>.from(json['tags'] ?? []),
    likesCount: json['likesCount'] ?? 0,
    collectionsCount: json['collectionsCount'] ?? 0,
    difficulty: json['difficulty'] ?? 'medium',
    prepTime: json['prepTime'] ?? 0,
    cookTime: json['cookTime'] ?? 0,
    servings: json['servings'] ?? 1,
    author: AuthorInfo.fromJson(json['author']),
    createdAt: DateTime.parse(json['createdAt']),
  );
}

class RecipeDetailResponse extends RecipeSummary {
  final bool isPublic;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;
  final DateTime updatedAt;

  RecipeDetailResponse({
    required super.id,
    required super.title,
    required super.description,
    super.categoryId,
    required super.images,
    required super.tags,
    required super.likesCount,
    required super.collectionsCount,
    required super.difficulty,
    required super.prepTime,
    required super.cookTime,
    required super.servings,
    required super.author,
    required super.createdAt,
    required this.isPublic,
    required this.ingredients,
    required this.steps,
    required this.updatedAt,
  });

  factory RecipeDetailResponse.fromJson(Map<String, dynamic> json) => RecipeDetailResponse(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    categoryId: json['categoryId'],
    images: List<String>.from(json['images'] ?? []),
    tags: List<String>.from(json['tags'] ?? []),
    likesCount: json['likesCount'] ?? 0,
    collectionsCount: json['collectionsCount'] ?? 0,
    difficulty: json['difficulty'] ?? 'medium',
    prepTime: json['prepTime'] ?? 0,
    cookTime: json['cookTime'] ?? 0,
    servings: json['servings'] ?? 1,
    author: AuthorInfo.fromJson(json['author']),
    createdAt: DateTime.parse(json['createdAt']),
    isPublic: json['isPublic'] ?? true,
    ingredients: (json['ingredients'] as List).map((item) => RecipeIngredient.fromJson(item)).toList(),
    steps: (json['steps'] as List).map((item) => RecipeStep.fromJson(item)).toList(),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}

class AuthorInfo {
  final int id;
  final String username;
  final String? avatar;

  AuthorInfo({required this.id, required this.username, this.avatar});

  factory AuthorInfo.fromJson(Map<String, dynamic> json) => AuthorInfo(
    id: json['id'],
    username: json['username'],
    avatar: json['avatar'],
  );
}

class RecipeIngredient {
  final int id;
  final String name;
  final String amount;
  final String unit;

  RecipeIngredient({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) => RecipeIngredient(
    id: json['id'],
    name: json['name'],
    amount: json['amount'],
    unit: json['unit'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'amount': amount,
    'unit': unit,
  };
}

class RecipeStep {
  final int id;
  final int stepNumber;
  final String description;
  final List<String> images;

  RecipeStep({
    required this.id,
    required this.stepNumber,
    required this.description,
    required this.images,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) => RecipeStep(
    id: json['id'],
    stepNumber: json['stepNumber'],
    description: json['description'],
    images: List<String>.from(json['images'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'stepNumber': stepNumber,
    'description': description,
    'images': images,
  };
}

class CreateRecipeRequest {
  final String title;
  final String description;
  final int? categoryId;
  final List<String> images;
  final List<String> tags;
  final String difficulty;
  final int prepTime;
  final int cookTime;
  final int servings;
  final bool isPublic;
  final List<RecipeIngredient> ingredients;
  final List<RecipeStep> steps;

  CreateRecipeRequest({
    required this.title,
    required this.description,
    this.categoryId,
    required this.images,
    required this.tags,
    required this.difficulty,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.isPublic,
    required this.ingredients,
    required this.steps,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    if (categoryId != null) 'categoryId': categoryId,
    'images': images,
    'tags': tags,
    'difficulty': difficulty,
    'prepTime': prepTime,
    'cookTime': cookTime,
    'servings': servings,
    'isPublic': isPublic,
    'ingredients': ingredients.map((e) => e.toJson()).toList(),
    'steps': steps.map((e) => e.toJson()).toList(),
  };
}

class UpdateRecipeRequest extends CreateRecipeRequest {
  UpdateRecipeRequest({
    required super.title,
    required super.description,
    super.categoryId,
    required super.images,
    required super.tags,
    required super.difficulty,
    required super.prepTime,
    required super.cookTime,
    required super.servings,
    required super.isPublic,
    required super.ingredients,
    required super.steps,
  });
}