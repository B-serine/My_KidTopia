class Profile {
  final String id; // uuid
  final String? name;
  final String? username;
  final String? password; // consider removing if using Supabase Auth
  final int? age;
  final String? avatarUrl;
  final int totalScore;
  final bool isPremium;
  final String? fcmToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Profile({
    required this.id,
    this.name,
    this.username,
    this.password,
    this.age,
    this.avatarUrl,
    this.totalScore = 0,
    this.isPremium = false,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      age: json['age'] != null ? (json['age'] as num).toInt() : null,
      avatarUrl: json['avatar_url'] as String? ?? json['avatarUrl'] as String?,
      totalScore: json['total_score'] != null
          ? (json['total_score'] as num).toInt()
          : 0,
      isPremium: json['is_premium'] == true || json['isPremium'] == true,
      fcmToken: json['fcm_token'] as String? ?? json['fcmToken'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      // Do NOT send raw password to the server. Passwords must be handled
      // by Supabase Auth or stored as hashes/salts in dedicated columns.
      'age': age,
      'avatar_url': avatarUrl,
      'total_score': totalScore,
      'is_premium': isPremium,
      'fcm_token': fcmToken,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Profile copyWith({
    String? id,
    String? name,
    String? username,
    String? password,
    int? age,
    String? avatarUrl,
    int? totalScore,
    bool? isPremium,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      age: age ?? this.age,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalScore: totalScore ?? this.totalScore,
      isPremium: isPremium ?? this.isPremium,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username;

  @override
  int get hashCode => id.hashCode ^ (username?.hashCode ?? 0);
}
