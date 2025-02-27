import 'package:sdk_gatekeeper/src/entities/member_entity.dart';

class OrganizationEntity {
  final String id;
  final String name;
  final String? description;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final List<MemberEntity> members;

  OrganizationEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.members,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
      'members': members.map((x) => x.toMap()).toList(),
    };
  }

  factory OrganizationEntity.fromMap(Map<String, dynamic> map) {
    return OrganizationEntity(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      deletedAt: map['deletedAt'],
      members:
          ((map['members'] ?? []) as List)
              .map<MemberEntity>(
                (x) => MemberEntity.fromMap(Map<String, dynamic>.from(x)),
              )
              .toList(),
    );
  }
}
