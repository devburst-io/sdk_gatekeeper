import 'package:sdk_gatekeeper/src/entities/user_entity.dart';

class TokenResponse {
  final String token;
  final String refreshToken;
  final int tokenExpires;
  final UserEntity data;

  TokenResponse({
    required this.token,
    required this.refreshToken,
    required this.tokenExpires,
    required this.data,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      token: json['token'],
      refreshToken: json['refreshToken'],
      tokenExpires: json['tokenExpires'],
      data: UserEntity.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'refreshToken': refreshToken,
      'tokenExpires': tokenExpires,
      'data': data.toMap(),
    };
  }
}
