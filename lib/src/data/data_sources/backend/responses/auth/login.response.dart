import '../../../../../domain/entities/entities.dart';
import '../responses.dart';

class LoginResponse extends Response<LoginResponse> {
  static const kEmpty = LoginResponse(
    session: AuthEntity.kEmpty,
    user: UserEntity.kEmpty,
  );

  final AuthEntity session;
  final UserEntity user;

  const LoginResponse({
    required this.session,
    required this.user,
  }) : super();

  @override
  LoginResponse fromJson(Map<String, dynamic> json) => LoginResponse(
        session: Entity.jsonFactory(json['session']),
        user: Entity.jsonFactory(json['user']),
      );

  @override
  List<Object?> get props => [session, user];
}
