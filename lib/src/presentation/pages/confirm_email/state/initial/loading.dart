import 'package:async/async.dart';
import 'package:dartz/dartz.dart';

import '../../../../../common/failure.dart';
import '../../../../../domain/entities/entities.dart';
import 'initial.dart';

class LoadingState extends InitialState {
  final CancelableOperation<Either<UserEntity, Failure>> confirmEmailRequest;

  const LoadingState({
    required super.codeController,
    required super.codeFocusNode,
    required this.confirmEmailRequest,
  }) : super();

  @override
  List<Object> get props => [
        super.props,
        confirmEmailRequest.isCanceled,
        confirmEmailRequest.isCompleted
      ];
}
