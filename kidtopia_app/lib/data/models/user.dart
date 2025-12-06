class User {
  final int? id;
  final String name;
  final String? password;
  final int? age;
  final String? avatarUrl;
  final int totalScore;
  final bool isPremium;
  final String? createdAt;

  User({
    this.id,
    required this.name,
    this.password,
    this.age,
    this.avatarUrl,
    this.totalScore = 0,
    this.isPremium = false,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'age': age,
      'avatar_url': avatarUrl,
      'total_score': totalScore,
      'is_premium': isPremium ? 1 : 0,
      'created_at': createdAt,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] is int
          ? map['id']
          : int.tryParse(map['id']?.toString() ?? ''),
      name: map['name']?.toString() ?? '',
      password: map['password']?.toString(),
      age: map['age'] is int
          ? map['age']
          : int.tryParse(map['age']?.toString() ?? ''),
      avatarUrl: map['avatar_url']?.toString(),
      totalScore: map['total_score'] is int
          ? map['total_score']
          : int.tryParse(map['total_score']?.toString() ?? '') ?? 0,
      isPremium: map['is_premium'] == 1,
      createdAt: map['created_at']?.toString(),
    );
  }

  User copyWith({
    int? id,
    String? name,
    String? password,
    int? age,
    String? avatarUrl,
    int? totalScore,
    bool? isPremium,
    String? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      age: age ?? this.age,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalScore: totalScore ?? this.totalScore,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
