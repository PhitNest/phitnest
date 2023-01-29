import '../../../../domain/entities/entities.dart';

class LoginRequest extends Entity<LoginRequest> {
  static const kEmpty = LoginRequest(email: '', password: '');

  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  }) : super();

  @override
  LoginRequest fromJson(Map<String, dynamic> json) => LoginRequest(
        email: json['email'],
        password: json['password'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };

  @override
  List<Object?> get props => [email, password];
}
