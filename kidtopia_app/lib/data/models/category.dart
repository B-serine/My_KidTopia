// models/category.dart
class Category {
  final int? id;
  final String name;
  final String? description;
  final String? imageUrl;
  final String? color;
  final bool isActive;
  final int requiredScore;
  final bool isPremium;

  Category({
    this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.color,
    this.isActive = true,
    this.requiredScore = 0,
    this.isPremium = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'color': color,
      'is_active': isActive ? 1 : 0,
      'required_score': requiredScore,
      'is_premium': isPremium ? 1 : 0,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] is int ? map['id'] : int.tryParse(map['id']?.toString() ?? ''),
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString(),
      imageUrl: map['image_url']?.toString(),
      color: map['color']?.toString(),
      isActive: map['is_active'] == 1,
      requiredScore: map['required_score'] is int ? map['required_score'] : int.tryParse(map['required_score']?.toString() ?? '') ?? 0,
      isPremium: map['is_premium'] == 1,
    );
  }

  Category copyWith({
    int? id,
    String? name,
    String? description,
    String? imageUrl,
    String? color,
    bool? isActive,
    int? requiredScore,
    bool? isPremium,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      color: color ?? this.color,
      isActive: isActive ?? this.isActive,
      requiredScore: requiredScore ?? this.requiredScore,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}
