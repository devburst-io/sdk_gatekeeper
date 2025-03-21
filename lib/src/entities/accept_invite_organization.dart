class AcceptInviteDto {
  final bool success;
  final String message;
  final int statusCode;

  AcceptInviteDto({
    required this.success,
    required this.message,
    required this.statusCode,
  });

  factory AcceptInviteDto.success() {
    return AcceptInviteDto(
      success: true,
      message: 'Convite aceito com sucesso',
      statusCode: 200,
    );
  }

  factory AcceptInviteDto.invalidToken() {
    return AcceptInviteDto(
      success: false,
      message: 'Token inválido ou expirado',
      statusCode: 400,
    );
  }

  factory AcceptInviteDto.unauthorized() {
    return AcceptInviteDto(
      success: false,
      message: 'Não autorizado',
      statusCode: 401,
    );
  }
}
