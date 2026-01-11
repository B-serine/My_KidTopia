class Category {
  final int id;
  final String? name;
  final String? description;
  final String? imageUrl;
  final String? color;
  final bool isActive;
  final int? requiredScore;
  final bool isPremium;

  Category({
    required this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.color,
    this.isActive = true,
    this.requiredScore,
    this.isPremium = false,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String?,
      color: json['color'] as String?,
      isActive: json['is_active'] == null ? true : (json['is_active'] == true),
      requiredScore: json['required_score'] != null ? (json['required_score'] as num).toInt() : null,
      isPremium: json['is_premium'] == true || json['isPremium'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'color': color,
      'is_active': isActive,
      'required_score': requiredScore,
      'is_premium': isPremium,
    };
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Category && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
