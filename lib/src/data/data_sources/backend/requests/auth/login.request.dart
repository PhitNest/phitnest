import '../requests.dart';

class LoginRequest extends Request {
  static const kEmpty = LoginRequest(email: '', password: '');

  final String email;
  final String password;

  const LoginRequest({
    required this.email,
    required this.password,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };

  @override
  List<Object?> get props => [email, password];
}
