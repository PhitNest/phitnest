import 'package:async/async.dart';

import '../../../../../common/failure.dart';
import '../verification_state.dart';

class LoadingState extends InitialState {
  final CancelableOperation<Failure?> operation;

  const LoadingState({
    required super.codeController,
    required super.codeFocusNode,
    required this.operation,
  }) : super();

  @override
  List<Object> get props =>
      [super.props, operation.isCanceled, operation.isCompleted];
}
