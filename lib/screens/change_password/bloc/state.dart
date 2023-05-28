part of 'bloc.dart';

enum ChangePasswordButtonState {
  enabled,
  loading,
}

sealed class ChangePasswordState extends Equatable {
  final AutovalidateMode autovalidateMode;
  final ChangePasswordButtonState changePasswordButtonState;

  const ChangePasswordState({
    required this.autovalidateMode,
    required this.changePasswordButtonState,
  }) : super();

  @override
  List<Object?> get props => [autovalidateMode, changePasswordButtonState];
}

class ChangePasswordInitialState extends ChangePasswordState {
  const ChangePasswordInitialState({
    required super.autovalidateMode,
    required super.changePasswordButtonState,
  }) : super();
}
