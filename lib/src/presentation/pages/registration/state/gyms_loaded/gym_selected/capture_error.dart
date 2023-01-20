import '../../../../../../common/failure.dart';
import 'gym_selected.dart';

class CaptureErrorState extends GymSelectedState {
  final Failure failure;

  CaptureErrorState({
    required super.firstNameConfirmed,
    required super.location,
    required super.gyms,
    required super.currentPage,
    required super.autovalidateMode,
    required super.gym,
    required super.gymConfirmed,
    required super.cameraController,
    required super.takenEmails,
    required super.hasReadPhotoInstructions,
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [super.props, failure];
}
