part of 'form.dart';

final class FormBlocState extends Equatable {
  final AutovalidateMode autovalidateMode;

  const FormBlocState({
    required this.autovalidateMode,
  }) : super();

  @override
  List<Object?> get props => [autovalidateMode];
}
