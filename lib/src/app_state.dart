import 'package:equatable/equatable.dart';

import 'domain/entities/entities.dart';

abstract class AppState extends Equatable {
  const AppState() : super();

  @override
  List<Object> get props => [];
}

class AppInitial extends AppState {
  const AppInitial() : super();
}

class AppRegistered extends AppState {
  final UserEntity user;
  final String password;

  const AppRegistered({
    required this.user,
    required this.password,
  }) : super();

  @override
  List<Object> get props => [...super.props, user, password];
}

class AppAuthenticated extends AppState {
  final String accessToken;
  final String refreshToken;
  final UserEntity user;

  const AppAuthenticated({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  }) : super();

  @override
  List<Object> get props => [...super.props, accessToken, user];
}
