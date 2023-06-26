part of 'bloc.dart';

class RegisterState extends Equatable {
  final AutovalidateMode autovalidateMode;

  const RegisterState({
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object?> get props => [autovalidateMode];
}
