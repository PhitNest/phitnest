import 'package:async/async.dart';
import 'package:camera/camera.dart';

import 'gym_selected.dart';

class CapturingState extends GymSelectedState {
  final CancelableOperation<XFile> photoCapture;

  const CapturingState({
    required super.firstNameConfirmed,
    required super.location,
    required super.gyms,
    required super.currentPage,
    required super.autovalidateMode,
    required super.gym,
    required super.gymConfirmed,
    required super.cameraController,
    required super.hasReadPhotoInstructions,
    required super.takenEmails,
    required this.photoCapture,
  }) : super();

  @override
  List<Object> get props =>
      [super.props, photoCapture.isCompleted, photoCapture.isCanceled];
}
