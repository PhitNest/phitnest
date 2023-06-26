part of 'bloc.dart';

class LoginState extends Equatable {
  final AutovalidateMode autovalidateMode;

  const LoginState({
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object?> get props => [autovalidateMode];
}
