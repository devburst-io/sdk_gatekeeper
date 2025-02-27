import 'package:sdk_gatekeeper/sdk_gatekeeper.dart';

class AddMemberDto {
  final UserRole role;
  final String email;

  AddMemberDto({required this.role, required this.email});

  Map<String, String> toMap() {
    return {'name': role.name, 'email': email};
  }
}
