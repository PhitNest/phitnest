import '../../../../domain/entities/entity.dart';

class ConfirmRegisterRequest extends Entity<ConfirmRegisterRequest> {
  static const kEmpty = ConfirmRegisterRequest(email: '', code: '');

  final String email;
  final String code;

  const ConfirmRegisterRequest({
    required this.email,
    required this.code,
  }) : super();

  @override
  ConfirmRegisterRequest fromJson(Map<String, dynamic> json) =>
      ConfirmRegisterRequest(
        email: json['email'],
        code: json['code'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'code': code,
      };

  @override
  List<Object?> get props => [email, code];
}
