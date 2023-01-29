import '../requests.dart';

class ForgotPasswordSubmitRequest extends Request {
  static const kEmpty =
      ForgotPasswordSubmitRequest(email: '', code: '', password: '');

  final String email;
  final String code;
  final String password;

  const ForgotPasswordSubmitRequest({
    required this.email,
    required this.code,
    required this.password,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'code': code,
        'password': password,
      };

  @override
  List<Object?> get props => [email, code, password];
}
