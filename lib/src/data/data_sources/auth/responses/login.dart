import '../../../../domain/entities/entities.dart';

class LoginResponse extends Entity<LoginResponse> {
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
        session: Entities.fromJson(json['session']),
        user: Entities.fromJson(json['user']),
      );

  @override
  Map<String, dynamic> toJson() => {
        'session': session.toJson(),
        'user': user.toJson(),
      };

  @override
  List<Object?> get props => [session, user];
}
