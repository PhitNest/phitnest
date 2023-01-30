import '../requests.dart';

class ConfirmRegisterRequest extends Request {
  final String email;
  final String code;

  const ConfirmRegisterRequest({
    required this.email,
    required this.code,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'code': code,
      };

  @override
  List<Object?> get props => [email, code];
}
