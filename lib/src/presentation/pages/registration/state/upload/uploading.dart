import 'package:async/async.dart';

import '../../../../../common/failure.dart';
import 'upload.dart';

class UploadingState extends UploadState {
  final CancelableOperation<Failure?> uploadImage;

  const UploadingState({
    required super.response,
    required super.password,
    required super.file,
    required this.uploadImage,
  }) : super();

  @override
  List<Object> get props =>
      [super.props, uploadImage.isCanceled, uploadImage.isCompleted];
}
