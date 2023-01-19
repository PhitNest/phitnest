import 'package:equatable/equatable.dart';

import 'domain/entities/entities.dart';

abstract class AppEvent extends Equatable {
  const AppEvent() : super();

  @override
  List<Object> get props => [];
}

class RegisteredEvent extends AppEvent {
  final UserEntity user;
  final String password;

  const RegisteredEvent({
    required this.user,
    required this.password,
  }) : super();

  @override
  List<Object> get props => [...super.props, user, password];
}
