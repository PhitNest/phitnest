part of 'bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent() : super();
}

class HomeLoadedProfilePictureEvent extends HomeEvent {
  final Image? profilePicture;

  const HomeLoadedProfilePictureEvent({
    required this.profilePicture,
  }) : super();

  @override
  List<Object?> get props => [profilePicture];
}
