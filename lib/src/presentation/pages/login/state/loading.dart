import 'package:async/async.dart';

import 'initial.dart';

class LoadingState extends InitialState {
  final CancelableOperation loginOperation;

  const LoadingState({
    required super.autovalidateMode,
    required super.emailController,
    required super.emailFocusNode,
    required super.formKey,
    required super.passwordController,
    required super.passwordFocusNode,
    required super.invalidCredentials,
    required this.loginOperation,
  }) : super();

  @override
  List<Object?> get props =>
      [super.props, loginOperation.isCanceled, loginOperation.isCompleted];
}
