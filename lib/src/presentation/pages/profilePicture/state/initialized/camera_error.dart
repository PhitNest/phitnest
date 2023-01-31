import '../../../../../common/failure.dart';
import 'initialized.dart';

class CameraErrorState extends InitializedState {
  final Failure failure;

  const CameraErrorState({
    required super.cameraController,
    required this.failure,
  }) : super();

  @override
  List<Object?> get props => [super.props, failure];
}
