import 'package:sdk_gatekeeper/src/entities/user_role.dart';

class CreateUser {
  final String name;
  final String email;
  final UserRole role;
  String password;

  CreateUser({
    required this.name,
    required this.email,
    this.role = UserRole.admin,
    required this.password,
  });

  Map<String, String> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'role': role.name,
    };
  }
}
