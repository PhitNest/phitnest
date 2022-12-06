import 'package:equatable/equatable.dart';

class SessionRefreshTokensEntity extends Equatable {
  final String accessToken;
  final String idToken;

  const SessionRefreshTokensEntity({
    required this.accessToken,
    required this.idToken,
  });

  factory SessionRefreshTokensEntity.fromJson(Map<String, dynamic> json) =>
      SessionRefreshTokensEntity(
        accessToken: json['accessToken'],
        idToken: json['idToken'],
      );

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'idToken': idToken,
      };

  @override
  List<Object> get props => [accessToken, idToken];
}

class AuthTokensEntity extends SessionRefreshTokensEntity {
  final String refreshToken;

  const AuthTokensEntity({
    required super.accessToken,
    required super.idToken,
    required this.refreshToken,
  });

  factory AuthTokensEntity.fromJson(Map<String, dynamic> json) =>
      AuthTokensEntity(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        idToken: json['idToken'],
      );

  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'refreshToken': refreshToken,
      };

  @override
  List<Object> get props => [...super.props, refreshToken];
}
