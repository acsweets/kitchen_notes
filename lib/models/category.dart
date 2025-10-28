class Category {
  String id;
  String name;
  String type; // 'recipe' or 'ingredient'
  bool isDefault;

  Category({
    required this.id,
    required this.name,
    required this.type,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'is_default': isDefault ? 1 : 0,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      isDefault: map['is_default'] == 1,
    );
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      isDefault: json['isDefault'] ?? false,
    );
  }
}