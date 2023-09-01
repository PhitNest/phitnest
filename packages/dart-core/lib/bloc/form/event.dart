part of 'form.dart';

final class FormSetValidationEvent extends Equatable {
  final AutovalidateMode autovalidateMode;

  const FormSetValidationEvent(this.autovalidateMode) : super();

  @override
  List<Object?> get props => [autovalidateMode];
}
