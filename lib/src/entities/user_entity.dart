import 'package:sdk_gatekeeper/sdk_gatekeeper.dart';

class UserEntity {
  final String id;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String name;
  final List<OrganizationEntity> organizations;

  UserEntity({
    required this.id,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.name,
    required this.organizations,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      organizations:
          ((json['organizations'] ?? []) as List)
              .map(
                (e) => OrganizationEntity.fromMap(Map<String, dynamic>.from(e)),
              )
              .toList(),
      name: json['name'],
      id: json['id'],
      email: json['email'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      deletedAt:
          json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'deletedAt': deletedAt?.toString(),
      'organizations': organizations.map((e) => e.toMap()).toList(),
    };
  }
}
