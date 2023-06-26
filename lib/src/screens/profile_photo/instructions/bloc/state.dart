part of 'bloc.dart';

sealed class PhotoInstructionsState extends Equatable {
  const PhotoInstructionsState() : super();
}

class PhotoInstructionsInitialState extends PhotoInstructionsState {
  const PhotoInstructionsInitialState() : super();

  @override
  List<Object?> get props => [];
}

class PhotoInstructionsPickingState extends PhotoInstructionsState {
  final CancelableOperation<XFile?> pickingOperation;

  const PhotoInstructionsPickingState({
    required this.pickingOperation,
  }) : super();

  @override
  List<Object?> get props => [pickingOperation];
}

class PhotoInstructionsNoPictureState extends PhotoInstructionsState {
  const PhotoInstructionsNoPictureState() : super();

  @override
  List<Object?> get props => [];
}

class PhotoInstructionsPickedState extends PhotoInstructionsState {
  final XFile photo;

  const PhotoInstructionsPickedState({
    required this.photo,
  }) : super();

  @override
  List<Object?> get props => [photo];
}
