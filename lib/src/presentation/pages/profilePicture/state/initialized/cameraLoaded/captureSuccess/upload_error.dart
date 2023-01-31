import '../../../../../../../common/failure.dart';
import 'capture_success.dart';

class UploadErrorState extends CaptureSuccessState {
  final Failure failure;

  const UploadErrorState({
    required super.cameraController,
    required super.file,
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [super.props, failure];
}
