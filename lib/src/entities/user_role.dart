enum UserRole {
  admin,
  common,
  owner;

  factory UserRole.fromString(String value) {
    switch (value.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'common':
        return UserRole.common;
      case 'owner':
        return UserRole.owner;
      default:
        throw ArgumentError('Tipo de Role inválido: $value');
    }
  }
  @override
  String toString() => name;
}
