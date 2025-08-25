class CategoryResponse {
  final int id;
  final String name;
  final String description;
  final String icon;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryResponse({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) => CategoryResponse(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    icon: json['icon'],
    isDefault: json['isDefault'] ?? false,
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}

class CreateCategoryRequest {
  final String name;
  final String description;
  final String icon;

  CreateCategoryRequest({
    required this.name,
    required this.description,
    required this.icon,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'icon': icon,
  };
}

class UpdateCategoryRequest {
  final String name;
  final String description;
  final String icon;

  UpdateCategoryRequest({
    required this.name,
    required this.description,
    required this.icon,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'icon': icon,
  };
}