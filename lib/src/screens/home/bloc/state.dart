part of 'bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState() : super();
}

class HomeLoadingProfilePictureState extends HomeState {
  final CancelableOperation<Image?> loadingOperation;

  const HomeLoadingProfilePictureState({
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [loadingOperation];
}

class HomeLoadedProfilePictureState extends HomeState {
  final Image? profilePicture;

  const HomeLoadedProfilePictureState({
    required this.profilePicture,
  }) : super();

  @override
  List<Object?> get props => [profilePicture];
}
