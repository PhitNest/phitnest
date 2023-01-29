import '../../../../domain/entities/entity.dart';

class ForgotPasswordSubmitRequest extends Entity<ForgotPasswordSubmitRequest> {
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
  ForgotPasswordSubmitRequest fromJson(Map<String, dynamic> json) =>
      ForgotPasswordSubmitRequest(
        email: json['email'],
        code: json['code'],
        password: json['password'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'code': code,
        'password': password,
      };

  @override
  List<Object?> get props => [email, code, password];
}
