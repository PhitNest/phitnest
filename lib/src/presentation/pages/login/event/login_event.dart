import 'package:equatable/equatable.dart';

export 'submit.dart';

/// Base event for the login screen
abstract class LoginEvent extends Equatable {
  const LoginEvent() : super();

  @override
  List<Object?> get props => [];
}
