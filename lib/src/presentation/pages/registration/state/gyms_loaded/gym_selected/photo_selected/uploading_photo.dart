import 'package:async/async.dart';

import '../../../../../../../common/failure.dart';
import 'photo_selected.dart';

class UploadingPhotoState extends PhotoSelectedState {
  final CancelableOperation<Failure?> uploadOp;

  const UploadingPhotoState({
    required super.firstNameConfirmed,
    required super.location,
    required super.gym,
    required super.autovalidateMode,
    required super.currentPage,
    required super.gyms,
    required super.takenEmails,
    required super.gymConfirmed,
    required super.cameraController,
    required super.hasReadPhotoInstructions,
    required super.photo,
    required this.uploadOp,
  }) : super();

  @override
  List<Object> get props => [
        super.props,
        uploadOp.isCompleted,
        uploadOp.isCanceled,
      ];
}
