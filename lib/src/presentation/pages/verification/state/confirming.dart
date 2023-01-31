import 'package:async/async.dart';
import 'package:dartz/dartz.dart';

import '../../../../common/failure.dart';
import '../../../../data/data_sources/backend/backend.dart';
import 'verification_state.dart';

class ConfirmingState extends InitialState {
  final CancelableOperation<Either<LoginResponse?, Failure>> operation;

  const ConfirmingState({
    required super.codeController,
    required super.codeFocusNode,
    required this.operation,
  }) : super();

  @override
  List<Object> get props =>
      [super.props, operation.isCanceled, operation.isCompleted];
}
