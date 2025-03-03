enum RoleMemberEnum {
  owner,
  admin,
  member;

  factory RoleMemberEnum.fromString(String value) {
    switch (value.toLowerCase()) {
      case 'admin':
        return RoleMemberEnum.admin;
      case 'member':
        return RoleMemberEnum.member;
      case 'owner':
        return RoleMemberEnum.owner;
      default:
        throw ArgumentError('Tipo de Role inválido: $value');
    }
  }
  @override
  String toString() => name;
}
