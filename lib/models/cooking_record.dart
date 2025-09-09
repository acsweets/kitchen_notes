class CookingRecord {
  String id;
  String recipeId;
  String recipeName;
  DateTime cookingDate;
  double rating;
  String notes;
  List<String> images;

  CookingRecord({
    required this.id,
    required this.recipeId,
    required this.recipeName,
    required this.cookingDate,
    required this.rating,
    this.notes = '',
    this.images = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipe_id': recipeId,
      'recipe_name': recipeName,
      'cooking_date': cookingDate.millisecondsSinceEpoch,
      'rating': rating,
      'notes': notes,
      'images': images.join(','),
    };
  }

  factory CookingRecord.fromMap(Map<String, dynamic> map) {
    return CookingRecord(
      id: map['id'],
      recipeId: map['recipe_id'],
      recipeName: map['recipe_name'],
      cookingDate: DateTime.fromMillisecondsSinceEpoch(map['cooking_date']),
      rating: map['rating'],
      notes: map['notes'] ?? '',
      images: map['images'].toString().isEmpty 
          ? [] 
          : map['images'].toString().split(','),
    );
  }
}