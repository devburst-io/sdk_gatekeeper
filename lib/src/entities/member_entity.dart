import 'package:sdk_gatekeeper/sdk_gatekeeper.dart';

class MemberEntity {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final RoleMemberEnum role;
  final UserEntity user;
  final OrganizationEntity? organization;

  MemberEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.role,
    required this.user,
    required this.organization,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt.toString(),
      'updatedAt': updatedAt.toString(),
      'deletedAt': deletedAt?.toString(),
      'role': role.name,
      'user': user.toMap(),
      'organization': organization?.toMap(),
    };
  }

  factory MemberEntity.fromMap(Map<String, dynamic> map) {
    return MemberEntity(
      id: map['id'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      deletedAt:
          map['deletedAt'] != null ? DateTime.parse(map['deletedAt']) : null,
      role: RoleMemberEnum.fromString(map['role']),
      user: UserEntity.fromJson(map['user']),
      organization:
          map['organization'] != null
              ? OrganizationEntity.fromMap(map['organization'])
              : null,
    );
  }
}
