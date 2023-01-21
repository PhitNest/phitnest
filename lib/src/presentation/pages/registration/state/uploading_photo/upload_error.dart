import '../../../../../common/failure.dart';
import 'uploading_base.dart';

/// This is the state for when the upload operation fails.
class UploadErrorState extends UploadingPhotoBaseState {
  final Failure failure;

  const UploadErrorState({
    required super.photo,
    required super.registration,
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [super.props, failure];
}
