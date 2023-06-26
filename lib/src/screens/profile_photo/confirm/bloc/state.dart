part of 'bloc.dart';

sealed class ConfirmPhotoState extends Equatable {
  const ConfirmPhotoState() : super();
}

class ConfirmPhotoInitialState extends ConfirmPhotoState {
  const ConfirmPhotoInitialState() : super();

  @override
  List<Object?> get props => [];
}

class ConfirmPhotoLoadingState extends ConfirmPhotoState {
  final CancelableOperation<Failure?> loadingOperation;

  const ConfirmPhotoLoadingState({
    required this.loadingOperation,
  }) : super();

  @override
  List<Object?> get props => [loadingOperation];
}

class ConfirmPhotoFailureState extends ConfirmPhotoState {
  final Failure error;

  const ConfirmPhotoFailureState({
    required this.error,
  }) : super();

  @override
  List<Object?> get props => [error];
}

class ConfirmPhotoSuccessState extends ConfirmPhotoState {
  const ConfirmPhotoSuccessState() : super();

  @override
  List<Object?> get props => [];
}
