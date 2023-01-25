import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../common/failure.dart';
import '../../../common/failures.dart';
import '../../../domain/entities/entities.dart';
import '../../adapters/adapters.dart';
import '../../adapters/interfaces/interfaces.dart';
import 'backend.dart';

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

class AuthBackend {
  const AuthBackend();

  Future<Either<LoginResponse, Failure>> login(
    String email,
    String password,
  ) =>
      httpAdapter.request(
        HttpMethod.post,
        Routes.login.path,
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
  ) =>
      httpAdapter.request(
        HttpMethod.post,
        Routes.register.path,
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

  Future<Failure?> forgotPassword(
    String email,
    String password,
  ) =>
      httpAdapter.request(
        HttpMethod.post,
        Routes.forgotPassword.path,
        data: {
          'email': email,
          'password': password,
        },
      ).then(
        (either) => either.fold(
          (response) => response.fold(
            (list) {
              if (list.isEmpty) {
                return Left(null);
              } else {
                return Right(kInvalidBackendResponse);
              }
            },
            (json) => Right(kInvalidBackendResponse),
          ),
          (failure) => failure,
        ),
      );

  Future<Failure?> resendConfirmationCode(String email) => httpAdapter.request(
        HttpMethod.post,
        Routes.resendConfirmationCode.path,
        data: {
          'email': email,
        },
      ).then(
        (either) => either.fold(
          (response) => response.fold(
            (json) => null,
            (list) => kInvalidBackendResponse,
          ),
          (failure) => failure,
        ),
      );

  Future<Either<UserEntity, Failure>> confirmRegister(
    String email,
    String code,
  ) =>
      httpAdapter.request(HttpMethod.post, Routes.confirmRegister.path, data: {
        'email': email,
        'code': code,
      }).then(
        (either) => either.fold(
          (response) => response.fold(
            (json) => Left(
              UserEntity.fromJson(json),
            ),
            (list) => Right(kInvalidBackendResponse),
          ),
          (failure) => Right(failure),
        ),
      );
}

const authBackend = AuthBackend();
