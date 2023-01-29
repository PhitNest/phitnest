import '../../../../domain/entities/entity.dart';

class ForgotPasswordRequest extends Entity<ForgotPasswordRequest> {
  static const kEmpty = ForgotPasswordRequest(email: '');

  final String email;

  const ForgotPasswordRequest({
    required this.email,
  }) : super();

  @override
  ForgotPasswordRequest fromJson(Map<String, dynamic> json) =>
      ForgotPasswordRequest(
        email: json['email'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
      };

  @override
  List<Object?> get props => [email];
}
