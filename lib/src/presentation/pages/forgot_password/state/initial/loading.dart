import 'package:async/async.dart';

import '../../../../../common/failure.dart';
import 'initial.dart';

class LoadingState extends InitialState {
  final CancelableOperation<Failure?> forgotPassOperation;

  LoadingState({
    required super.passwordController,
    required super.confirmPassController,
    required super.emailFocusNode,
    required super.passwordFocusNode,
    required super.confirmPassFocusNode,
    required super.emailController,
    required super.autovalidateMode,
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
