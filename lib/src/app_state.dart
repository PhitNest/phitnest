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
