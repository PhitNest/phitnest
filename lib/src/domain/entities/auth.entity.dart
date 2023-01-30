import '../../common/utils/utils.dart';
import 'entities.dart';

class AuthParser extends Parser<AuthEntity> {
  const AuthParser() : super();

  @override
  AuthEntity fromJson(Map<String, dynamic> json) => AuthEntity(
        accessToken: json['accessToken'],
        refreshToken: json['refreshToken'],
        idToken: json['idToken'],
      );
}

class AuthEntity extends Entity {
  final String accessToken;
  final String refreshToken;
  final String idToken;

  const AuthEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.idToken,
  }) : super();

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
