import '../../../../domain/entities/entity.dart';

class ResendConfirmationRequest extends Entity<ResendConfirmationRequest> {
  static const kEmpty = ResendConfirmationRequest(email: '');

  final String email;

  const ResendConfirmationRequest({
    required this.email,
  }) : super();

  @override
  ResendConfirmationRequest fromJson(Map<String, dynamic> json) =>
      ResendConfirmationRequest(
        email: json['email'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
      };

  @override
  List<Object?> get props => [email];
}
