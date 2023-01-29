import '../../../../domain/entities/entities.dart';

class RegisterRequest extends Entity<RegisterRequest> {
  static const kEmpty = RegisterRequest(
    email: '',
    password: '',
    firstName: '',
    lastName: '',
    gymId: '',
  );

  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String gymId;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.gymId,
  }) : super();

  @override
  RegisterRequest fromJson(Map<String, dynamic> json) => RegisterRequest(
        email: json['email'],
        password: json['password'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        gymId: json['gymId'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'gymId': gymId,
      };

  @override
  List<Object?> get props =>
      [email, password, email, password, firstName, lastName, gymId];
}
