import '../../../../common/failure.dart';
import 'initial.dart';

class ErrorState extends InitialState {
  final Failure failure;

  const ErrorState({
    required super.emailController,
    required super.passwordController,
    required super.confirmPassController,
    required super.emailFocusNode,
    required super.passwordFocusNode,
    required super.confirmPassFocusNode,
    required super.autovalidateMode,
    required super.formKey,
    required this.failure,
  }) : super();

  @override
  List<Object?> get props => [super.props, failure];
}
