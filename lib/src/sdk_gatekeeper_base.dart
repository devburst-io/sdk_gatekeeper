import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:sdk_gatekeeper/src/entities/add_member_dto.dart';
import 'package:sdk_gatekeeper/src/entities/create_organization_dto.dart';
import 'package:sdk_gatekeeper/src/entities/create_user_dto.dart';
import 'package:sdk_gatekeeper/src/entities/member_entity.dart';
import 'package:sdk_gatekeeper/src/entities/organization_entity.dart';
import 'package:sdk_gatekeeper/src/entities/token_response.dart';
import 'package:sdk_gatekeeper/src/entities/pagination.dart';
import 'package:sdk_gatekeeper/src/entities/user_entity.dart';
import 'package:sdk_gatekeeper/src/gatekeeper_exception.dart';

class SdkGatekeeperBase {
  final String _url;
  static const Duration _timeout = Duration(seconds: 5);

  SdkGatekeeperBase(this._url);
  Future<TokenResponse> login(String email, String password) async {
    final url = Uri.parse('$_url/auth');
    final response = await http
        .post(
          url,
          body: {'email': email, 'password': await _encriptede(password)},
        )
        .timeout(_timeout);
    if (response.statusCode == HttpStatus.created) {
      return TokenResponse.fromJson(json.decode(response.body));
    }
    throw _handleErrorCode(response);
  }

  Future<void> forgotPassword(String email) async {
    final url = Uri.parse('$_url/auth/forgot-password');
    final response = await http
        .post(url, body: {'email': email})
        .timeout(_timeout);
    if (response.statusCode != HttpStatus.noContent) {
      throw _handleErrorCode(response);
    }
  }

  Future<void> resetPassword({
    required String tokenEmail,
    required String password,
  }) async {
    final url = Uri.parse('$_url/auth/reset-password');
    final body = {
      'token': tokenEmail,
      'newPassword': await _encriptede(password),
    };
    log('Request body: ${json.encode(body)}', name: runtimeType.toString());
    final response = await http
        .post(
          url,
          body: json.encode(body),
          headers: {'Content-Type': 'application/json'},
        )
        .timeout(_timeout);
    if (response.statusCode != HttpStatus.noContent) {
      throw _handleErrorCode(response);
    }
  }

  Future<TokenResponse> refreshToken(String token) async {
    final url = Uri.parse('$_url/auth/refresh');
    final response = await http
        .post(url, headers: {'Authorization': 'Bearer $token'})
        .timeout(_timeout);
    if (response.statusCode == HttpStatus.created) {
      return TokenResponse.fromJson(json.decode(response.body));
    }
    throw _handleErrorCode(response);
  }

  Future<Pagination<UserEntity>> getAllUsers(String token) async {
    final url = Uri.parse('$_url/users');
    final response = await http
        .get(url, headers: {'Authorization': 'Bearer $token'})
        .timeout(_timeout);
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
    final url = Uri.parse('$_url/users');
    final response = await http
        .post(url, body: createUser.toJson())
        .timeout(_timeout);
    if (response.statusCode == HttpStatus.created) {
      return UserEntity.fromJson(json.decode(response.body));
    }
    throw _handleErrorCode(response);
  }

  Future<UserEntity> getProfile(String token) async {
    final url = Uri.parse('$_url/users/me');
    final response = await http
        .get(url, headers: {'Authorization': 'Bearer $token'})
        .timeout(_timeout);
    if (response.statusCode == HttpStatus.ok) {
      return UserEntity.fromJson(json.decode(response.body));
    }
    throw _handleErrorCode(response);
  }

  Future<OrganizationEntity> createOrganization({
    required CreateOrganizationDto dto,
    required String token,
  }) async {
    final url = Uri.parse('$_url/organization');
    final response = await http
        .post(
          url,
          body: dto.toMap(),
          headers: {'Authorization': 'Bearer $token'},
        )
        .timeout(_timeout);
    if (response.statusCode == HttpStatus.created) {
      return OrganizationEntity.fromMap(json.decode(response.body));
    }
    throw _handleErrorCode(response);
  }

