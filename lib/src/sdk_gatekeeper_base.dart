import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:sdk_gatekeeper/src/entities/create_user_dto.dart';
import 'package:sdk_gatekeeper/src/entities/token_response.dart';
import 'package:sdk_gatekeeper/src/entities/pagination.dart';
import 'package:sdk_gatekeeper/src/entities/user_entity.dart';
import 'package:sdk_gatekeeper/src/gatekeeper_exception.dart';

class SdkGatekeeperBase {
  final String authority;

  SdkGatekeeperBase(this.authority);
  Future<TokenResponse> login(String email, String password) async {
    final url = Uri.http(
      authority,
      '/auth',
    );
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': await _encriptede(password),
      },
    );
    if (response.statusCode == HttpStatus.created) {
      return TokenResponse.fromJson(json.decode(response.body));
    }
    throw _handleErrorCode(response);
  }

  Future<void> forgotPassword(String email) async {
    final url = Uri.http(
      authority,
      '/auth/forgot-password',
    );
    final response = await http.post(
      url,
      body: {
        'email': email,
      },
    );
    if (response.statusCode != HttpStatus.noContent) {
      throw _handleErrorCode(response);
    }
  }

  Future<void> resetPassword({
    required String email,
    required String password,
    required String token,
  }) async {
    final url = Uri.http(
      authority,
      '/auth/reset-password',
    );
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': await _encriptede(password),
      },
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != HttpStatus.noContent) {
      throw _handleErrorCode(response);
    }
  }

  Future<TokenResponse> refreshToken(String token) async {
    final url = Uri.http(
      authority,
      '/auth/refresh',
    );
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == HttpStatus.created) {
      return TokenResponse.fromJson(json.decode(response.body));
    }
    throw _handleErrorCode(response);
  }

  Future<Pagination<UserEntity>> getAllUsers(String token) async {
    final url = Uri.http(
      authority,
      '/users',
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == HttpStatus.ok) {
      return Pagination.fromJson(
        json.decode(response.body),
        (json) => UserEntity.fromJson(json),
      );
    }
    throw _handleErrorCode(response);
  }

  Future<UserEntity> register(CreateUser createUser) async {
    createUser.password = await _encriptede(createUser.password);
    final url = Uri.http(
      authority,
      '/users',
    );
    final response = await http.post(
      url,
      body: createUser.toJson(),
    );
    if (response.statusCode == HttpStatus.created) {
      return UserEntity.fromJson(json.decode(response.body));
    }
    throw _handleErrorCode(response);
  }

  Future<UserEntity> getProfile(String token) async {
    final url = Uri.http(
      authority,
      '/users/me',
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == HttpStatus.ok) {
      return UserEntity.fromJson(json.decode(response.body));
    }
    throw _handleErrorCode(response);
  }

  Exception _handleErrorCode(Response response) {
    log('Error code: ${response.statusCode}');
    log('Error body: ${response.body}');
    return GatekeeperException('Error code: ${response.statusCode}');
  }

  Future<String> _encriptede(String password) async {
    final keyString = await _getPublicKey();
    final publicKey = RSAKeyParser().parse(keyString) as RSAPublicKey;
    final encrypter = Encrypter(
      RSA(
        publicKey: publicKey,
        encoding: RSAEncoding.OAEP,
      ),
    );

    return encrypter.encrypt(password).base64;
  }

  Future<String> _getPublicKey() async {
    final url = Uri.http(
      authority,
      '/auth/config/pub',
    );
    final response = await http.get(url);
    if (response.statusCode == HttpStatus.ok) {
      return response.body;
    }
    throw _handleErrorCode(response);
  }
}
