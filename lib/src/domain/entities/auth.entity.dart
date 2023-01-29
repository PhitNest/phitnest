import 'entities.dart';

class AuthEntity extends Entity<AuthEntity> {
  static const kEmpty =
      AuthEntity(accessToken: "", refreshToken: "", idToken: "");

  final String accessToken;
  final String refreshToken;
  final String idToken;

  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.idToken,
  }) : super();

  @override
  AuthEntity fromJson(Map<String, dynamic> json) => AuthEntity(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        idToken: json['idToken'],
      );

  @override
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
