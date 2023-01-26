import 'package:async/async.dart';

import 'initial.dart';

class ForgotPasswordLoadingState extends ForgotPasswordInitialState {
  final CancelableOperation forgotPassOperation;

  ForgotPasswordLoadingState({
    required super.passwordController,
    required super.confirmPassController,
    required super.emailFocusNode,
    required super.passwordFocusNode,
    required super.confirmPassFocusNode,
    required super.emailController,
    required super.autoValidateMode,
    required super.formKey,
    required this.forgotPassOperation,
  }) : super();

  @override
  List<Object?> get props => [
        super.props,
        forgotPassOperation.isCompleted,
        forgotPassOperation.isCanceled,
      ];
}
