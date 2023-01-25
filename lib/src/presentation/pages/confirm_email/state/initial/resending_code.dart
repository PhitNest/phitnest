import 'package:async/async.dart';

import '../../../../../common/failure.dart';
import '../../../login/state/initial.dart';

class ResendingCodeState extends InitialState {
  final CancelableOperation<Failure?> resendCodeRequest;

  const ResendingCodeState({
    required super.autovalidateMode,
    required super.emailController,
    required super.emailFocusNode,
    required super.formKey,
    required super.passwordController,
    required super.passwordFocusNode,
    required super.invalidCredentials,
    required this.resendCodeRequest,
  }) : super();

  @override
  List<Object> get props => [
        super.props,
        resendCodeRequest.isCanceled,
        resendCodeRequest.isCompleted
      ];
}
