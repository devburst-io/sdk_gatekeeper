import 'package:sdk_gatekeeper/sdk_gatekeeper.dart';
import 'package:test/test.dart';

void main() {
  late String token;
  late String password;
  late String email;
  group('A group success', () {
    final sdk = SdkGatekeeperBase('localhost:3000');

    setUpAll(() {
      password = 'password+${DateTime.now().millisecondsSinceEpoch}';
      email = 'test+${DateTime.now().millisecondsSinceEpoch}@test.com';
    });

    test('Register', () async {
      final result = await sdk.register(
        CreateUser(
          name: 'test',
          email: email,
          password: password,
          role: UserRole.common,
        ),
      );
      expect(result.id, isNotEmpty);
    });

    test('Register with admin role', () async {
      expect(
        () async => await sdk.register(
          CreateUser(
            name: 'test',
            email: 'test+${DateTime.now().millisecondsSinceEpoch}@test.com',
            password: password,
            role: UserRole.admin,
          ),
        ),
        throwsA(isA<GatekeeperException>()),
      );
    });

    test('login', () async {
      final result = await sdk.login(email, password);
      token = result.token;
      expect(result.token, isNotEmpty);
    });

    test('getProfile', () async {
      final result = await sdk.getProfile(token);
      expect(result.id, isNotEmpty);
    });

    test('getAllUsers', () async {
      final result = sdk.getAllUsers(token);
      expect(result, throwsException);
    });

    test('resetPassword', () async {
      await sdk.resetPassword(
        email: email,
        password: 'password1',
        token: token,
      );
    });

    test('forgotPassword', () async {
      await sdk.forgotPassword(email);
    });
  });

  group('A group error', () {
    final sdkGatekeeper = SdkGatekeeperBase('localhost:3000');

    setUpAll(() {
      password = 'password+${DateTime.now().millisecondsSinceEpoch}';
      email = 'test+${DateTime.now().millisecondsSinceEpoch}@test.com';
    });

    test('login throws GatekeeperException on non-201 response', () async {
      expect(
        () async => await sdkGatekeeper.login('test@example.com', 'password'),
        throwsA(isA<GatekeeperException>()),
      );
    });

    test(
      'forgotPassword throws GatekeeperException on non-204 response',
      () async {
        expect(
          () async => await sdkGatekeeper.forgotPassword('test@example.com'),
          throwsA(isA<GatekeeperException>()),
        );
      },
    );

    test(
      'resetPassword throws GatekeeperException on non-204 response',
      () async {
        expect(
          () async => await sdkGatekeeper.resetPassword(
            email: 'test@example.com',
            password: 'newpassword',
            token: 'token',
          ),
          throwsA(isA<GatekeeperException>()),
        );
      },
    );

    test(
      'refreshToken throws GatekeeperException on non-201 response',
      () async {
        expect(
          () async => await sdkGatekeeper.refreshToken('token'),
          throwsA(isA<GatekeeperException>()),
        );
      },
    );

    test(
      'getAllUsers throws GatekeeperException on non-200 response',
      () async {
        expect(
          () async => await sdkGatekeeper.getAllUsers('token'),
          throwsA(isA<GatekeeperException>()),
        );
      },
    );

    test('register throws GatekeeperException on non-201 response', () async {
      final createUser = CreateUser(
        email: 'null+${DateTime.now().millisecondsSinceEpoch}',
        password: 'null',
        name: 'null',
      );

      expect(
        () async => await sdkGatekeeper.register(createUser),
        throwsA(isA<GatekeeperException>()),
      );
    });

    test('getProfile throws GatekeeperException on non-200 response', () async {
      expect(
        () async => await sdkGatekeeper.getProfile('token'),
        throwsA(isA<GatekeeperException>()),
      );
    });
  });
}
