enum UserRole {
  admin,
  common;

  factory UserRole.fromString(String value) {
    switch (value.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'common':
        return UserRole.common;
      default:
        throw ArgumentError('Tipo de Role inválido: $value');
    }
  }
}
