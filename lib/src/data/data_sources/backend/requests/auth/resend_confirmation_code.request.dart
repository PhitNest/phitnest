import '../requests.dart';

class ResendConfirmationRequest extends Request {
  final String email;

  const ResendConfirmationRequest({
    required this.email,
  }) : super();

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
      };

  @override
  List<Object?> get props => [email];
}
