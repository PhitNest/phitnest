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

class AuthDatabase {
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
}

final authDatabase = AuthDatabase();
