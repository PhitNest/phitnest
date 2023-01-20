import '../../../../../../common/failure.dart';
import 'gym_selected.dart';

class CameraErrorState extends GymSelectedState {
  final Failure failure;

  CameraErrorState({
    required super.firstNameConfirmed,
    required super.location,
    required super.gyms,
    required super.currentPage,
    required super.autovalidateMode,
    required super.gym,
    required super.gymConfirmed,
    required super.takenEmails,
    required super.cameraController,
    required super.hasReadPhotoInstructions,
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [super.props, failure];
}
