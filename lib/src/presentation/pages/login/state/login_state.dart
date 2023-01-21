import 'package:equatable/equatable.dart';

export 'initial.dart';

/// Base state for the login screen
abstract class LoginState extends Equatable {
  const LoginState() : super();

  @override
  List<Object?> get props => [];
}
