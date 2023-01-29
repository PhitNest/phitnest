import '../requests.dart';

class ForgotPasswordRequest extends Request {
  static const kEmpty = ForgotPasswordRequest(email: '');

  final String email;

  const ForgotPasswordRequest({
    required this.email,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
      };

  @override
  List<Object?> get props => [email];
}
