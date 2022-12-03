import 'package:equatable/equatable.dart';

class AuthTokensEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String idToken;

  AuthTokensEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.idToken,
  });

  factory AuthTokensEntity.fromJson(Map<String, dynamic> json) =>
      AuthTokensEntity(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        idToken: json['idToken'],
      );

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'idToken': idToken,
      };

  @override
  List<Object> get props => [accessToken, refreshToken, idToken];
}
