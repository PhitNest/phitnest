part of 'bloc.dart';

sealed class ConfirmPhotoEvent extends Equatable {
  const ConfirmPhotoEvent() : super();
}

class ConfirmPhotoConfirmEvent extends ConfirmPhotoEvent {
  final Session session;

  const ConfirmPhotoConfirmEvent({
    required this.session,
  }) : super();

  @override
  List<Object?> get props => [session];
}

class ConfirmPhotoResponseEvent extends ConfirmPhotoEvent {
  final Failure? error;

  const ConfirmPhotoResponseEvent({
    required this.error,
  }) : super();

  @override
  List<Object?> get props => [error];
}
