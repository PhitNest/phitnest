part of 'bloc.dart';

class ChangePasswordState extends Equatable {
  final AutovalidateMode autovalidateMode;

  const ChangePasswordState({
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object?> get props => [autovalidateMode];
}
