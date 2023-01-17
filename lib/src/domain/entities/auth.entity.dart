import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String idToken;

  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.idToken,
  }) : super();

  factory AuthEntity.fromJson(Map<String, dynamic> json) => AuthEntity(
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
  List<Object> get props => [
        accessToken,
        refreshToken,
        idToken,
      ];
}
