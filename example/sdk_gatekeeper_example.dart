import 'package:sdk_gatekeeper/sdk_gatekeeper.dart';

void main() {
  final sdk = SdkGatekeeperBase('http://localhost');
  sdk.register(
    CreateUser(
      name: 'test',
      email: 'test@test.com',
      password: 'password',
      role: UserRole.common,
    ),
  );
}
