import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../common/failure.dart';
import '../../../domain/entities/entities.dart';
import '../../adapters/adapters.dart';
import '../../adapters/interfaces/interfaces.dart';

class LoginResponse extends Equatable {
  final AuthEntity session;
  final UserEntity user;

  LoginResponse({
    required this.session,
    required this.user,
  }) : super();

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        session: AuthEntity.fromJson(json['session']),
        user: UserEntity.fromJson(json['user']),
      );

  Map<String, dynamic> toJson() => {
        'session': session.toJson(),
        'user': user.toJson(),
      };

  @override
  List<Object?> get props => [session, user];
}

class RegisterResponse extends UserEntity {
  final String uploadUrl;

  RegisterResponse({
    required super.cognitoId,
    required super.id,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.gymId,
    required super.confirmed,
    required this.uploadUrl,
  }) : super();

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        cognitoId: json['cognitoId'],
        id: json['_id'],
        email: json['email'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        gymId: json['gymId'],
        confirmed: json['confirmed'],
        uploadUrl: json['uploadUrl'],
      );

  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'uploadUrl': uploadUrl,
      };

  @override
  List<Object?> get props => [
        ...super.props,
        uploadUrl,
      ];
}

class AuthDatabase {
  const AuthDatabase();

  Future<Either<LoginResponse, Failure>> login(
          String email, String password) async =>
      httpAdapter.request(
        HttpMethod.post,
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      ).then(
        (either) => either.fold(
          (response) => response.fold(
            (json) => Left(
              LoginResponse.fromJson(json),
            ),
            (list) => Right(kInvalidBackendResponse),
          ),
          (failure) => Right(failure),
        ),
      );

  Future<Either<RegisterResponse, Failure>> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String gymId,
  ) async =>
      httpAdapter.request(
        HttpMethod.post,
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'gymId': gymId,
        },
      ).then(
        (either) => either.fold(
          (response) => response.fold(
            (json) => Left(
              RegisterResponse.fromJson(json),
            ),
            (list) => Right(kInvalidBackendResponse),
          ),
          (failure) => Right(failure),
        ),
      );
}

const authDatabase = AuthDatabase();
