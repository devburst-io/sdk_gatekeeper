import 'package:sdk_gatekeeper/sdk_gatekeeper.dart';

void main() {
  final sdk = SdkGatekeeperBase('localhost:3000');
  sdk.register(
    CreateUser(
      name: 'test',
      email: 'test@test.com',
      password: 'password',
      role: UserRole.common,
    ),
  );
}
