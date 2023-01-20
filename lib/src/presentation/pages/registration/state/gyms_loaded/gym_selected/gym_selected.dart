import 'package:camera/camera.dart';

import '../../../../../../domain/entities/entities.dart';
import '../gyms_loaded.dart';

class GymSelectedState extends GymsLoadedState {
  final GymEntity gym;
  final bool gymConfirmed;
  final CameraController cameraController;
  final bool hasReadPhotoInstructions;
  final Set<String> takenEmails;

  const GymSelectedState({
    required super.firstNameConfirmed,
    required super.location,
    required super.gyms,
    required super.currentPage,
    required super.autovalidateMode,
    required this.gym,
    required this.gymConfirmed,
    required this.cameraController,
    required this.hasReadPhotoInstructions,
    required this.takenEmails,
  }) : super();

  @override
  List<Object> get props =>
      [super.props, gym, gymConfirmed, hasReadPhotoInstructions, takenEmails];
}
