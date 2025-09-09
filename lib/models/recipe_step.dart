class RecipeStep {
  int order;
  String description;
  List<String> images;

  RecipeStep({
    required this.order,
    required this.description,
    this.images = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'step_order': order,
      'description': description,
      'images': images.join(','),
    };
  }

  factory RecipeStep.fromMap(Map<String, dynamic> map) {
    return RecipeStep(
      order: map['step_order'],
      description: map['description'],
      images: map['images'].toString().isEmpty 
          ? [] 
          : map['images'].toString().split(','),
    );
  }
}