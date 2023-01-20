import 'package:image_picker/image_picker.dart';

import '../gym_selected.dart';

class PhotoSelectedState extends GymSelectedState {
  final XFile photo;

  const PhotoSelectedState({
    required super.autovalidateMode,
    required super.gym,
    required super.gyms,
    required super.gymConfirmed,
    required super.firstNameConfirmed,
    required super.currentPage,
    required super.takenEmails,
    required super.location,
    required super.cameraController,
    required super.hasReadPhotoInstructions,
    required this.photo,
  }) : super();

  @override
  List<Object> get props => [super.props, photo];
}
