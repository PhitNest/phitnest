import 'package:async/async.dart';

import '../../../../../common/failure.dart';
import 'uploading_base.dart';

/// This is the state for when the user is actively uploading the photo.
class UploadingPhotoState extends UploadingPhotoBaseState {
  /// This is the operation for uploading the photo.
  final CancelableOperation<Failure?> uploadOp;

  const UploadingPhotoState({
    required super.registration,
    required super.password,
    required super.photo,
    required this.uploadOp,
  }) : super();

  @override
  List<Object> get props => [
        uploadOp.isCompleted,
        uploadOp.isCanceled,
      ];
}