  Future<Pagination<OrganizationEntity>> getOrganization({
    required String token,
    int page = 1,
    int pageSize = 10,
  }) async {
    final url = Uri.parse('$_url/organization?page=$page&pageSize=$pageSize');

    final response = await http
        .get(url, headers: {'Authorization': 'Bearer $token'})
        .timeout(_timeout);
    if (response.statusCode == HttpStatus.ok) {
      return Pagination.fromJson(
        json.decode(response.body),
        (v) => OrganizationEntity.fromMap(v),
      );
    }
    throw _handleErrorCode(response);
  }

  Future<OrganizationEntity> getOrganizationById(
    String token,
    String id,
  ) async {
    final url = Uri.parse('$_url/organization/$id');
    final response = await http
        .get(url, headers: {'Authorization': 'Bearer $token'})
        .timeout(_timeout);
    if (response.statusCode == HttpStatus.ok) {
      return OrganizationEntity.fromMap(json.decode(response.body));
    }
    throw _handleErrorCode(response);
  }

  Future<OrganizationEntity> patchOrganization({
    required String token,
    required String id,
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse('$_url/organization/$id');
    final response = await http
        .patch(url, body: body, headers: {'Authorization': 'Bearer $token'})
        .timeout(_timeout);
    if (response.statusCode == HttpStatus.ok) {
      return OrganizationEntity.fromMap(json.decode(response.body));
    }
    throw _handleErrorCode(response);
  }

  Future<void> acceptInvite({
    required String acceptToken,
    required String bearerToken,
  }) async {
    final url = Uri.parse('$_url/organization/invitations/accept');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $bearerToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'token': acceptToken}),
    );

    if (response.statusCode != HttpStatus.noContent) {
      throw _handleErrorCode(response);
    }
  }

  Future<MemberEntity> addMember({
    required AddMemberDto dto,
    required String token,
    required String id,
  }) async {
    final url = Uri.parse('$_url/organization/$id/members');
    log(
      'Request body: ${json.encode(dto.toMap())}',
      name: runtimeType.toString(),
    );
    final response = await http
        .post(
          url,
          body: json.encode(dto.toMap()),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        )
        .timeout(_timeout);
    if (response.statusCode == HttpStatus.created) {
      return MemberEntity.fromMap(json.decode(response.body));
    }
    throw _handleErrorCode(response);
  }

  Future<void> deleteMember({
    required String token,
    required String id,
    required String idOrganization,
  }) async {
    final url = Uri.parse('$_url/organization/$idOrganization/members/$id');
    final response = await http
        .delete(url, headers: {'Authorization': 'Bearer $token'})
        .timeout(_timeout);
    if (response.statusCode == HttpStatus.noContent) {
      return;
    }
    throw _handleErrorCode(response);
  }

  Exception _handleErrorCode(Response response) {
    log('Error code: ${response.statusCode}', name: runtimeType.toString());
    log('Error body: ${response.body}', name: runtimeType.toString());
    return GatekeeperException(_getErrorMessage(response));
  }

  String _getErrorMessage(Response response) {
    try {
      final body = json.decode(response.body);
      if (body['message'] is List) {
        return body['message'].join('\n');
      }
      return body['message'];
    } catch (e) {
      return 'Error code: ${response.statusCode}';
    }
  }

  Future<String> _encriptede(String password) async {
    try {
      final keyString = await _getPublicKey();
      final publicKey = RSAKeyParser().parse(keyString) as RSAPublicKey;
      final encrypter = Encrypter(
        RSA(publicKey: publicKey, encoding: RSAEncoding.OAEP),
      );

      return encrypter.encrypt(password).base64;
    } on TimeoutException {
      throw GatekeeperException('Timeout ao tentar encriptar a senha');
    }
  }

  Future<String> _getPublicKey() async {
    final url = Uri.parse('$_url/auth/config/pub');
    final response = await http.get(url).timeout(_timeout);
    if (response.statusCode == HttpStatus.ok) {
      return response.body;
    }
    throw _handleErrorCode(response);
  }
}
