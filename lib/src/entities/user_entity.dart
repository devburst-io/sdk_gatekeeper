class UserEntity {
  final String id;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  UserEntity({
    required this.id,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'],
      email: json['email'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, String?>{
      'id': id,
      'email': email,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'deletedAt': deletedAt?.toString(),
    };
  }
}
