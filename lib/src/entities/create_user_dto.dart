class CreateUser {
  final String name;
  final String email;
  final String role;
  String password;

  CreateUser({
    required this.name,
    required this.email,
    required this.role,
    required this.password,
  });

  Map<String, String> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
