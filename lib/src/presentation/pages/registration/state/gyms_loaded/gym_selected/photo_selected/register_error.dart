import '../../../../../../../common/failure.dart';
import '../../../registration_state.dart';

class RegisterErrorState extends PhotoSelectedState {
  final Failure failure;

  const RegisterErrorState({
    required super.autovalidateMode,
    required super.firstNameConfirmed,
    required super.currentPage,
    required super.gym,
    required super.gyms,
    required super.gymConfirmed,
    required super.location,
    required super.takenEmails,
    required super.cameraController,
    required super.hasReadPhotoInstructions,
    required super.photo,
    required this.failure,
  }) : super();

  @override
  List<Object> get props => [super.props, failure];
}
