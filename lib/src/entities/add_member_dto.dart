import 'package:sdk_gatekeeper/sdk_gatekeeper.dart';

class AddMemberDto {
  final RoleMemberEnum role;
  final String email;

  AddMemberDto({required this.role, required this.email});

  Map<String, String> toMap() {
    return {'role': role.name, 'email': email};
  }
}
