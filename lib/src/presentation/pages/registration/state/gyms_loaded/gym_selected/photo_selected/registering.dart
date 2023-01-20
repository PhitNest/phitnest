import 'package:async/async.dart';
import 'package:dartz/dartz.dart';

import '../../../../../../../common/failure.dart';
import '../../../../../../../data/data_sources/backend/backend.dart';
import 'photo_selected.dart';

class RegisteringState extends PhotoSelectedState {
  final CancelableOperation<Either<RegisterResponse, Failure>> registerOp;

  const RegisteringState({
    required super.autovalidateMode,
    required super.gym,
    required super.gyms,
    required super.takenEmails,
    required super.gymConfirmed,
    required super.firstNameConfirmed,
    required super.currentPage,
    required super.location,
    required super.cameraController,
    required super.hasReadPhotoInstructions,
    required super.photo,
    required this.registerOp,
  }) : super();

  @override
  List<Object> get props => [
        super.props,
        registerOp.isCompleted,
        registerOp.isCanceled,
      ];
}
